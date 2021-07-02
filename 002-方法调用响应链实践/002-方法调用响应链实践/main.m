//
//  main.m
//  002-方法调用响应链实践
//
//  Created by zhou on 2021/7/2.
//

#import <Foundation/Foundation.h>
#import "FFBoys.h"

//继承链： FFBoys -> FFPerson -> NSObject

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        FFBoys *boys = [FFBoys alloc];
        
        //FFBoys实例对象调用自己的实例方法
        [boys prettyBoy];
        
        //FFBoys类调用自己的类方法
        [FFBoys gentelBoy];
        
        //FFBoys的实例对象通过perform方式调用自己的类方法
//        [boys performSelector:@selector(gentelBoy)];
        
        //FFBoys的类对象通过perform方式调用自己的实例方法
//        [FFBoys performSelector:@selector(prettyBoy)];
        
        //FFBoys实例对象调用父类的实例方法
        [boys prettyPerson];
        
        //FFBoys类对象调用父类的类方法
        [FFBoys gentelPerson];
        
        //FFBoys的实例对象调用通过perform方式嗲用父类的类方法
//        [boys performSelector:@selector(gentelPerson)];
        
        //FFBoys的类对象通过perform方式调用父类的实例方法
//        [FFBoys performSelector:@selector(prettyPerson)];
        
        //FFBoys实例对象调用NSObject分类的实例方法
        [boys prettyGirls];
        
        //FFBoys类对象调用NSobject分类的类方法
        [FFBoys gentelGirls];
        
        //FFBoy的实例对象通过perform方式调用NSObject分类的类方法
        [boys performSelector:@selector(gentelGirls)];
        
        //FFBoy的类对象通过perform方式调用NSObject分类的实例方法
        [FFBoys performSelector:@selector(prettyGirls)];
    }
    return 0;
}
