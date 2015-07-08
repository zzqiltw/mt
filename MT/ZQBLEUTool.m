//
//  ZQBLEUTool.m
//  BLEUTest
//
//  Created by zzqiltw on 15/5/12.
//  Copyright (c) 2015年 zzqiltw. All rights reserved.
//

#import "ZQBLEUTool.h"
@interface ZQBLEUTool()
@property (nonatomic, strong) NSMutableArray *pValues;

@end
@implementation ZQBLEUTool

/**
 *  得到一个翻译译文参照其他翻译译文的BLEU得分
 *
 *  @param first   <#first description#>
 *  @param strings <#strings description#>
 *  @param n       <#n description#>
 *  @param type    <#type description#>
 *
 *  @return <#return value description#>
 */
- (double)getBLUEScoreofFirst:(NSString *)first andStrings:(NSArray *)strings Ngram:(NSInteger)n ofType:(TranslateType)type
{
    first = [self addSpace2CNStringAndLower:first ofType:type];
    NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:strings.count];
    for (NSString *str in strings) {
        [tmp addObject:[self addSpace2CNStringAndLower:str ofType:type]];
    }
    strings = [NSArray arrayWithArray:tmp];
    
    double score =[self getScoreOfString:first strs:strings Ngram:n];
    return score;
}

- (NSUInteger)getCountOfString:(NSString *)string inDict:(NSDictionary *)dict
{
    if ([dict.allKeys containsObject:string]) {
        return [dict[string] integerValue];
    }
    return 0;
}

- (NSMutableDictionary *)countNgramTimesOfStrings:(NSArray *)strs {
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    for (NSString *str in strs) {
        if (result[str] != nil) {
            NSInteger count = [result[str] integerValue];
            count++;
            result[str] = @(count);
        } else {
            result[str] = @(1);
        }
    }
    return result;
}

- (NSInteger)getLengthOfSentence:(NSString *)s
{
    NSArray *strs = [s componentsSeparatedByCharactersInSet:[self whiteSpaceAndPunctuationCharset]];
    return strs.count;
}

- (NSString *)addSpace2CNStringAndLower:(NSString *)searchText ofType:(TranslateType)type
{
    NSMutableString *tmpStr = [NSMutableString stringWithString:searchText];
    NSUInteger length = tmpStr.length;
    NSString *biaodianStr = @",.!?，。？！";
    
    /**
     *  句子中标点无空格版本
     */
    //    NSInteger j = -2;
    //    for (NSInteger i = 0; i < length; ++i) {
    //        NSString *single = [searchText substringWithRange:NSMakeRange(i, 1)];
    //        if ([biaodianStr rangeOfString:single].location != NSNotFound) {
    //            j = [tmpStr rangeOfString:single options:NSCaseInsensitiveSearch range:NSMakeRange(j+2, tmpStr.length-j-2)].location;
    //            [tmpStr insertString:@" " atIndex:j];
    //            if (i != length - 1) {
    //                [tmpStr insertString:@" " atIndex:j+2];
    //            }
    //        }
    //    }
    
    /**
     *  句子中标点有空格版本
     */
    NSInteger j = -2;
    for (NSInteger i = 0; i < length; ++i) {
        NSString *single = [searchText substringWithRange:NSMakeRange(i, 1)];
        if ([biaodianStr rangeOfString:single].location != NSNotFound) {
            j = [tmpStr rangeOfString:single options:NSCaseInsensitiveSearch range:NSMakeRange(j+2, tmpStr.length-j-2)].location;
            [tmpStr insertString:@" " atIndex:j];
        }
    }
    
    if (type == TranslateTypeCn2En) {
        return [tmpStr lowercaseString];
    }
    
    if (type == TranslateTypeEn2Cn) {// 英文翻译成中文，翻译结果是中文，需要切分
        for (NSInteger i = 1; i < length * 2 - 1; i += 2) {
            [tmpStr insertString:@" " atIndex:i];
        }
    }

    return tmpStr;
}

