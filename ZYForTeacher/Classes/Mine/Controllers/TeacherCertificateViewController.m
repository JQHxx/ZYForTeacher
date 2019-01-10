//
//  TeacherCertificateViewController.m
//  ZYForTeacher
//
//  Created by vision on 2018/9/4.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "TeacherCertificateViewController.h"
#import "LoginButton.h"
#import "UIButton+Touch.h"

@interface TeacherCertificateViewController (){
    UIImage     *selImage;
    UIButton    *addPhotoBtn;
    
    UIButton    *submitBtn;
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
    selImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    MyLog(@"image-- h:%.1f,w:%.1f",selImage.size.height,selImage.size.width);
    [addPhotoBtn setImage:selImage forState:UIControlStateNormal];
}

#pragma mark -- Event Response
#pragma mark 上传图片
-(void)addTeacherCertificateAction:(UIButton *)sender{
    [self addPhotoForView:sender];
}

#pragma mark
-(void)submitTeacherCertificationAction:(UIButton *)sender{
    submitBtn.enabled = NO;
    if (kIsEmptyObject(selImage)) {
        [self.view makeToast:@"请先上传图片" duration:1.0 position:CSToastPositionCenter];
        submitBtn.enabled = YES;
        return;
    }
    //上传图片
    NSMutableArray *imgsArr = [NSMutableArray arrayWithObjects:addPhotoBtn.currentImage, nil];
    NSMutableArray *encodeImageArr = [[ZYHelper sharedZYHelper] imageDataProcessingWithImgArray:imgsArr];
    NSString *encodeResult = [TCHttpRequest getValueWithParams:encodeImageArr];
    kSelfWeak;
    NSString *body = [NSString stringWithFormat:@"pic=%@&dir=2",encodeResult];
    [TCHttpRequest postMethodWithURL:kUploadPicAPI body:body success:^(id json) {
        NSArray *imgUrls = [json objectForKey:@"data"];
        NSString *body = [NSString stringWithFormat:@"token=%@&card_url=%@",kUserTokenValue,imgUrls[0]];
        [TCHttpRequest postMethodWithURL:kCertifyTeacherAPI body:body success:^(id json) {
            [ZYHelper sharedZYHelper].isUpdateUserInfo = YES;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                submitBtn.enabled = YES;
                [weakSelf.view makeToast:@"您的教师资质信息已提交，请等待审核" duration:1.0 position:CSToastPositionCenter];
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
        }];
    }];
}

#pragma mark 初始化界面
-(void)initTeacherCertificateView{
    UILabel *lab = [[UILabel alloc] initWithFrame:IS_IPAD?CGRectMake(60, kNavHeight+30, kScreenWidth-120, 33):CGRectMake(30, kNavHeight+20, kScreenWidth-60, 22)];
    lab.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:IS_IPAD?24:16];
    lab.text = @"教师资质可证明您的教师身份";
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
    [self.view addSubview:lab];
    
    addPhotoBtn = [[UIButton alloc] initWithFrame:IS_IPAD?CGRectMake(138, lab.bottom+21, kScreenWidth-276, 276):CGRectMake(29, lab.bottom+14, kScreenWidth-55,(kScreenWidth-55)*(18.0/32.0))];
    addPhotoBtn.backgroundColor = [UIColor colorWithHexString:@"#F1F1F2"];
    addPhotoBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    addPhotoBtn.imageView.clipsToBounds = YES;
    [addPhotoBtn setImage:[UIImage drawImageWithName:@"add_photo" size:IS_IPAD?CGSizeMake(70, 65):CGSizeMake(49, 46)] forState:UIControlStateNormal];
    [addPhotoBtn addTarget:self action:@selector(addTeacherCertificateAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addPhotoBtn];
    
    UILabel *tipsLab = [[UILabel alloc] initWithFrame:IS_IPAD?CGRectMake(60, addPhotoBtn.bottom+20, kScreenWidth-120, 30):CGRectMake(30, addPhotoBtn.bottom+20, kScreenWidth-60, 30)];
    tipsLab.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:IS_IPAD?22:14];
    tipsLab.text = @"*请提交您的有效教师证照片*";
    tipsLab.textAlignment = NSTextAlignmentCenter;
    tipsLab.textColor = [UIColor colorWithHexString:@"#9B9B9B"];
    [self.view addSubview:tipsLab];
    
    CGRect btnFrame = IS_IPAD?CGRectMake((kScreenWidth-515)/2.0,tipsLab.bottom+100.0,515, 75):CGRectMake(48,tipsLab.bottom+37.0,kScreenWidth-96, 60);
    submitBtn = [[UIButton alloc] initWithFrame:btnFrame];
    [submitBtn setBackgroundImage:IS_IPAD?[UIImage imageNamed:@"login_bg_btn_ipad"]:[UIImage imageNamed:@"login_bg_btn"] forState:UIControlStateNormal];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitBtn.titleLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:IS_IPAD?25:16];
    [submitBtn addTarget:self action:@selector(submitTeacherCertificationAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];
}


@end
