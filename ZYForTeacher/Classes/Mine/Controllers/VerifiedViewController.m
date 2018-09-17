//
//  VerifiedViewController.m
//  ZYForTeacher
//
//  Created by vision on 2018/9/4.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "VerifiedViewController.h"
#import "InputNameViewController.h"
#import "VerifiedTableViewCell.h"

@interface VerifiedViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSString       *nameStr;
    NSString       *numberStr;
    
    NSInteger     selectedIndex;
    UIImage       *frontImage;
    UIImage       *obverseImage;
}

@property (nonatomic ,strong) UITableView *verifiedTableView;

@end

@implementation VerifiedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"实名认证";
    
    self.rigthTitleName = @"保存";
    
    [self.view addSubview:self.verifiedTableView];
    
}

#pragma mark -- UITableViewDataSource and UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return section==0?@"身份信息":@"上传身份证照片";
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = indexPath.row==0?@"真实姓名":@"身份证号";
        cell.textLabel.font =kFontWithSize(14);
        cell.detailTextLabel.text = indexPath.row==0?nameStr:numberStr;
        return cell;
    }else{
        VerifiedTableViewCell *cell = [[VerifiedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.separatorInset = UIEdgeInsetsMake(0, kScreenWidth, 0, 0);
        cell.titleStr = indexPath.row == 0?@"正面":@"反面";
        cell.addImage = indexPath.row == 0?frontImage:obverseImage;
        
        cell.exampleBtn.tag = cell.addPhotoBtn.tag = indexPath.row;
        [cell.exampleBtn addTarget:self action:@selector(showPhotoExampleAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.addPhotoBtn addTarget:self action:@selector(addVerifiedPhotoAction:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        InputNameViewController *inputVC = [[InputNameViewController alloc] init];
        inputVC.type = indexPath.row==0?CertificationTypeActualName:CertificationTypeIdentificationNumber;
        inputVC.myText = indexPath.row==0?nameStr:numberStr;
        kSelfWeak;
        inputVC.backBlock = ^(id object) {
            if (indexPath.row==0) {
                nameStr = object;
            }else{
                numberStr = object;
            }
            [weakSelf.verifiedTableView reloadData];
        };
        [self presentViewController:inputVC animated:YES completion:nil];
    }else{
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.section==0?44:50+(kScreenWidth-80)*(55.0/90.0)+10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.5;
}

#pragma mark UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [self.imgPicker dismissViewControllerAnimated:YES completion:nil];
    UIImage* curImage=[info objectForKey:UIImagePickerControllerEditedImage];
    curImage=[curImage cropImageWithSize:CGSizeMake(kScreenWidth-80, (kScreenWidth-80)*(55.0/90.0))];
    if(selectedIndex==0){
        frontImage = curImage;
    }else{
        obverseImage = curImage;
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:1];
    [self.verifiedTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    NSData *imageData = UIImagePNGRepresentation(curImage);
    //将图片数据转化为64为加密字符串
    NSString *encodeResult = [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    NSString *body=[NSString stringWithFormat:@"photo=%@",encodeResult];
    MyLog(@"body：%@",body);
}


#pragma mark -- Event Response
#pragma mark 保存
-(void)rightNavigationItemAction{
    
}

#pragma mark 显示图片示例
-(void)showPhotoExampleAction:(UIButton *)sender{
    
}

#pragma mark 上传身份证正反面
-(void)addVerifiedPhotoAction:(UIButton *)sender{
    selectedIndex = sender.tag;
    
    [self addPhoto];
}

#pragma mark -- getters
-(UITableView *)verifiedTableView{
    if (!_verifiedTableView) {
        _verifiedTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight) style:UITableViewStyleGrouped];
        _verifiedTableView.dataSource = self;
        _verifiedTableView.delegate = self;
        _verifiedTableView.showsVerticalScrollIndicator = NO;
        _verifiedTableView.estimatedSectionFooterHeight = 0.0;
        _verifiedTableView.estimatedSectionHeaderHeight = 0.0;
    }
    return _verifiedTableView;
}


@end
