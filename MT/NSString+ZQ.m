//
//  NSString+ZQ.m
//  MT
//
//  Created by zzqiltw on 15-3-26.
//  Copyright (c) 2015年 zzqiltw. All rights reserved.
//

#import "NSString+ZQ.h"

@implementation NSString (ZQ)
+ (NSString *)replaceUnicode:(NSString *)unicodeStr {
    
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    NSString *tempStr3 = [[@"\""stringByAppendingString:tempStr2]stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                          mutabilityOption:NSPropertyListImmutable
                                                                    format:NULL
                                                          errorDescription:NULL];
    
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
}
@end
