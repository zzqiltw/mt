//
//  ZQRecordTool.h
//  MT
//
//  Created by zzqiltw on 15/5/30.
//  Copyright (c) 2015年 zzqiltw. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface ZQRecordTool : NSObject
+ (instancetype)sharedRecordTool;
- (void)startRecord;
- (void)stopRecording;
- (NSString *)getRecordData;
@end
