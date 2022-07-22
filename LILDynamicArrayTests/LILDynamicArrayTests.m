//
//  DemoTests.m
//  DemoTests
//
//  Created by LL on 2022/7/16.
//

#pragma clang diagnostic ignored "-Wnonnull"

#import <XCTest/XCTest.h>

#import "LILDynamicArray.h"
#import "Person.h"

@interface LILDynamicArrayTests : XCTestCase

@property (nonatomic, strong, nullable) LILDynamicArray *array;


@property (nonatomic, strong, readonly) Person *per1;
@property (nonatomic, strong, readonly) Person *per2;

@end

@implementation LILDynamicArrayTests

@synthesize per1 = _per1;
@synthesize per2 = _per2;

- (void)setUp {
    self.array = [[LILDynamicArray alloc] init];
}

- (void)tearDown {
    self.array = nil;
}


#pragma mark - 公开方法测试区
- (void)testSetObject_atIndexedSubscript {
    XCTAssertNil([self.array setObject:nil atIndexedSubscript:0]);
    XCTAssertTrue(self.array.count == 0);
    
    
    // 测试向数组末尾set元素。
    for (int i = 0; i < 5; i++) {
        id obj = [self.array setObject:@(i) atIndexedSubscript:i];
        XCTAssertNil(obj);
        XCTAssertEqualObjects(self.array[i], @(i));
        XCTAssertTrue(self.array.count == i + 1);
    }
    
    XCTAssertNil([self.array setObject:@"常量字符串" atIndexedSubscript:5]);
    XCTAssertEqualObjects(self.array[5], @"常量字符串");
    XCTAssertTrue(self.array.count == 6);
    
    XCTAssertNil([self.array setObject:[NSString stringWithFormat:@"堆字符串"] atIndexedSubscript:6]);
    XCTAssertEqualObjects(self.array[6], [NSString stringWithFormat:@"堆字符串"]);
    XCTAssertTrue(self.array.count == 7);
    
    XCTAssertNil([self.array setObject:[NSString stringWithFormat:@"123"] atIndexedSubscript:7]);
    XCTAssertEqualObjects(self.array[7], [NSString stringWithFormat:@"123"]);
    XCTAssertTrue(self.array.count == 8);
    
    XCTAssertNil([self.array setObject:self.per1 atIndexedSubscript:8]);
    XCTAssertEqualObjects(self.array[8], self.per1);
    XCTAssertTrue(self.array.count == 9);
    
    XCTAssertNil([self.array setObject:@(YES) atIndexedSubscript:9]);
    XCTAssertEqualObjects(self.array[9], @(YES));
    XCTAssertTrue(self.array.count == 10);
    
    XCTAssertNil([self.array setObject:@(NO) atIndexedSubscript:10]);
    XCTAssertEqualObjects(self.array[10], @(NO));
    XCTAssertTrue(self.array.count == 11);
    
    XCTAssertNil([self.array setObject:@(123) atIndexedSubscript:11]);
    XCTAssertEqualObjects(self.array[11], @(123));
    XCTAssertTrue(self.array.count == 12);
    
    XCTAssertNil([self.array setObject:@(123.456) atIndexedSubscript:12]);
    XCTAssertEqualObjects(self.array[12], @(123.456));
    XCTAssertTrue(self.array.count == 13);
    
    XCTAssertNil([self.array setObject:self.array atIndexedSubscript:13]);
    XCTAssertEqualObjects(self.array[13], self.array);
    XCTAssertTrue(self.array.count == 14);
    
    XCTAssertNil([self.array setObject:self.per2 atIndexedSubscript:14]);
    XCTAssertEqualObjects(self.array[14], self.per2);
    XCTAssertTrue(self.array.count == 15);
    
    NSObject *object = [[NSObject alloc] init];
    XCTAssertNil([self.array setObject:object atIndexedSubscript:15]);
    XCTAssertEqualObjects(self.array[15], object);
    XCTAssertTrue(self.array.count == 16);
    
    XCTAssertNil([self.array setObject:self.per1 atIndexedSubscript:16]);
    XCTAssertEqualObjects(self.array[16], self.per1);
    XCTAssertTrue(self.array.count == 17);
    
    XCTAssertNil([self.array setObject:self.per2 atIndexedSubscript:17]);
    XCTAssertEqualObjects(self.array[17], self.per2);
    XCTAssertTrue(self.array.count == 18);
    
    
    // 测试向数组中间set元素。
    XCTAssertEqualObjects([self.array setObject:@"111" atIndexedSubscript:5], @"常量字符串");
    XCTAssertEqualObjects(self.array[5], @"111");
    
    XCTAssertEqualObjects([self.array setObject:@"222" atIndexedSubscript:8], self.per1);
    XCTAssertEqualObjects(self.array[8], @"222");
    
    XCTAssertEqualObjects([self.array setObject:@"333" atIndexedSubscript:9], @(YES));
    XCTAssertEqualObjects(self.array[9], @"333");
    
    XCTAssertEqualObjects([self.array setObject:@"444" atIndexedSubscript:10], @(NO));
    XCTAssertEqualObjects(self.array[10], @"444");
    
    XCTAssertEqualObjects([self.array setObject:@"555" atIndexedSubscript:11], @(123));
    XCTAssertEqualObjects(self.array[11], @"555");
    
    XCTAssertEqualObjects([self.array setObject:@"666" atIndexedSubscript:12], @(123.456));
    XCTAssertEqualObjects(self.array[12], @"666");
    
    XCTAssertEqualObjects([self.array setObject:@"777" atIndexedSubscript:13], self.array);
    XCTAssertEqualObjects(self.array[13], @"777");
    
    XCTAssertEqualObjects([self.array setObject:@"888" atIndexedSubscript:14], self.per2);
    XCTAssertEqualObjects(self.array[14], @"888");
    
    XCTAssertEqualObjects([self.array setObject:@"999" atIndexedSubscript:15], object);
    XCTAssertEqualObjects(self.array[15], @"999");
    
    XCTAssertTrue(self.array.count == 18);
    
    
    // 测试索引越界
    XCTAssertNil([self.array setObject:@"11" atIndexedSubscript:-1]);
    XCTAssertNil([self.array setObject:@"11" atIndexedSubscript:-10]);
    XCTAssertNil([self.array setObject:@"11" atIndexedSubscript:-999]);
    XCTAssertNil([self.array setObject:@"11" atIndexedSubscript:18]);
    XCTAssertNil([self.array setObject:@"11" atIndexedSubscript:999]);
    XCTAssertNil([self.array setObject:@"11" atIndexedSubscript:NSNotFound]);
}

