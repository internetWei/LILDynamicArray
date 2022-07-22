//
//  Person.h
//  Demo
//
//  Created by LL on 2022/7/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject<NSSecureCoding>

@property (nonatomic, copy) NSString *name;

@end

NS_ASSUME_NONNULL_END
