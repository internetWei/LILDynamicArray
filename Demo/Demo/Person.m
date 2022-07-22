//
//  Person.m
//  Demo
//
//  Created by LL on 2022/7/16.
//

#import "Person.h"

@implementation Person

- (void)dealloc {
    NSLog(@"%s---%@", __func__, self.name);
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, name: %@>", NSStringFromClass([self class]), self, self.name];
}

- (NSUInteger)hash {
    return self.name.hash;
}

- (BOOL)isEqual:(id)object {
    if (self == object) return YES;
    if (![object isKindOfClass:self.class]) return NO;
    
    return self.hash == [object hash];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super init]) {
        self.name = [coder decodeObjectOfClass:NSString.class forKey:@"name"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.name forKey:@"name"];
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

@end
