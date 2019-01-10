//
//  VerifiedViewController.m
//  ZYForTeacher
//
//  Created by vision on 2018/9/4.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "VerifiedViewController.h"

#define kPhotoWidth  kScreenWidth-55
#define kPhotoHeight (kScreenWidth-55)*(18.0/32.0)


@interface VerifiedViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    NSString       *nameStr;
    NSString       *numberStr;
    
    NSInteger      selectedIndex;
    UIImage        *frontImage;
    UIImage        *obverseImage;
}

@property (nonatomic ,strong) UITableView *verifiedTableView;

@end

@implementation VerifiedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"实名认证";
    
    self.rigthTitleName = @"提交";
    
    [self.view addSubview:self.verifiedTableView];
    
}

#pragma mark -- UITableViewDataSource and UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row<2) {
        
        UILabel *lab = [[UILabel alloc] initWithFrame:IS_IPAD?CGRectMake(40, 20, 100, 36):CGRectMake(24, 15, 65, 22)];
        lab.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:IS_IPAD?25:16];
        lab.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
        lab.text = indexPath.row==0?@"真实姓名":@"身份证号";
        [cell.contentView addSubview:lab];
        
        UITextField *detailText = [[UITextField alloc] initWithFrame:IS_IPAD?CGRectMake(kScreenWidth-400, 20, 360, 36):CGRectMake(kScreenWidth-200, 15,183, 22)];
        detailText.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:IS_IPAD?25:16];
        detailText.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
        detailText.returnKeyType = UIReturnKeyDone;
        detailText.delegate = self;
        detailText.textAlignment = NSTextAlignmentRight;
        detailText.tag = indexPath.row;
        [cell.contentView addSubview:detailText];
        if (indexPath.row==0) {
            detailText.text = nameStr;
            detailText.placeholder = @"请输入真实姓名";
            detailText.keyboardType = UIKeyboardTypeDefault;
        }else{
            detailText.text = numberStr;
            detailText.placeholder = @"请输入身份证号";
            detailText.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        }
   
        UILabel *line = [[UILabel alloc] initWithFrame:IS_IPAD?CGRectMake(40, 75.5, kScreenWidth-80, 0.5):CGRectMake(20, 49.5, kScreenWidth-20, 0.5)];
        line.backgroundColor = [UIColor colorWithHexString:@"#D8D8D8"];
        [cell.contentView addSubview:line];
    }else{
        
        UILabel *titleLab = [[UILabel alloc] initWithFrame:IS_IPAD?CGRectMake(40, 20, 200, 36):CGRectMake(25, 15, 120, 22)];
        titleLab.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:IS_IPAD?25:16];
        titleLab.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
        titleLab.text = @"上传身份证照片";
        [cell.contentView addSubview:titleLab];
        
        NSArray *titles = @[@"(请上传身份证正面照片)",@"(请上传身份证反面照片)"];
        for (NSInteger i=0; i<2; i++) {
            UIButton *addPhotoBtn =[[UIButton alloc] initWithFrame:IS_IPAD?CGRectMake(138, titleLab.bottom+20+i*(276+62),kScreenWidth-276, 276):CGRectMake(29,titleLab.bottom+14+i*(kPhotoHeight+40),kPhotoWidth,kPhotoHeight)];
            addPhotoBtn.backgroundColor = [UIColor colorWithHexString:@"#F1F1F2"];
            addPhotoBtn.tag = i;
            [addPhotoBtn addTarget:self action:@selector(addVerifiedPhotoAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:addPhotoBtn];
            if (i==0) {
                UIImage *fImage = frontImage?frontImage:[UIImage drawImageWithName:@"add_photo" size:IS_IPAD?CGSizeMake(70, 65):CGSizeMake(49, 46)];
                [addPhotoBtn setImage:fImage forState:UIControlStateNormal];
                
            }else{
                UIImage *backImage = obverseImage?obverseImage:[UIImage drawImageWithName:@"add_photo" size:IS_IPAD?CGSizeMake(70, 65):CGSizeMake(49, 46)];
                [addPhotoBtn setImage:backImage forState:UIControlStateNormal];
            }
            
            UILabel *lab = [[UILabel alloc] initWithFrame:IS_IPAD?CGRectMake(80, addPhotoBtn.bottom+16, kScreenWidth-169, 30):CGRectMake(25,addPhotoBtn.bottom+10,kScreenWidth-50, 20)];
            lab.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:IS_IPAD?22:14];
            lab.textColor = [UIColor colorWithHexString:@"#9B9B9B"];
            lab.textAlignment = NSTextAlignmentCenter;
            lab.text = titles[i];
            [cell.contentView addSubview:lab];
        }
        
        UILabel *lab1 = [[UILabel alloc] initWithFrame:IS_IPAD?CGRectMake(50, titleLab.bottom+(276+62)*2+40, 150, 30):CGRectMake(25,titleLab.bottom+(kPhotoHeight+40)*2+30,100, 20)];
        lab1.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:IS_IPAD?22:14];
        lab1.textColor = [UIColor colorWithHexString:@"#FF6161"];
        lab1.text = @"*实名要求";
        [cell.contentView addSubview:lab1];
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectZero];
        lab.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:IS_IPAD?18:12];
        lab.textColor = [UIColor colorWithHexString:@"#808080"];
        lab.numberOfLines = 0;
        lab.text = @"1.请保证填写的信息真实有效；\n2.证件图片上的信息清晰可见、无遮挡、无修改";
        CGFloat labHeight = [lab.text boundingRectWithSize:IS_IPAD?CGSizeMake(kScreenWidth-100, CGFLOAT_MAX):CGSizeMake(kScreenWidth-50, CGFLOAT_MAX) withTextFont:lab.font].height;
        lab.frame = IS_IPAD?CGRectMake(50, lab1.bottom+7, kScreenWidth-80, labHeight):CGRectMake(25,lab1.bottom,kScreenWidth-50,labHeight);
        [cell.contentView addSubview:lab];
        
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row<2) {
        return IS_IPAD?76:50;
    }else{
        return IS_IPAD?(276+62)*2+200:(kPhotoHeight+40)*2+150;
    }
}


