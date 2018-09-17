//
//  VerifiedTableViewCell.h
//  ZYForTeacher
//
//  Created by vision on 2018/9/4.
//  Copyright © 2018年 vision. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VerifiedTableViewCell : UITableViewCell

@property (nonatomic ,strong) UIButton *exampleBtn;
@property (nonatomic ,strong) UIButton *addPhotoBtn;

@property (nonatomic , copy ) NSString *titleStr;
@property (nonatomic ,strong) UIImage  *addImage;

@end
