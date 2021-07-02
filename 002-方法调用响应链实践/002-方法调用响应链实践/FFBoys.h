//
//  FFBoys.h
//  002-方法调用响应链实践
//
//  Created by zhou on 2021/7/2.
//

#import "FFPerson.h"

NS_ASSUME_NONNULL_BEGIN

@interface FFBoys : FFPerson

//字节的方法，声明+实现
- (void)prettyBoy;

+ (void)gentelBoy;

//父类的方法，只声明，未实现
- (void)prettyPerson;

+ (void)gentelPerson;

//NSObject分类的方法，只声明，为实现
- (void)prettyGirls;

+ (void)gentelGirls;

@end

NS_ASSUME_NONNULL_END
