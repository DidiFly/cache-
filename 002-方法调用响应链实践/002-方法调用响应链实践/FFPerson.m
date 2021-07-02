//
//  FFPerson.m
//  002-方法调用响应链实践
//
//  Created by zhou on 2021/7/2.
//

#import "FFPerson.h"

@implementation FFPerson

- (void)prettyPerson{
    NSLog(@"%s",__func__);
}

+ (void)gentelPerson{
    NSLog(@"%s",__func__);
}


@end
