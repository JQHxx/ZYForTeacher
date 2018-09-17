//
//  BaseViewController.m
//  ZuoYe
//
//  Created by vision on 2018/8/3.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    UIView        *navView;
    UIButton      *backBtn;
    UILabel       *titleLabel;
    UIImageView   *topShawView;
    
}

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout=UIRectEdgeNone;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.interactivePopGestureRecognizer.enabled=YES;
    self.navigationController.interactivePopGestureRecognizer.delegate=(id)self;
    
    [self.navigationController setNavigationBarHidden:YES];
    
    [self customNavBar];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

#pragma mark 状态栏样式
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

#pragma mark -- Delegate
#pragma mark  UIImagePickerControllerDelegate
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self.imgPicker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- Event response
#pragma mark 左侧返回方法
-(void)leftNavigationItemAction{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 导航栏右侧按钮事件
-(void)rightNavigationItemAction{
    
}


#pragma mark --Private Methods
#pragma mark 自定义导航栏
-(void)customNavBar{
    navView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavHeight)];
    navView.backgroundColor=kSystemColor;
    [self.view addSubview:navView];
    
    backBtn=[[UIButton alloc] initWithFrame:CGRectMake(5,KStatusHeight + 2, 40, 40)];
    [backBtn setImage:[UIImage drawImageWithName:@"return"size:CGSizeMake(10, 17)] forState:UIControlStateNormal];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0,-10.0, 0, 0)];
    [backBtn addTarget:self action:@selector(leftNavigationItemAction) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:backBtn];
    
    titleLabel =[[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth-180)/2, KStatusHeight+12, 180, 22)];
    titleLabel.textColor=[UIColor colorWithHexString:@"#4A4A4A"];
    titleLabel.font=[UIFont pingFangSCWithWeight:FontWeightStyleMedium size:18];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    [navView addSubview:titleLabel];
    
    self.rightBtn=[[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-50, KStatusHeight+5, 40, 32)];
    [self.rightBtn addTarget:self action:@selector(rightNavigationItemAction) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:self.rightBtn];
    
    topShawView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth,6)];
    topShawView.image = [UIImage imageNamed:@"top_shadow"];
    [navView addSubview:topShawView];
}

#pragma mark  上传照片
-(void)addPhoto{
    NSString *cancelButtonTitle = NSLocalizedString(@"取消", nil);
    NSString *cameraButtonTitle = NSLocalizedString(@"拍照", nil);
    NSString *photoButtonTitle = NSLocalizedString(@"从手机相册选择", nil);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:cameraButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        self.imgPicker=[[UIImagePickerController alloc]init];
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) //判断设备相机是否可用
        {
            self.imgPicker=[[UIImagePickerController alloc]init];
            self.imgPicker.sourceType=UIImagePickerControllerSourceTypeCamera;
            self.imgPicker.delegate=self;
            self.imgPicker.allowsEditing=YES;
            if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
                self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
            }
            [self presentViewController:self.imgPicker animated:YES completion:nil];
        }else{
            [self.view makeToast:@"您的相机不可用" duration:1.0 position:CSToastPositionCenter];
        }
    }];
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:photoButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        self.imgPicker=[[UIImagePickerController alloc]init];
        self.imgPicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        self.imgPicker.delegate=self;
        self.imgPicker.allowsEditing=YES;
        if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
            self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
        }
        [self presentViewController:self.imgPicker animated:YES completion:nil];
        
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:cameraAction];
    [alertController addAction:photoAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark -- setters and getters
#pragma mark 设置是否隐藏导航栏
-(void)setIsHiddenNavBar:(BOOL)isHiddenNavBar{
    _isHiddenNavBar = isHiddenNavBar;
    navView.hidden = isHiddenNavBar;
}

#pragma mark 设置是否隐藏返回按钮
-(void)setIsHiddenBackBtn:(BOOL)isHiddenBackBtn{
    _isHiddenBackBtn = isHiddenBackBtn;
    backBtn.hidden = isHiddenBackBtn;
}

#pragma makr 设置导航栏左侧按钮图片
-(void)setLeftImageName:(NSString *)leftImageName{
    _leftImageName=leftImageName;
    if (_leftImageName) {
        backBtn.hidden=NO;
        [backBtn setImage:[UIImage drawImageWithName:_leftImageName size:CGSizeMake(20, 20)] forState:UIControlStateNormal];
        [backBtn setImageEdgeInsets:UIEdgeInsetsZero];
    }
}
#pragma mark 设置导航栏左侧按钮文字
- (void)setLeftTitleName:(NSString *)leftTitleName{
    _leftTitleName = leftTitleName;
    [backBtn setTitle:leftTitleName forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor colorWithHexString:@"#4A4A4A"] forState:UIControlStateNormal];
    backBtn.titleLabel.font=[UIFont pingFangSCWithWeight:FontWeightStyleRegular size:16];
    backBtn.titleLabel.textAlignment=NSTextAlignmentCenter;
    [backBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
}

#pragma mark 设置导航栏右侧按钮图片
-(void)setRightImageName:(NSString *)rightImageName{
    _rightImageName=rightImageName;
    [self.rightBtn setImage:[UIImage drawImageWithName:rightImageName size:CGSizeMake(24, 24)] forState:UIControlStateNormal];
}

#pragma mark 设置导航栏右侧按钮文字
-(void)setRigthTitleName:(NSString *)rigthTitleName{
    _rigthTitleName=rigthTitleName;
    [self.rightBtn setTitle:rigthTitleName forState:UIControlStateNormal];
    [self.rightBtn setTitleColor:[UIColor colorWithHexString:@"#4A4A4A"] forState:UIControlStateNormal];
    if (rigthTitleName.length>=4) {
        CGSize size = [rigthTitleName sizeWithLabelWidth:kScreenWidth font:[UIFont pingFangSCWithWeight:FontWeightStyleRegular size:16]];
        self.rightBtn.frame = CGRectMake(kScreenWidth-size.width-10,KStatusHeight +5, size.width, 32);
    }
    self.rightBtn.titleLabel.font=[UIFont pingFangSCWithWeight:FontWeightStyleRegular size:16];
    self.rightBtn.titleLabel.textAlignment=NSTextAlignmentCenter;
}

#pragma mark 设置右侧按钮能否点击
-(void)setIsRightBtnEnable:(BOOL)isRightBtnEnable{
    _isRightBtnEnable = isRightBtnEnable;
    if (isRightBtnEnable) {
        self.rightBtn.userInteractionEnabled  = YES;
        self.rightBtn.alpha = 1.0;
    }else{
        self.rightBtn.userInteractionEnabled  = NO;
        self.rightBtn.alpha = 0.4;
    }
}

#pragma mark 隐藏导航栏阴影
-(void)setIsHiddenShaw:(BOOL)isHiddenShaw{
    _isHiddenShaw = isHiddenShaw;
    topShawView.hidden = isHiddenShaw;
}

#pragma mark 设置标题
-(void)setBaseTitle:(NSString *)baseTitle{
    _baseTitle=baseTitle;
    titleLabel.text=baseTitle;
}

-(void)dealloc {
    MyLog(@"dealloc--%@",NSStringFromClass([self class]));
}


@end