- (NSInteger)getCountOfString:(NSString *)s Ngram:(NSInteger)n
{
    NSArray *strs = [s componentsSeparatedByCharactersInSet:[self whiteSpaceAndPunctuationCharset]];
    return strs.count - n + 1;
}

- (NSDictionary *)clipString:(NSString *)s ofNgram:(NSInteger)n
{
    NSArray *strs = [s componentsSeparatedByCharactersInSet:[self whiteSpaceAndPunctuationCharset]];
    
    NSInteger count = strs.count;
    NSMutableArray *strings = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < count - n + 1; ++i) {
        NSMutableString *ms = [NSMutableString stringWithString:strs[i]];
        for (NSInteger j = 1; j < n; ++j) {
            [ms appendString:strs[i + j]];
        }
        [strings addObject:ms];
    }
    return [self countNgramTimesOfStrings:strings];
}

- (NSMutableCharacterSet *)whiteSpaceAndPunctuationCharset
{
    NSMutableCharacterSet *charset = [[NSMutableCharacterSet alloc] init];
    [charset formUnionWithCharacterSet:[NSCharacterSet whitespaceCharacterSet]];
    //    [charset formUnionWithCharacterSet:[NSCharacterSet punctuationCharacterSet]];
    return charset;
}

- (double)getPValueOfString:(NSString *)s strs:(NSArray *)strs Ngram:(NSInteger)n
{
    NSDictionary *map = [self clipString:s ofNgram:n];
//    NSLog(@"map:%@", map);
    double result = 0.0;
    NSMutableArray *strMaps = [[NSMutableArray alloc] init];
    for (NSString *str in strs) {
        [strMaps addObject:[self clipString:str ofNgram:n]];
    }
//    NSLog(@"strmaps:%@", strMaps);
    for (NSString *key in map.allKeys) {
        NSInteger count = [map[key] intValue];
        NSInteger tmpResult = 0;
        NSInteger max = -1;
        
        for (NSDictionary *strMap in strMaps) {
            NSInteger tmpCount = [self getCountOfString:key inDict:strMap];
            max = MAX(tmpCount, max);
        }
        tmpResult = MIN(max, count);
        result += tmpResult;
    }
//    NSLog(@"%lf/%ld", result, (long)[self getCountOfString:s Ngram:n]);
    result = result / (double)[self getCountOfString:s Ngram:n];
    return result;
}

- (double)getBPOfString:(NSString *)s strs:(NSArray *)strs
{
    NSInteger count = [self getLengthOfSentence:s];
    NSInteger min = [self getLengthOfSentence:strs[0]];
    for (NSString *str in strs) {
        min = MIN(min, [self getLengthOfSentence:str]);
    }
    if (count >= min) {
        return 1;
    }
    double result = exp(1 - min / (double)count);
    return result;
}

- (double)getScoreOfString:(NSString *)s strs:(NSArray *)strs Ngram:(NSInteger)n
{
    if (n > 4) {
        return -1;
    }
    
    double score = 0.0;
    double bp = [self getBPOfString:s strs:strs];
    
    double weight = 1.0 / (double)n;
    
    self.pValues = [[NSMutableArray alloc] init];
    double p1 = [self getPValueOfString:s strs:strs Ngram:1];
    double p2 = [self getPValueOfString:s strs:strs Ngram:2];
    double p3 = [self getPValueOfString:s strs:strs Ngram:3];
    double p4 = [self getPValueOfString:s strs:strs Ngram:4];
    [self.pValues addObject:@(p1)];
    [self.pValues addObject:@(p2)];
    [self.pValues addObject:@(p3)];
    [self.pValues addObject:@(p4)];
    
    for (NSInteger i = 0; i < n; ++i) {
        score += log([self.pValues[i] doubleValue]);
    }
    score = bp * exp(weight * score);
    
    return score;
    
}

@end
