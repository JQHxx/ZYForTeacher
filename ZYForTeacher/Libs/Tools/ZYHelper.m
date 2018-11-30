//
//  ZYHelper.m
//  ZuoYe
//
//  Created by vision on 2018/8/3.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "ZYHelper.h"


@implementation ZYHelper

singleton_implementation(ZYHelper)

#pragma mark 获取年级
-(NSArray *)grades{
    NSString *fliePath = [self getFilePathWithFileName:@"grade"];
    return [NSArray arrayWithContentsOfFile:fliePath];
}

#pragma mark 设置年级
-(void)setGrades:(NSArray *)grades{
    if (grades.count>0) {
        NSString *filepath = [self getFilePathWithFileName:@"grade"];
        NSMutableArray *tempArr = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in grades) {
            [tempArr addObject:dict[@"grade"]];
        }
        [tempArr writeToFile:filepath atomically:YES];
    }
}

#pragma mark 解析年级
-(NSString *)parseToGradeStringForGrades:(NSArray *)gradesArr{
    NSString *grade = @"";
    for (NSString *gradeStr in gradesArr) {
        grade =[grade stringByAppendingString:[gradeStr substringToIndex:1]];
        grade = [grade stringByAppendingString:@"/"];
    }
    NSString *tempStr = [grade substringToIndex:grade.length-1];
    return [tempStr stringByAppendingString:@"年级"];
}

#pragma mark 获取科目
-(NSArray *)subjects{
    NSString *fliePath = [self getFilePathWithFileName:@"subject"];
    return [NSArray arrayWithContentsOfFile:fliePath];
}

#pragma mark 设置科目
-(void)setSubjects:(NSArray *)subjects{
    NSString *filepath = [self getFilePathWithFileName:@"subject"];
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in subjects) {
        [tempArr addObject:dict[@"subject"]];
    }
    [tempArr writeToFile:filepath atomically:YES];
}

#pragma mark 是否认证
-(BOOL)isCertified{
    NSNumber *authId = [NSUserDefaultsInfos getValueforKey:kAuthIdentidy];
    NSNumber *authEdu = [NSUserDefaultsInfos getValueforKey:kAuthEducation];
    return ([authId integerValue]==2)&&([authEdu integerValue]==2);
}

#pragma mark 银行信息
-(NSDictionary *)banksDict{
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"banks" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:filepath];
    return dict;
}

#pragma mark 根据银行获取银行卡代号
-(NSString *)getBankCodeWithBankName:(NSString *)bankName{
    __block NSString *bankCode = nil;
    [self.banksDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:bankName]) {
            bankCode = key;
        }
    }];
    return bankCode;
}

#pragma mark -- 辅导订单相关
#pragma mark -- 限制emoji表情输入
-(BOOL)strIsContainEmojiWithStr:(NSString*)str{
    __block BOOL returnValue =NO;
    [str enumerateSubstringsInRange:NSMakeRange(0, [str length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop){
         const unichar hs = [substring characterAtIndex:0];
         if(0xd800<= hs && hs <=0xdbff){
             if(substring.length>1){
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs -0xd800) *0x400) + (ls -0xdc00) +0x10000;
                 if(0x1d000<= uc && uc <=0x1f77f){
                     returnValue =YES;
                 }
             }
         }
         else if(substring.length>1){
             const unichar ls = [substring characterAtIndex:1];
             if(ls ==0x20e3)
             {
                 returnValue =YES;
             }
         }else{
             // non surrogate
             if(0x2100<= hs && hs <=0x27ff&& hs !=0x263b)
             {
                 returnValue =YES;
             }
             else if(0x2B05<= hs && hs <=0x2b07)
             {
                 returnValue =YES;
             }
             else if(0x2934<= hs && hs <=0x2935)
             {
                 returnValue =YES;
             }
             else if(0x3297<= hs && hs <=0x3299)
             {
                 returnValue =YES;
             }
             else if(hs ==0xa9|| hs ==0xae|| hs ==0x303d|| hs ==0x3030|| hs ==0x2b55|| hs ==0x2b1c|| hs ==0x2b1b|| hs ==0x2b50|| hs ==0x231a)
             {
                 returnValue =YES;
             }
         }
     }];
    return returnValue;
}
#pragma mark -- 限制第三方键盘（常用的是搜狗键盘）的表情
- (BOOL)hasEmoji:(NSString*)string;
{
    NSString *pattern = @"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:string];
    return isMatch;
}
#pragma mark -- 判断当前是不是在使用九宫格输入
-(BOOL)isNineKeyBoard:(NSString *)string
{
    NSString *other = @"➋➌➍➎➏➐➑➒";
    int len = (int)string.length;
    for(int i=0;i<len;i++)
    {
        if(!([other rangeOfString:string].location != NSNotFound))
            return NO;
    }
    return YES;
}

#pragma mark 对图片base64加密
- (NSMutableArray *)imageDataProcessingWithImgArray:(NSMutableArray *)imgArray{
    NSMutableArray *photoArray = [NSMutableArray array];
    for (NSInteger i = 0; i < imgArray.count; i++) {
        NSData *imageData = [UIImage zipNSDataWithImage:imgArray[i]];
//        NSData *imageData = UIImagePNGRepresentation(imgArray[i]);
        //将图片数据转化为64为加密字符串
        NSString *encodeResult = [imageData base64EncodedStringWithOptions:0];
        [photoArray addObject:encodeResult];
    }
    return photoArray;
}

#pragma mark 将某个时间转化成 时间戳
-(NSNumber *)timeSwitchTimestamp:(NSString *)formatTime format:(NSString *)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format];
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSDate* date = [formatter dateFromString:formatTime];    //将字符串按formatter转成nsdate
    return [NSNumber numberWithDouble:[date timeIntervalSince1970]];
}

#pragma mark 时间戳转化为时间
- (NSString *)timeWithTimeIntervalNumber:(NSNumber *)timeNum format:(NSString *)format{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format];
    
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeNum integerValue]];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}

#pragma mark 将年级字符串数组转为年级id数组
-(NSMutableArray *)setGradeIdsArrayWithGradeStrs:(NSArray *)grades{
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    for (NSString *grade in grades) {
        NSInteger index = [self.grades indexOfObject:grade];
        NSNumber *indexNum = [NSNumber numberWithInteger:index+1];
        [tempArr addObject:indexNum];
    }
    return tempArr;
}

-(NSString *)pleaseInsertStarTimeo:(NSString *)time1 andInsertEndTime:(NSString *)time2{
    // 1.将时间转换为date
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy年MM月dd日 HH:mm:ss";
    NSDate *date1 = [formatter dateFromString:time1];
    NSDate *date2 = [formatter dateFromString:time2];
    
    // 2.创建日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit type = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 3.利用日历对象比较两个时间的差值
    NSDateComponents *cmps = [calendar components:type fromDate:date1 toDate:date2 options:0];
    // 4.输出结果
    NSLog(@"两个时间相差%ld年%ld月%ld日%ld小时%ld分钟%ld秒", cmps.year, cmps.month, cmps.day, cmps.hour, cmps.minute, cmps.second);
    
    return [NSString stringWithFormat:@"%ld小时%ld分钟",cmps.hour, cmps.minute];
}

#pragma mark -- Private methods
#pragma mark  获取年级目录
-(NSString *)getFilePathWithFileName:(NSString *)fileName{
    //获取plist文件的路径
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path1 = [pathArray objectAtIndex:0];
    return [path1 stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",fileName]];
}

@end
