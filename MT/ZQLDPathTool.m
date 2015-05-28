//
//  ZQLDPathTool.m
//  MT
//
//  Created by zzqiltw on 15/5/28.
//  Copyright (c) 2015年 zzqiltw. All rights reserved.
//

#import "ZQLDPathTool.h"

@interface ZQArrayData : NSObject
@property (nonatomic, assign) int dist;
@property (nonatomic, assign) int pre_x;
@property (nonatomic, assign) int pre_y;
@end
@implementation ZQArrayData
+ (instancetype)arrayDataWithDist:(int)dist pre_x:(int)pre_x pre_y:(int)pre_y
{
    ZQArrayData *arrayData = [[self alloc] init];
    arrayData.dist = dist;
    arrayData.pre_x = pre_x;
    arrayData.pre_y = pre_y;
    return arrayData;
}
@end

//typedef struct ArrayData {
//    int dist;
//    int pre_x;
//    int pre_y;
//}ArrayData;

@implementation ZQLDPathTool
SingletonM(LDPathTool)

- (int)ldCalcPath {
    self.r1 = [[NSMutableArray alloc] init];
    self.r2 = [[NSMutableArray alloc] init];

    int len1 = self.s1.count;
    int len2 = self.s2.count;
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i <= len1; ++i) {
        NSMutableArray *subArray = [NSMutableArray array];
        for (int j = 0; j <= len2; ++j) {
            ZQArrayData *data = [[ZQArrayData alloc] init];
            [subArray addObject:data];
        }
        [array addObject:subArray];
    }

    for (int i = 0; i <= len1; i++) {
        array[i][0] = [ZQArrayData arrayDataWithDist:i pre_x:i-1 pre_y:0];
    }
    for (int j = 0; j <= len2; j++) {
        array[0][j] = [ZQArrayData arrayDataWithDist:j pre_x:0 pre_y:j-1];
    }
    
    int min_dist;
    for (int i = 1; i <= len1; i++) {
        for (int j = 1; j <= len2; j++) {
            if (((ZQArrayData *)array[i -1][j]).dist < ((ZQArrayData *)array[i][j - 1]).dist) {
                array[i][j] = [ZQArrayData arrayDataWithDist:((ZQArrayData *)array[i-1][j]).dist + 1 pre_x:i-1 pre_y:j];
            } else {
                array[i][j] = [ZQArrayData arrayDataWithDist:((ZQArrayData *)array[i][j-1]).dist + 1 pre_x:i pre_y:j-1];
            }
            min_dist = ((ZQArrayData *)array[i - 1][j - 1]).dist + ([[(NSString *)self.s1[i-1] lowercaseString] isEqualToString:[(NSString *)self.s2[j - 1] lowercaseString]] ? 0 : 1);
            if (min_dist < ((ZQArrayData *)array[i][j]).dist) {
                array[i][j] = [ZQArrayData arrayDataWithDist:min_dist pre_x:i-1 pre_y:j-1];
            }
        }
    }
    [self storeResult:array index_x:len1 index_y:len2];
    min_dist = ((ZQArrayData *)array[len1][len2]).dist;
    NSLog(@"r1=%@, r2 = %@", self.r1, self.r2);
    return min_dist;
}

- (void)storeResult:(NSMutableArray *)array index_x:(int)index_x index_y:(int)index_y
{
    if (index_x == 0 && index_y == 0) {
        return;
    }
    
    if ((((ZQArrayData *)array[index_x][index_y]).pre_x < index_x) && (((ZQArrayData *)array[index_x][index_y]).pre_y < index_y)) {
        [self storeResult:array index_x:index_x - 1 index_y:index_y - 1];
        [self.r1 addObject:self.s1[index_x - 1]];
        [self.r2 addObject:self.s2[index_y - 1]];
    } else if (((ZQArrayData *)array[index_x][index_y]).pre_x < index_x) {
        [self storeResult:array index_x:index_x - 1 index_y:index_y];
        [self.r1 addObject:self.s1[index_x - 1]];
        [self.r2 addObject:@"_"];
    } else {
        [self storeResult:array index_x:index_x index_y:index_y - 1];
        [self.r1 addObject:@"_"];
        [self.r2 addObject:self.s2[index_y - 1]];
    }
}


@end
