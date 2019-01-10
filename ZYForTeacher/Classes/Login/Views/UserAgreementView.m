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
        
        NSInteger len = tempStr.length - 8;
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectZero];
        label1.textColor = [UIColor colorWithHexString:@"#808080"];
        label1.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:IS_IPAD?24:14.0];
        label1.text = [tempStr substringToIndex:len];
        CGFloat labW1 = [label1.text boundingRectWithSize:IS_IPAD?CGSizeMake(kScreenWidth, 36):CGSizeMake(kScreenWidth, 20) withTextFont:label1.font].width;
        label1.frame = IS_IPAD?CGRectMake(0, 0, labW1, 36):CGRectMake(0, 0, labW1, 20);
        [self addSubview:label1];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:IS_IPAD?CGRectMake(label1.right, 0, frame.size.width-labW1, 36):CGRectMake(label1.right,0, frame.size.width-labW1, 20)];
        label2.textColor = [UIColor colorWithHexString:@"#FF727A"];
        label2.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:IS_IPAD?24:14.0];
        
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
