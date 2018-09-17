//
//  UserAgreementView.m
//  ZuoYe
//
//  Created by vision on 2018/8/9.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "UserAgreementView.h"

@implementation UserAgreementView

-(instancetype)initWithFrame:(CGRect)frame string:(NSString *)tempStr{
    self = [super initWithFrame:frame];
    if (self) {
        
        NSInteger len = tempStr.length - 11;
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectZero];
        label1.textColor = [UIColor whiteColor];
        label1.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:14.0];
        label1.text = [tempStr substringToIndex:len];
        CGFloat labW1 = [label1.text boundingRectWithSize:CGSizeMake(kScreenWidth, 20) withTextFont:label1.font].width;
        label1.frame = CGRectMake(0, 0, labW1, 20);
        [self addSubview:label1];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(label1.right,0, frame.size.width-labW1, 20)];
        label2.textColor = [UIColor whiteColor];
        label2.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:14.0];
        
        NSString *textStr = [tempStr substringFromIndex:len];
        // 下划线
        NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:textStr attributes:attribtDic];
        label2.attributedText = attribtStr;
        
        [self addSubview:label2];
        
        label2.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewUserAgreement)];
        [label2 addGestureRecognizer:tap];
    }
    return self;
}

-(void)viewUserAgreement{
    self.clickAction();
}

@end
