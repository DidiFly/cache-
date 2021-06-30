//
//  main.m
//  002-cache真机源码还原
//
//  Created by zhou on 2021/6/30.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <objc/message.h>
#import "FFPerson.h"

typedef uint32_t mask_t;  // x86_64 & arm64 asm are less efficient

//preopt_cache_entry_t源码模仿
struct ff_preopt_cache_entry_t {
    uint32_t sel_offs;
    uint32_t imp_offs;
};

//preopt_cache_t源码模仿
struct ff_preopt_cache_t {
    int32_t  fallback_class_offset;
    union {
        struct {
            uint16_t shift       :  5;
            uint16_t mask        : 11;
        };
        uint16_t hash_params;
    };
    uint16_t occupied    : 14;
    uint16_t has_inlines :  1;
    uint16_t bit_one     :  1;
    struct ff_preopt_cache_entry_t entries;
    
    inline int capacity() const {
        return mask + 1;
    }
};

//bucket_t源码模仿
struct ff_bucket_t {
    IMP _imp;
    SEL _sel;
};

//cache_t源码模仿
struct ff_cache_t {
    uintptr_t _bucketsAndMaybeMask; // 8
    struct ff_preopt_cache_t _originalPreoptCache; // 8

    // _bucketsAndMaybeMask is a buckets_t pointer in the low 48 bits
    // _maybeMask is unused, the mask is stored in the top 16 bits.

    // How much the mask is shifted by.
    static constexpr uintptr_t maskShift = 48;

    // Additional bits after the mask which must be zero. msgSend
    // takes advantage of these additional bits to construct the value
    // `mask << 4` from `_maskAndBuckets` in a single instruction.
    static constexpr uintptr_t maskZeroBits = 4;

    // The largest mask value we can store.
    static constexpr uintptr_t maxMask = ((uintptr_t)1 << (64 - maskShift)) - 1;
    
    // The mask applied to `_maskAndBuckets` to retrieve the buckets pointer.
    static constexpr uintptr_t bucketsMask = ((uintptr_t)1 << (maskShift - maskZeroBits)) - 1;
    
    static constexpr uintptr_t preoptBucketsMarker = 1ul;

    // 63..60: hash_mask_shift
    // 59..55: hash_shift
    // 54.. 1: buckets ptr + auth
    //      0: always 1
    static constexpr uintptr_t preoptBucketsMask = 0x007ffffffffffffe;
    
    ff_bucket_t *buckets() {
        return (ff_bucket_t *)(_bucketsAndMaybeMask & bucketsMask);
    }
    
    uint32_t mask() const {
        return _bucketsAndMaybeMask >> maskShift;
    }
    
};

//class_data_bits_t源码模仿
struct ff_class_data_bits_t {
    uintptr_t objc_class;
};

//类源码模仿
struct ff_objc_class {
    Class isa;
    Class superclass;
    struct ff_cache_t cache;
    struct ff_class_data_bits_t bits;
};


void test(Class cls) {
    
    //将person的类型转换成自定义的源码ff_objc_class类型，方便后续操作
    struct ff_objc_class *pClass = (__bridge struct ff_objc_class *)(cls);
    
    struct ff_cache_t cache = pClass->cache;
    struct ff_bucket_t * buckets = cache.buckets();
    struct ff_preopt_cache_t origin = cache._originalPreoptCache;
    uintptr_t _bucketsAndMaybeMask = cache._bucketsAndMaybeMask;
    uintptr_t mask = cache.mask();
    
    
    
    NSLog(@"class: %p", pClass);
    NSLog(@"_bucketsAndMaybeMask: 0x%lx, mask: %lu", _bucketsAndMaybeMask, mask);
    
    //打印当前有多少个方法缓存与最大缓存数量
    NSLog(@"%u-%u",origin.occupied,origin.capacity());
    
    //打印buckets
    for (int i = 0; i < mask + 1; i++ ) {
        SEL sel = buckets[i]._sel;
        IMP imp = buckets[i]._imp;
        NSLog(@"%@-%p",NSStringFromSelector(sel),imp);
    }
}

int main(int argc, char * argv[]) {

    @autoreleasepool {
        
        //给person分配内存
        FFPerson *person = [FFPerson alloc];
        //调用方法
        [person likeGirls];
        test(person.class);
        [person likeFoods];
        test(person.class);
        [person likeflower];
        test(person.class);
        [person likeStudy];
        test(person.class);
        [person enjoyLift];
        test(person.class);
        [person lnspireCreativity];
        test(person.class);
        
//        [person likeGirls1];
//        test(person.class);
//        [person likeFoods1];
//        test(person.class);
//        [person likeflower1];
//        test(person.class);
//        [person likeStudy1];
//        test(person.class);
//        [person enjoyLift1];
//        test(person.class);
//        [person lnspireCreativity1];
//        
//        [person likeGirls2];
//        test(person.class);
//        [person likeFoods2];
//        test(person.class);
//        [person likeflower2];
//        test(person.class);
//        [person likeStudy2];
//        test(person.class);
//        [person enjoyLift2];
//        test(person.class);
//        [person lnspireCreativity2];
//        test(person.class);


    }
    return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
}
