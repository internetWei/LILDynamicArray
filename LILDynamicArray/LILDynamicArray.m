//
//  DynamicArray.m
//  DynamicArray
//
//  Created by LL on 2022/7/15.
//

#import "LILDynamicArray.h"

static const NSInteger DEFAULT_COUNT = 4 * 4;
static const unsigned long WORD_MASK = 15UL;

@interface LILDynamicArray () {
    @private
    void **_array;/**< 数组首地址*/
    NSInteger _count;/**< 数组元素个数*/
    NSInteger _size;/**< 数组总大小*/
    unsigned long _isMutated;/**< 用于forin遍历时判断数组是否突变*/
}

@end

@implementation LILDynamicArray

FOUNDATION_STATIC_INLINE NSInteger word_align(NSInteger unalignedSize) {
    return (unalignedSize + WORD_MASK) & ~WORD_MASK;
}

- (instancetype)init {
    return [self initWithCapacity:DEFAULT_COUNT];
}

- (instancetype)initWithCapacity:(NSUInteger)numItems {
    if (self = [super init]) {
        NSInteger unlignedSize = (NSInteger)numItems > DEFAULT_COUNT ? numItems : DEFAULT_COUNT;
        _size = word_align(unlignedSize);
        _array = malloc(_size * sizeof(id));
    }
    return self;
}

- (void)dealloc {
    [self removeAllObjects];
    free(_array);
}

- (BOOL)containsObject:(const id)anObject {
    return [self indexOfObject:anObject] != NSNotFound;
}

- (void)addObject:(const id)anObject {
    [self setObject:anObject atIndexedSubscript:_count];
}

- (nullable id)setObject:(const id)anObject atIndexedSubscript:(NSUInteger)index {
    _isMutated = 1;
    NSAssert(anObject, @"数组元素不能为nil");
    if (!anObject) return nil;
    if (![self p_verifyIndex2:index]) return nil;
    
    if ((NSInteger)index == _count) {
        return [self insertObject:anObject atIndex:index];
    }
    
    id oldObject = (__bridge_transfer id)_array[index];
    _array[index] = (__bridge_retained void *)anObject;
    return oldObject;
}

- (nullable id)insertObject:(const id)anObject atIndex:(NSUInteger)index {
    _isMutated = 1;
    NSAssert(anObject, @"数组元素不能为nil");
    if (!anObject) return nil;
    if (![self p_verifyIndex2:index]) return nil;
    
    // 数组需要扩容。
    if (_count == _size) {
        if (![self p_reallocArray]) return nil;
    }
    
    // 将数组中index右侧元素全部往右移动1位。
    if (index < _count) {
        memmove(&_array[index + 1], &_array[index], (_count - index) * sizeof(id));
    }
    
    _array[index] = (__bridge_retained void *)anObject;
    _count += 1;
    
    // 在数组的最后1位插入。
    if (index == _count - 1) return nil;
    return (__bridge id)_array[index + 1];
}

- (nullable id)removeObjectAtIndex:(NSUInteger)index {
    _isMutated = 1;
    if (![self p_verifyIndex1:index]) return nil;
    
    id oldObject = CFBridgingRelease(_array[index]);
    
    // 将数组中index右侧元素全部往左移动1位。
    if (index < _count - 1) {
        memmove(&_array[index], &_array[index + 1], (_count - 1 - index) * sizeof(id));
    }
    
    _count -= 1;
    _array[_count] = NULL;
    
    return oldObject;
}

- (NSUInteger)indexOfObject:(const id)anObject {
    if (!anObject) return NSNotFound;
    
    for (NSInteger index = 0; index < _count; index++) {
        if ([self[index] isEqual:anObject]) return index;
    }
    
    return NSNotFound;
}

- (nullable id)objectAtIndexedSubscript:(NSUInteger)index {
    if (![self p_verifyIndex1:index]) return nil;
    return (__bridge id)_array[index];
}

- (void)removeAllObjects {
    _isMutated = 1;
    
    for (NSInteger i = 0; i < _count; i++) {
        CFRelease(_array[i]);
    }
    _count = 0;
}

