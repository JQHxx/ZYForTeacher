//
//  TeacherCertificateViewController.m
//  ZYForTeacher
//
//  Created by vision on 2018/9/4.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "TeacherCertificateViewController.h"

@interface TeacherCertificateViewController (){
    UIButton    *addPhotoBtn;
}

@end

@implementation TeacherCertificateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"教师资质";
    
    [self initTeacherCertificateView];
    
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
-(void)addTeacherCertificateAction{
    [self addPhoto];
}

-(void)submitTeacherCertificationAction{
    
}

#pragma mark 初始化界面
-(void)initTeacherCertificateView{
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(30, kNavHeight+20, kScreenWidth-60, 30)];
    lab.font = [UIFont boldSystemFontOfSize:16];
    lab.text = @"教师资质可证明您的教师身份";
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = [UIColor blackColor];
    [self.view addSubview:lab];
    
    addPhotoBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, lab.bottom+20, kScreenWidth-80, (kScreenWidth-80)*(9.0/16.0))];
    [addPhotoBtn setImage:[UIImage imageNamed:@"ic_frame_add"] forState:UIControlStateNormal];
    [addPhotoBtn addTarget:self action:@selector(addTeacherCertificateAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addPhotoBtn];
    
    UILabel *tipsLab = [[UILabel alloc] initWithFrame:CGRectMake(30, addPhotoBtn.bottom+20, kScreenWidth-60, 30)];
    tipsLab.font = kFontWithSize(13);
    tipsLab.text = @"*请提交您的有效教师证照片*";
    tipsLab.textAlignment = NSTextAlignmentCenter;
    tipsLab.textColor = [UIColor blackColor];
    [self.view addSubview:tipsLab];
    
    
    UIButton *submitBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, tipsLab.bottom+20, kScreenWidth-40, 35)];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitBtn.backgroundColor = kSystemColor;
    submitBtn.layer.cornerRadius = 5;
    [submitBtn addTarget:self action:@selector(submitTeacherCertificationAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];
    
}


@end