- (void)testInsertObject_atIndex {
    XCTAssertNil([self.array insertObject:nil atIndex:0]);
    XCTAssertTrue(self.array.count == 0);
    
    
    // 测试向数组末尾insert元素。
    for (int i = 0; i < 5; i++) {
        id obj = [self.array insertObject:@(i) atIndex:i];
        XCTAssertNil(obj);
        XCTAssertEqualObjects(self.array[i], @(i));
        XCTAssertTrue(self.array.count == i + 1);
    }
    
    XCTAssertNil([self.array insertObject:@"常量字符串" atIndex:5]);
    XCTAssertEqualObjects(self.array[5], @"常量字符串");
    XCTAssertTrue(self.array.count == 6);
    
    XCTAssertNil([self.array insertObject:[NSString stringWithFormat:@"堆字符串"] atIndex:6]);
    XCTAssertEqualObjects(self.array[6], [NSString stringWithFormat:@"堆字符串"]);
    XCTAssertTrue(self.array.count == 7);
    
    XCTAssertNil([self.array insertObject:[NSString stringWithFormat:@"123"] atIndex:7]);
    XCTAssertEqualObjects(self.array[7], [NSString stringWithFormat:@"123"]);
    XCTAssertTrue(self.array.count == 8);
    
    XCTAssertNil([self.array insertObject:self.per1 atIndex:8]);
    XCTAssertEqualObjects(self.array[8], self.per1);
    XCTAssertTrue(self.array.count == 9);
    
    XCTAssertNil([self.array insertObject:@(YES) atIndex:9]);
    XCTAssertEqualObjects(self.array[9], @(YES));
    XCTAssertTrue(self.array.count == 10);
    
    XCTAssertNil([self.array insertObject:@(NO) atIndex:10]);
    XCTAssertEqualObjects(self.array[10], @(NO));
    XCTAssertTrue(self.array.count == 11);
    
    XCTAssertNil([self.array insertObject:@(123) atIndex:11]);
    XCTAssertEqualObjects(self.array[11], @(123));
    XCTAssertTrue(self.array.count == 12);
    
    XCTAssertNil([self.array insertObject:@(123.456) atIndex:12]);
    XCTAssertEqualObjects(self.array[12], @(123.456));
    XCTAssertTrue(self.array.count == 13);
    
    XCTAssertNil([self.array insertObject:self.array atIndex:13]);
    XCTAssertEqualObjects(self.array[13], self.array);
    XCTAssertTrue(self.array.count == 14);
    
    XCTAssertNil([self.array insertObject:self.per2 atIndex:14]);
    XCTAssertEqualObjects(self.array[14], self.per2);
    XCTAssertTrue(self.array.count == 15);
    
    NSObject *object = [[NSObject alloc] init];
    XCTAssertNil([self.array insertObject:object atIndex:15]);
    XCTAssertEqualObjects(self.array[15], object);
    XCTAssertTrue(self.array.count == 16);
    
    XCTAssertNil([self.array insertObject:self.per1 atIndex:16]);
    XCTAssertEqualObjects(self.array[16], self.per1);
    XCTAssertTrue(self.array.count == 17);
    
    XCTAssertNil([self.array insertObject:self.per2 atIndex:17]);
    XCTAssertEqualObjects(self.array[17], self.per2);
    XCTAssertTrue(self.array.count == 18);
    
    
    // 测试向数组中间insert元素。
    XCTAssertEqualObjects([self.array insertObject:@"111" atIndex:5], @"常量字符串");
    
    XCTAssertTrue(self.array.count == 19);
    
    XCTAssertEqualObjects(self.array[0], @(0));
    XCTAssertEqualObjects(self.array[1], @(1));
    XCTAssertEqualObjects(self.array[2], @(2));
    XCTAssertEqualObjects(self.array[3], @(3));
    XCTAssertEqualObjects(self.array[4], @(4));
    XCTAssertEqualObjects(self.array[5], @"111");
    XCTAssertEqualObjects(self.array[6], @"常量字符串");
    XCTAssertEqualObjects(self.array[7], [NSString stringWithFormat:@"堆字符串"]);
    XCTAssertEqualObjects(self.array[8], [NSString stringWithFormat:@"123"]);
    XCTAssertEqualObjects(self.array[9], self.per1);
    XCTAssertEqualObjects(self.array[10], @(YES));
    XCTAssertEqualObjects(self.array[11], @(NO));
    XCTAssertEqualObjects(self.array[12], @(123));
    XCTAssertEqualObjects(self.array[13], @(123.456));
    XCTAssertEqualObjects(self.array[14], self.array);
    XCTAssertEqualObjects(self.array[15], self.per2);
    XCTAssertEqualObjects(self.array[16], object);
    XCTAssertEqualObjects(self.array[17], self.per1);
    XCTAssertEqualObjects(self.array[18], self.per2);
    
    
    // 测试索引越界。
    XCTAssertNil([self.array insertObject:@"11" atIndex:-1]);
    XCTAssertNil([self.array insertObject:@"11" atIndex:-10]);
    XCTAssertNil([self.array insertObject:@"11" atIndex:-999]);
    XCTAssertNil([self.array insertObject:@"11" atIndex:19]);
    XCTAssertNil([self.array insertObject:@"11" atIndex:999]);
    XCTAssertNil([self.array insertObject:@"11" atIndex:NSNotFound]);
}