- (BOOL)isEqual:(id)object {
    return [self isEqualToArray:object];
}

- (BOOL)isEqualToArray:(LILDynamicArray *)otherArray {
    if (self == otherArray) return YES;
    if (![otherArray isKindOfClass:[self class]]) return NO;
    if (self.count != otherArray.count) return NO;
    
    for (NSInteger i = 0; i < self.count; i++) {
        if (![self[i] isEqual:otherArray[i]]) return NO;
    }
    
    return YES;
}

- (NSUInteger)count {
    return (NSInteger)_count < 0 ? 0 : _count;
}

- (BOOL)isEmpty {
    return _count == 0;
}

- (NSArray *)toArray {
    if (self.isEmpty) return nil;
    
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i = 0; i < _count; i++) {
        [array addObject:self[i]];
    }
    
    return [array copy];
}

- (NSString *)description {
    if (self.isEmpty) return @"[]";
    
    NSMutableString *string = [NSMutableString stringWithString:@"[\n"];
    for (int i = 0; i < _count; i++) {
        [string appendFormat:@"\t%@", (__bridge id)_array[i]];
        if (i == _count - 1) {
            [string appendString:@"\n"];
        } else {
            [string appendString:@",\n"];
        }
    }
    [string appendString:@"]"];
    
    return string;
}


#pragma mark - Private
/// 如果索引大于等于0，并且小于数组长度则返回YES，否则返回NO。
- (BOOL)p_verifyIndex1:(const NSUInteger)index {
    if ((NSInteger)index >= 0 && (NSInteger)index < _count) return YES;
    
    NSAssert(NO, @"索引: %ld 不合法，数组长度: %ld", (NSInteger)index, (NSInteger)_count);
    return NO;
}

/// 如果索引大于等于0，并且小于等于数组长度则返回YES，否则返回NO。
- (BOOL)p_verifyIndex2:(const NSUInteger)index {
    if ((NSInteger)index >= 0 && (NSInteger)index <= _count) return YES;
    
    NSAssert(NO, @"索引: %ld 不合法，数组长度: %ld", (NSInteger)index, (NSInteger)_count);
    return NO;
}

/// 对数组进行扩容。
- (BOOL)p_reallocArray {
    void **t_array = realloc(_array, (_size + DEFAULT_COUNT) * sizeof(id));
    if (t_array == NULL) {
        NSAssert(NO, @"数组扩容失败");
        return NO;
    }
    
    _size += DEFAULT_COUNT;
    _array = t_array;
    return YES;
}


#pragma mark - NSCopying
- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    return [self mutableCopy];
}


#pragma mark - NSMutableCopying
- (nonnull id)mutableCopyWithZone:(nullable NSZone *)zone {
    LILDynamicArray *array = [[LILDynamicArray alloc] init];
    
    for (NSInteger index = 0; index < _count; index++) {
        [array addObject:self[index]];
    }
    
    return array;
}


#pragma mark - NSSecureCoding
- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [self init];
    if (!self) return nil;
    
    NSInteger index = 0;
    while (1) {
        NSString *key = [NSString stringWithFormat:@"key%ld", index];
        id object = [coder decodeObjectOfClasses:coder.allowedClasses forKey:key];
        if (!object) break;
        
        [self addObject:object];
        index += 1;
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    for (NSInteger index = 0; index < _count; index++) {
        NSString *key = [NSString stringWithFormat:@"key%ld", index];
        [coder encodeObject:self[index] forKey:key];
    }
}

+ (BOOL)supportsSecureCoding {
    return YES;
}


#pragma mark - NSFastEnumeration
- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(__unsafe_unretained id  _Nullable [])buffer count:(NSUInteger)len {
    if (state->state >= _count) return 0;

    if (state->state == 0) {
        _isMutated = 0;
        state->mutationsPtr = &_isMutated;
    }
    
    state->itemsPtr = buffer;

    unsigned long index = 0;

    while (index < MIN(_count - state->state, len)) {
        buffer[index] = (__bridge id)_array[index + state->state];
        index += 1;
    }

    state->state += index;

    return index;
}

@end
