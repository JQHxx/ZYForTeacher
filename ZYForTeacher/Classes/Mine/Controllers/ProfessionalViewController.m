//
//  ProfessionalViewController.m
//  ZYForTeacher
//
//  Created by vision on 2018/9/4.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "ProfessionalViewController.h"
#import "LoginButton.h"

@interface ProfessionalViewController (){
    UIImage    *selImage;
    UIButton   *addPhotoBtn;
}

@end

@implementation ProfessionalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"等级职称";
    
    [self initProfessionalView];
}

#pragma mark  UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [self.imgPicker dismissViewControllerAnimated:YES completion:nil];
    selImage= [info objectForKey:UIImagePickerControllerOriginalImage];
    
    MyLog(@"image-- h:%.1f,w:%.1f",selImage.size.height,selImage.size.width);
    [addPhotoBtn setImage:selImage forState:UIControlStateNormal];
}

#pragma mark -- Event Response
#pragma mark 上传图片
-(void)addProfessionalAction:(UIButton *)sender{
    [self addPhotoForView:sender];
}

#pragma mark 提交
-(void)submitProfessionalAction:(UIButton *)sender{
    sender.enabled = NO;
    if (kIsEmptyObject(selImage)) {
        [self.view makeToast:@"请先上传图片" duration:1.0 position:CSToastPositionCenter];
        sender.enabled = YES;
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
        [TCHttpRequest postMethodWithURL:kCertifySkillAPI body:body success:^(id json) {
            [ZYHelper sharedZYHelper].isUpdateUserInfo = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                sender.enabled = YES;
                [weakSelf.view makeToast:@"您的等级职称信息已提交，请等待审核" duration:1.0 position:CSToastPositionCenter];
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
        }];
    }];
}

#pragma mark 初始化界面
-(void)initProfessionalView{
    
    addPhotoBtn = [[UIButton alloc] initWithFrame:IS_IPAD?CGRectMake(138, kNavHeight+40, kScreenWidth-276, 276):CGRectMake(29, kNavHeight+30, kScreenWidth-55,(kScreenWidth-55)*(18.0/32.0))];
    addPhotoBtn.backgroundColor = [UIColor colorWithHexString:@"#F1F1F2"];
    addPhotoBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    addPhotoBtn.imageView.clipsToBounds = YES;
    [addPhotoBtn setImage:[UIImage drawImageWithName:@"add_photo" size:CGSizeMake(49, 46)] forState:UIControlStateNormal];
    [addPhotoBtn addTarget:self action:@selector(addProfessionalAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addPhotoBtn];
    
    UILabel *tipsLab = [[UILabel alloc] initWithFrame:CGRectMake(30, addPhotoBtn.bottom+20, kScreenWidth-60, 30)];
    tipsLab.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:IS_IPAD?24:14];
    tipsLab.text = @"*请提交证明您等级职称的照片*";
    tipsLab.textAlignment = NSTextAlignmentCenter;
    tipsLab.textColor = [UIColor colorWithHexString:@"#9B9B9B"];
    [self.view addSubview:tipsLab];
    
    CGRect btnFrame = IS_IPAD?CGRectMake((kScreenWidth-515)/2.0,tipsLab.bottom+37.0,515, 75):CGRectMake(48,tipsLab.bottom+37.0,kScreenWidth-96, 60);
    LoginButton *submitBtn = [[LoginButton alloc] initWithFrame:btnFrame title:@"提交"];
    [submitBtn addTarget:self action:@selector(submitProfessionalAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];
    
    
}

@end