- (void)testAddObject {
    self.array = [[LILDynamicArray alloc] initWithCapacity:32];
    
    [self.array addObject:nil];
    XCTAssertTrue(self.array.count == 0);
    
    for (int i = 0; i < 32; i++) {
        NSString *obj = [NSString stringWithFormat:@"key: %d", i];
        [self.array addObject:[NSString stringWithFormat:@"key: %d", i]];
        XCTAssertEqualObjects(self.array[i], obj);
        XCTAssertTrue(self.array.count == i + 1);
    }
    
    XCTAssertTrue(self.array.count == 32);
}

- (void)testContainsObject {
    [self p_autoFillObjectsForArray:self.array];
    
    XCTAssertTrue([self.array containsObject:@"常量字符串"]);
    XCTAssertTrue([self.array containsObject:[NSString stringWithFormat:@"堆字符串"]]);
    XCTAssertTrue([self.array containsObject:[NSString stringWithFormat:@"123"]]);
    XCTAssertTrue([self.array containsObject:self.per1]);
    XCTAssertTrue([self.array containsObject:@(YES)]);
    XCTAssertTrue([self.array containsObject:@(NO)]);
    XCTAssertTrue([self.array containsObject:@(123)]);
    XCTAssertTrue([self.array containsObject:@(123.456)]);
    XCTAssertTrue([self.array containsObject:[NSNull null]]);
    
    Person *t_per = [[Person alloc] init];
    t_per.name = @"per1";
    XCTAssertTrue([self.array containsObject:t_per]);
    
    XCTAssertFalse([self.array containsObject:nil]);
    XCTAssertFalse([self.array containsObject:@"NULL"]);
}

