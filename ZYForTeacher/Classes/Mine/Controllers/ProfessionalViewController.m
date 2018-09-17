//
//  ProfessionalViewController.m
//  ZYForTeacher
//
//  Created by vision on 2018/9/4.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "ProfessionalViewController.h"

@interface ProfessionalViewController (){
    UIButton   *addPhotoBtn;
}

@end

@implementation ProfessionalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"专业资质";
    
    [self initProfessionalView];
}

#pragma mark  UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [self.imgPicker dismissViewControllerAnimated:YES completion:nil];
    UIImage* curImage = [info objectForKey:UIImagePickerControllerEditedImage];
    curImage = [curImage cropImageWithSize:CGSizeMake(kScreenWidth-80, (kScreenWidth-80)*(9.0/16.0))];
    [addPhotoBtn setImage:curImage forState:UIControlStateNormal];
}

#pragma mark -- Event Response
#pragma mark 上传图片
-(void)addProfessionalAction{
    [self addPhoto];
}

-(void)submitProfessionalAction{
    
}

#pragma mark 初始化界面
-(void)initProfessionalView{
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(30, kNavHeight+20, kScreenWidth-60, 30)];
    lab.font = [UIFont boldSystemFontOfSize:16];
    lab.text = @"专业资质可提升学生对您的专业技能的认可";
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = [UIColor blackColor];
    [self.view addSubview:lab];
    
    addPhotoBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, lab.bottom+20, kScreenWidth-80, (kScreenWidth-80)*(9.0/16.0))];
    [addPhotoBtn setImage:[UIImage imageNamed:@"ic_frame_add"] forState:UIControlStateNormal];
    [addPhotoBtn addTarget:self action:@selector(addProfessionalAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addPhotoBtn];
    
    UILabel *tipsLab = [[UILabel alloc] initWithFrame:CGRectMake(30, addPhotoBtn.bottom+20, kScreenWidth-60, 30)];
    tipsLab.font = kFontWithSize(13);
    tipsLab.text = @"*请提交证明您专业能力的照片*";
    tipsLab.textAlignment = NSTextAlignmentCenter;
    tipsLab.textColor = [UIColor blackColor];
    [self.view addSubview:tipsLab];
    
    
    UIButton *submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, tipsLab.bottom+20, kScreenWidth-40, 35)];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitBtn.backgroundColor = kSystemColor;
    submitBtn.layer.cornerRadius = 5;
    [submitBtn addTarget:self action:@selector(submitProfessionalAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];
    
}

@end
