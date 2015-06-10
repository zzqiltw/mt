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



- (int)ldCalcPathOfTwoSentences:(NSArray *)s1 second:(NSArray *)s2 result1:(NSMutableArray *)r1 result2:(NSMutableArray *)r2
{

    NSInteger len1 = s1.count;
    NSInteger len2 = s2.count;
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
            min_dist = ((ZQArrayData *)array[i - 1][j - 1]).dist + ([[(NSString *)s1[i-1] lowercaseString] isEqualToString:[(NSString *)s2[j - 1] lowercaseString]] ? 0 : 1);
            if (min_dist < ((ZQArrayData *)array[i][j]).dist) {
                array[i][j] = [ZQArrayData arrayDataWithDist:min_dist pre_x:i-1 pre_y:j-1];
            }
        }
    }
    [self storeResult:array index_x:len1 index_y:len2 r1:r1 r2:r2 s1:s1 s2:s2];
    min_dist = ((ZQArrayData *)array[len1][len2]).dist;
    return min_dist;
}

- (void)storeResult:(NSMutableArray *)array index_x:(NSInteger)index_x index_y:(NSInteger)index_y r1:(NSMutableArray *)r1 r2:(NSMutableArray *)r2 s1:(NSArray *)s1 s2:(NSArray *)s2
{
    if (index_x == 0 && index_y == 0) {
        return;
    }
    
    if ((((ZQArrayData *)array[index_x][index_y]).pre_x < index_x) && (((ZQArrayData *)array[index_x][index_y]).pre_y < index_y)) {
        [self storeResult:array index_x:index_x - 1 index_y:index_y - 1 r1:r1 r2:r2 s1:s1 s2:s2];
        [r1 addObject:s1[index_x - 1]];
        [r2 addObject:s2[index_y - 1]];
    } else if (((ZQArrayData *)array[index_x][index_y]).pre_x < index_x) {
        [self storeResult:array index_x:index_x - 1 index_y:index_y r1:r1 r2:r2 s1:s1 s2:s2];
        [r1 addObject:s1[index_x - 1]];
        [r2 addObject:@"_"];
    } else {
        [self storeResult:array index_x:index_x index_y:index_y - 1 r1:r1 r2:r2 s1:s1 s2:s2];
        [r1 addObject:@"_"];
        [r2 addObject:s2[index_y - 1]];
    }
}

- (NSString *)combineOfFourSentences:(NSArray *)sl1 second:(NSArray *)sl2 third:(NSArray *)sl3 four:(NSArray *)sl4 type:(TranslateType)type
{
    NSArray *r12 = [self combineOfTwoSentences:sl1 second:sl2];
    NSArray *r123 = [self combineOfTwoSentences:r12 second:sl3];
    NSArray *final = [self combineOfTwoSentences:r123 second:sl4];
    
//    NSArray *final = [self combineOfTwoSentences:sl1 second:sl2];
    
    NSMutableString *result = [NSMutableString string];
    for (NSString *subString in final) {
        [result appendString:subString];
        if (type == TranslateTypeCn2En) {
            [result appendString:@" "];
        }
    }
    return [result copy];
}

- (NSArray *)combineOfTwoSentences:(NSArray *)sl1 second:(NSArray *)sl2
{
    NSMutableArray *r1 = [NSMutableArray array];
    NSMutableArray *r2 = [NSMutableArray array];
    [self ldCalcPathOfTwoSentences:sl1 second:sl2 result1:r1 result2:r2];
    for (NSInteger i = r1.count - 1; i >= 0; --i) {
        if ([r1[i] isEqualToString:@"_"]) {
            [r1 removeObjectAtIndex:i];
        } else {
            break;
        }
    }
    [r1 enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isEqualToString:@"_"]) {
            NSString *replace = r2[idx];
            [r1 replaceObjectAtIndex:idx withObject:replace];
        }
    }];
    return r1;
}

@end