- (void)testIndexOfObject {
    [self p_autoFillObjectsForArray:self.array];
    
    NSObject *object = [[NSObject alloc] init];
    [self.array addObject:object];
    
    
    XCTAssertTrue([self.array indexOfObject:@"常量字符串"] == 0);
    XCTAssertTrue([self.array indexOfObject:[NSString stringWithFormat:@"堆字符串"]] == 1);
    XCTAssertTrue([self.array indexOfObject:[NSString stringWithFormat:@"123"]] == 2);
    XCTAssertTrue([self.array indexOfObject:self.per1] == 3);
    
    Person *t_per = [[Person alloc] init];
    t_per.name = @"per1";
    XCTAssertTrue([self.array indexOfObject:t_per] == 3);
    
    XCTAssertTrue([self.array indexOfObject:@(YES)] == 4);
    XCTAssertTrue([self.array indexOfObject:@(NO)] == 5);
    XCTAssertTrue([self.array indexOfObject:@(123)] == 6);
    XCTAssertTrue([self.array indexOfObject:@(123.456)] == 7);
    XCTAssertTrue([self.array indexOfObject:[NSNull null]] == 8);
    XCTAssertTrue([self.array indexOfObject:object] == 9);
    XCTAssertTrue([self.array indexOfObject:nil] == NSNotFound);
    XCTAssertTrue([self.array indexOfObject:@"NULL"] == NSNotFound);
}

