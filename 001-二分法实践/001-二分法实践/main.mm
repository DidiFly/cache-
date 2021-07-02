//
//  main.m
//  001-二分法实践
//
//  Created by zhou on 2021/7/2.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        auto first = 0;
        auto base = first;
        decltype(first) probe = 0;

        uintptr_t keyValue = 8;
        uint32_t count;
        
        for (count = 8; count != 0; count >>= 1) {
            NSLog(@"前=count:%u---probe:%u",count,probe);
            probe = base + (count >> 1);
            NSLog(@"后=count:%u---probe:%u",count,probe);
            
            if (keyValue == probe) {
                NSLog(@"找到了=keyValue:%lu---probe:%u",keyValue,probe);
                break;
            }
            else{
                NSLog(@"没找到=keyValue:%lu---probe:%u",keyValue,probe);
            }
            
            if (keyValue > probe) {
                base = probe + 1;
                count--;
            }
            
        }
        
    }
    return 0;
}
