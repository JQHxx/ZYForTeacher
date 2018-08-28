//
//  ChatTimeCell.m
//  ZuoYe
//
//  Created by vision on 2018/8/23.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "ChatTimeCell.h"

@interface ChatTimeCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation ChatTimeCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

#pragma mark -- setters
-(void)setTitleStr:(NSString *)titleStr{
    _titleStr = titleStr;
    self.titleLabel.text = titleStr;
    
    CGFloat titleWidth=[titleStr boundingRectWithSize:CGSizeMake(kScreenWidth, 30) withTextFont:self.titleLabel.font].width;
    self.titleLabel.frame=CGRectMake((kScreenWidth-floor(titleWidth)-10)/2, 5, floor(titleWidth)+10, 25);
}

#pragma mark -- getters
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor bgColor_Gray];
        _titleLabel.layer.cornerRadius=3;
        _titleLabel.clipsToBounds=YES;
        _titleLabel.textColor = [UIColor grayColor];
        _titleLabel.font = kFontWithSize(12);
    }
    return _titleLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



@end