- (void)testRemoveObjectAtIndex {
    [self p_autoFillObjectsForArray:self.array];
    
    NSObject *object = [[NSObject alloc] init];
    [self.array addObject:object];
    
    
    XCTAssertEqualObjects([self.array removeObjectAtIndex:3], self.per1);
    
    XCTAssertTrue(self.array.count == 9);
    
    XCTAssertEqualObjects(self.array[0], @"常量字符串");
    XCTAssertEqualObjects(self.array[1], [NSString stringWithFormat:@"堆字符串"]);
    XCTAssertEqualObjects(self.array[2], [NSString stringWithFormat:@"123"]);
    XCTAssertEqualObjects(self.array[3], @(YES));
    XCTAssertEqualObjects(self.array[4], @(NO));
    XCTAssertEqualObjects(self.array[5], @(123));
    XCTAssertEqualObjects(self.array[6], @(123.456));
    XCTAssertEqualObjects(self.array[7], [NSNull null]);
    XCTAssertEqualObjects(self.array[8], object);
    
    
    // 测试索引越界。
    XCTAssertNil([self.array removeObjectAtIndex:-1]);
    XCTAssertNil([self.array removeObjectAtIndex:-10]);
    XCTAssertNil([self.array removeObjectAtIndex:-999]);
    XCTAssertNil([self.array removeObjectAtIndex:9]);
    XCTAssertNil([self.array removeObjectAtIndex:999]);
    XCTAssertNil([self.array removeObjectAtIndex:NSNotFound]);
}

- (void)testObjectAtIndexedSubscript {
    [self p_autoFillObjectsForArray:self.array];
    
    NSObject *object = [[NSObject alloc] init];
    [self.array addObject:object];
    
    XCTAssertEqualObjects([self.array objectAtIndexedSubscript:0], @"常量字符串");
    XCTAssertEqualObjects([self.array objectAtIndexedSubscript:1], [NSString stringWithFormat:@"堆字符串"]);
    XCTAssertEqualObjects([self.array objectAtIndexedSubscript:2], [NSString stringWithFormat:@"123"]);
    XCTAssertEqualObjects([self.array objectAtIndexedSubscript:3], self.per1);
    XCTAssertEqualObjects([self.array objectAtIndexedSubscript:4], @(YES));
    XCTAssertEqualObjects(self.array[5], @(NO));
    XCTAssertEqualObjects(self.array[6], @(123));
    XCTAssertEqualObjects(self.array[7], @(123.456));
    XCTAssertEqualObjects(self.array[8], [NSNull null]);
    XCTAssertEqualObjects(self.array[9], object);
    
    XCTAssertNil([self.array objectAtIndexedSubscript:-1]);
    XCTAssertNil([self.array objectAtIndexedSubscript:-999]);
    XCTAssertNil(self.array[10]);
    XCTAssertNil(self.array[999]);
    XCTAssertNil(self.array[NSNotFound]);
}

- (void)testRemoveAllObjects {
    [self p_autoFillObjectsForArray:self.array];
    
    XCTAssertTrue(self.array.count == 9);
    
    [self.array removeAllObjects];
    
    XCTAssertTrue(self.array.count == 0);
}

- (void)testIsEqualToArray {
    LILDynamicArray *array = [[LILDynamicArray alloc] init];
    
    XCTAssertTrue([self.array isEqualToArray:array]);
    
    [self p_autoFillObjectsForArray:self.array];
    
    NSObject *object = [[NSObject alloc] init];
    [self.array addObject:object];
    
    XCTAssertFalse([self.array isEqualToArray:array]);
    
    [self p_autoFillObjectsForArray:array];
    [array addObject:object];
    
    XCTAssertTrue([self.array isEqualToArray:array]);
    
    [array setObject:@"不相同的字符串" atIndexedSubscript:2];
    XCTAssertFalse([self.array isEqualToArray:array]);
    
    [array removeObjectAtIndex:0];
    XCTAssertFalse([self.array isEqualToArray:array]);
    
    XCTAssertTrue([self.array isEqualToArray:self.array]);
    XCTAssertTrue([array isEqualToArray:array]);
    
    XCTAssertFalse([self.array isEqualToArray:(LILDynamicArray *)[NSObject new]]);
    XCTAssertFalse([self.array isEqualToArray:(LILDynamicArray *)[Person new]]);
    XCTAssertFalse([self.array isEqualToArray:nil]);
}


