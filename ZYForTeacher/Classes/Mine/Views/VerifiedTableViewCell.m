//
//  VerifiedTableViewCell.m
//  ZYForTeacher
//
//  Created by vision on 2018/9/4.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "VerifiedTableViewCell.h"

@interface VerifiedTableViewCell (){
    UILabel    *titleLab;
}


@end

@implementation VerifiedTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        titleLab = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, 40, 30)];
        titleLab.font = kFontWithSize(14);
        titleLab.textColor = [UIColor blackColor];
        [self.contentView addSubview:titleLab];
        
        self.exampleBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-80, 10, 40, 30)];
        [self.exampleBtn setTitle:@"示例" forState:UIControlStateNormal];
        [self.exampleBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        self.exampleBtn.titleLabel.font = kFontWithSize(14);
        self.exampleBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.exampleBtn];
        
        self.addPhotoBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, titleLab.bottom+10, kScreenWidth-80,(kScreenWidth-80)*(55.0/90.0))];
        [self.addPhotoBtn setImage:[UIImage imageNamed:@"ic_frame_add"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.addPhotoBtn];
    }
    return self;
}

-(void)setTitleStr:(NSString *)titleStr{
    titleLab.text = titleStr;
}

-(void)setAddImage:(UIImage *)addImage{
    _addImage = addImage;
    if (addImage) {
        [self.addPhotoBtn setImage:addImage forState:UIControlStateNormal];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