#pragma mark -- delegate
#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (1 == range.length) {//按下回格键
        return YES;
    }
    
    if (textField.tag==0) {
        if ([textField.text length]<8) {
            return YES;
        }
    }
    
    if (textField.tag==1) {
        if ([textField.text length]<18) {
            return YES;
        }
    }
    
    return NO;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (textField.tag==0) {
        nameStr = textField.text;
    }else{
        numberStr = textField.text;
    }
    return YES;
}

#pragma mark UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [self.imgPicker dismissViewControllerAnimated:YES completion:nil];
    UIImage* curImage=[info objectForKey:UIImagePickerControllerOriginalImage];
    if(selectedIndex==0){
        frontImage = curImage;
    }else{
        obverseImage = curImage;
    }
    MyLog(@"image-- h:%.1f,w:%.1f",curImage.size.height,curImage.size.width);
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    [self.verifiedTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}


#pragma mark -- Event Response
#pragma mark 保存
-(void)rightNavigationItemAction{
    [self.view endEditing:YES];
    
    if (kIsEmptyString(nameStr)) {
        [self.view makeToast:@"请输入姓名" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    if (kIsEmptyString(numberStr)) {
        [self.view makeToast:@"请输入身份证号" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    if(![numberStr isIdentifyCard]){
        [self.view makeToast:@"您输入的身份证号码有误" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    if(!frontImage){
        [self.view makeToast:@"请上传身份证正面图片" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    if(!obverseImage){
        [self.view makeToast:@"请上传身份证反面图片" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    
    MyLog(@"保存");
   
//    //上传图片
    NSMutableArray *imgsArr = [[NSMutableArray alloc] init];
    [imgsArr addObject:frontImage];
    [imgsArr addObject:obverseImage];
    NSMutableArray *encodeImageArr = [[ZYHelper sharedZYHelper] imageDataProcessingWithImgArray:imgsArr];
    NSString *encodeResult = [TCHttpRequest getValueWithParams:encodeImageArr];
    kSelfWeak;
    NSString *body = [NSString stringWithFormat:@"pic=%@&dir=2",encodeResult];
    [TCHttpRequest postMethodWithURL:kUploadPicAPI body:body success:^(id json) {
        NSArray *imgUrls = [json objectForKey:@"data"];
        NSString *body = [NSString stringWithFormat:@"token=%@&realname=%@&ID_card_No=%@&font=%@&back=%@",kUserTokenValue,nameStr,numberStr,imgUrls[0],imgUrls[1]];
        [TCHttpRequest postMethodWithURL:kCertifyIdentityAPI body:body success:^(id json) {
            [ZYHelper sharedZYHelper].isUpdateUserInfo = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.view makeToast:@"您的实名认证信息已提交，请等待审核" duration:1.0 position:CSToastPositionCenter];
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
        }];
    }];
    
}

#pragma mark 上传身份证正反面
-(void)addVerifiedPhotoAction:(UIButton *)sender{
    [self.view endEditing:YES];
    selectedIndex = sender.tag;
    [self addPhotoForView:sender];
}

#pragma mark -- getters
-(UITableView *)verifiedTableView{
    if (!_verifiedTableView) {
        _verifiedTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavHeight+5, kScreenWidth, kScreenHeight-kNavHeight-5) style:UITableViewStylePlain];
        _verifiedTableView.dataSource = self;
        _verifiedTableView.delegate = self;
        _verifiedTableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _verifiedTableView.showsVerticalScrollIndicator = NO;
        _verifiedTableView.estimatedSectionFooterHeight = 0.0;
        _verifiedTableView.estimatedSectionHeaderHeight = 0.0;
    }
    return _verifiedTableView;
}


@end