#pragma mark - 属性测试区
- (void)testIsEmptyProperty {
    XCTAssertTrue(self.array.isEmpty);
    
    [self p_autoFillObjectsForArray:self.array];
    
    NSObject *object = [[NSObject alloc] init];
    [self.array addObject:object];
    
    XCTAssertFalse(self.array.isEmpty);
    
    NSInteger count = self.array.count;
    for (NSInteger i = 0; i < count; i++) {
        [self.array removeObjectAtIndex:0];
        if (i == count - 1) {
            XCTAssertTrue(self.array.isEmpty);
        } else {
            XCTAssertFalse(self.array.isEmpty);
        }
    }
}

- (void)testToArray {
    XCTAssertNil(self.array.toArray);
    
    [self p_autoFillObjectsForArray:self.array];
    
    NSObject *object = [[NSObject alloc] init];
    [self.array addObject:object];
    
    NSArray *array = self.array.toArray;
    
    XCTAssertTrue(array.count == self.array.count);
    
    for (NSInteger i = 0; i < array.count; i++) {
        XCTAssertEqualObjects(array[i], self.array[i]);
    }
}


#pragma mark - 协议测试区
- (void)testNSCopying {
    LILDynamicArray *array = [self.array copy];
    
    XCTAssertEqualObjects(self.array, array);
    
    [self p_autoFillObjectsForArray:self.array];
    
    array = [self.array copy];
    
    XCTAssertEqualObjects(self.array, array);
    
    array = [self.array mutableCopy];
    
    XCTAssertEqualObjects(self.array, array);
}

- (void)testDescription {
    NSString *description = [NSString stringWithFormat:@"%@", self.array];
    XCTAssertEqualObjects(description, @"[]");
    
    [self.array addObject:@"123"];
    [self.array addObject:@"456"];
    [self.array addObject:@"789"];
    
    description = [NSString stringWithFormat:@"%@", self.array];
    
    NSString *expectString = [NSString stringWithFormat:@"[\n\t%@,\n\t%@,\n\t%@\n]", @"123", @"456", @"789"];
    XCTAssertEqualObjects(description, expectString);
}

- (void)testNSSecureCoding {
    [self p_autoFillObjectsForArray:self.array];
    
    NSError *error1 = nil;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.array requiringSecureCoding:YES error:&error1];
    
    XCTAssertNil(error1);
    
    NSError *error2 = nil;
    LILDynamicArray *array = [NSKeyedUnarchiver unarchivedObjectOfClasses:[NSSet setWithObjects:LILDynamicArray.class, NSNull.class, Person.class, nil] fromData:data error:&error2];
    
    XCTAssertNil(error2);
    XCTAssertEqualObjects(array, self.array);
}

- (void)testNSFastEnumeration {
    [self p_autoFillObjectsForArray:self.array];
    
    NSInteger index = 0;
    for (id obj in self.array) {
        XCTAssertEqualObjects(obj, self.array[index]);
        index += 1;
    }
}


#pragma mark - Private
- (void)p_autoFillObjectsForArray:(LILDynamicArray  * _Nonnull)array {
    [array addObject:@"常量字符串"];
    [array addObject:[NSString stringWithFormat:@"堆字符串"]];
    [array addObject:[NSString stringWithFormat:@"123"]];
    [array addObject:self.per1];
    [array addObject:@(YES)];
    [array addObject:@(NO)];
    [array addObject:@(123)];
    [array addObject:@(123.456)];
    [array addObject:[NSNull null]];
}



#pragma mark - Getter
- (Person *)per1 {
    if (!_per1) {
        _per1 = [[Person alloc] init];
        _per1.name = @"per1";
    }
    return _per1;
}

- (Person *)per2 {
    if (!_per2) {
        _per2 = [[Person alloc] init];
        _per2.name = @"per2";
    }
    return _per2;
}

@end
