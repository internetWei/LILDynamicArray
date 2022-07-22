//
//  DynamicArray.h
//  DynamicArray
//
//  Created by LL on 2022/7/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LILDynamicArray<__covariant ObjectType> : NSObject<NSCopying, NSMutableCopying, NSSecureCoding, NSFastEnumeration>

/// 返回数组中的元素数量。
@property (readonly) NSUInteger count;

/// 如果数组中的元素数量为0返回YES，否则返回NO。
@property (readonly) BOOL isEmpty;

/// 返回一个 NSArray 对象，其中包含所有元素。
/// @discussion 注意这不会从当前数组移除这些对象。
/// @return 如果当前数组为空则返回nil。
@property (nullable, readonly) NSArray *toArray;



/// 如果给定对象存在于数组中返回YES，否则返回NO。
/// @param anObject 需要检查的对象。
/// @discussion 通过 `isEqual` 实例方法判断。
- (BOOL)containsObject:(const ObjectType)anObject;

/// 在数组末尾添加一个新元素。
- (void)addObject:(const ObjectType)anObject;

/// 用新对象替换索引处的对象，如果索引位于数组末尾，可能会添加该对象。
/// @return 如果替换成功则返回之前的对象，如果替换失败或添加成功则返回nil。
- (nullable ObjectType)setObject:(const ObjectType)anObject atIndexedSubscript:(NSUInteger)index;

/// 将指定对象插入到给定索引处，后面的元素全部往后挪动一位。
/// @return 如果插入成功则返回之前的旧对象，如果插入失败或插入在最后一位则返回nil。
- (nullable ObjectType)insertObject:(const ObjectType)anObject atIndex:(NSUInteger)index;

/// 移除给定索引处的对象。
/// @discussion 当前元素移除之后，后面的元素全部往前挪一位。
/// @return 如果移除成功则返回被移除的对象，否则返回nil。
- (nullable ObjectType)removeObjectAtIndex:(NSUInteger)index;

/// 返回给定对象的最低索引。
/// @discussion 如果数组不存在该元素则返回`NSNotFound`。
- (NSUInteger)indexOfObject:(const ObjectType)anObject;

/// 返回指定索引处的对象，如果索引越界则返回nil。
- (nullable ObjectType)objectAtIndexedSubscript:(NSUInteger)index;

/// 清空数组中的所有元素。
- (void)removeAllObjects;

/// 将接收数组与另一个数组进行比较。
/// @discussion 如果两个数组都包含相同数量的对象并且每个数组中给定索引处的对象都满足 isEqua: 测试，则它们具有相同的内容。
/// @return 如果 otherArray 的内容等于接收数组的内容，则返回YES，否则返回NO。
- (BOOL)isEqualToArray:(LILDynamicArray<ObjectType> *)otherArray;

- (instancetype)initWithCapacity:(NSUInteger)numItems NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
