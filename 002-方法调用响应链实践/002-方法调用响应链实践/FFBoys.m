//
//  FFBoys.m
//  002-方法调用响应链实践
//
//  Created by zhou on 2021/7/2.
//

#import "FFBoys.h"

@implementation FFBoys

- (void)prettyBoy{
    NSLog(@"%s",__func__);
}

+ (void)gentelBoy{
    NSLog(@"%s",__func__);
}
@end
