//
//  main.m
//  001-caceh源码还原调试
//
//  Created by zhou on 2021/6/24.
//

#import <Foundation/Foundation.h>
#import "FFPerson.h"

typedef uint32_t mask_t;  // x86_64 & arm64 asm are less efficient with 16-bits

//bucketsMask：掩码，用来通过_bucketsAndMaybeMask解析初buckets
static uintptr_t bucketsMask = ~0ul;

//bucket_t源码模仿
struct ff_bucket_t {
    SEL _sel;
    IMP _imp;
};

//class_data_bits_t源码模仿
struct ff_class_data_bits_t {
    uintptr_t bits;
};
//cache_t源码模仿
struct ff_cache_t {
    uintptr_t _bucketsAndMaybeMask; // 8
    mask_t    _maybeMask; // 4
    uint16_t                   _flags;  // 2
    uint16_t                   _occupied; // 2
};

//类源码模仿
struct ff_objc_class {
    Class isa;
    Class superclass;
    struct ff_cache_t cache;             // formerly cache pointer and vtable
    struct ff_class_data_bits_t bits;    // class_rw_t * plus custom rr/alloc flags
};


int main(int argc, const char * argv[]) {
    @autoreleasepool {
       
        //给person分配内存
        FFPerson *person = [FFPerson alloc];
        //调用方法
        [person likeGirls];
        [person likeFoods];
        [person likeflower];
        [person likeStudy];
        [person enjoyLift];
        [person lnspireCreativity];
        
        //将person的类型转换成自定义的源码ff_objc_class类型，方便后续操作
        struct ff_objc_class *pClass = (__bridge struct ff_objc_class *)(person.class);
        
        //打印当前有多少个方法缓存与最大缓存数量
        NSLog(@"%u-%u",pClass->cache._occupied,pClass->cache._maybeMask);
        
        //通过_bucketsAndMaybeMask解析初buckets
        struct ff_bucket_t *bucketptr = pClass->cache._bucketsAndMaybeMask & bucketsMask;
        
        //循环遍历打印缓存的sel与imp
        for (int i = 0; i<pClass->cache._maybeMask ; i++) {
            struct ff_bucket_t b = *(bucketptr + i);
            NSLog(@"%@-%p",NSStringFromSelector(b._sel),b._imp);
        }
    }
    return 0;
}
