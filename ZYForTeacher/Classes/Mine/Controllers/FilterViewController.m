//
//  FilterViewController.m
//  ZYForTeacher
//
//  Created by vision on 2018/9/5.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "FilterViewController.h"
#import "UIViewController+STPopup.h"
#import "STPopupController.h"

#import "LabelsView.h"

#define kMyHeight 200

@interface FilterViewController (){
    NSArray   *typesArray;
}

@property (nonatomic, strong) UILabel      *titleLabel;              //标题
@property (nonatomic, strong) UIButton     *cancelButton;             //取消按钮
@property (nonatomic, strong) LabelsView   *typeLabelsView;          //交易类型
@property (nonatomic, strong) UIButton     *confirmButton;            //确定

@end

@implementation FilterViewController

-(instancetype)init{
    self = [super init];
    if (self) {
        self.contentSizeInPopup = CGSizeMake(kScreenWidth, kMyHeight);
        self.landscapeContentSizeInPopup = CGSizeMake(kScreenHeight, kMyHeight);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isHiddenNavBar = YES;
    
    typesArray = @[@"全部",@"作业检查",@"作业辅导",@"提现"];
    
    [self initFilterView];
    
}

#pragma mark -- Event Response
#pragma mark 关闭
-(void)closeTansactionViewAction:(UIButton *)sender{
    if (self.popupController) {
        [self.popupController dismissWithCompletion:nil];
    }
}

#pragma mark 确定选择交易类型
-(void)confirmSelectedTransactionTypeAction:(UIButton *)sender{
    MyLog(@"type：%ld",self.transactionType);
    if (self.popupController) {
        [self.popupController dismissWithCompletion:^{
            self.backBlock([NSNumber numberWithInteger:self.transactionType]);
        }];
    }
}

#pragma mark -- Private Methods
#pragma mark 初始化
-(void)initFilterView{
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.cancelButton];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 45, kScreenWidth, 0.5)];
    line.backgroundColor = [UIColor colorWithHexString:@"#D8D8D8"];
    [self.view addSubview:line];
    
    [self.view addSubview:self.typeLabelsView];
    [self.view addSubview:self.confirmButton];
}


#pragma mark -- getters and setters
#pragma mark 标题
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 12, kScreenWidth-160, 22)];
        _titleLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:16];
        _titleLabel.text = @"交易类型";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

#pragma mark 关闭
-(UIButton *)cancelButton{
    if(!_cancelButton){
        _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(16, 12, 32,22)];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor colorWithHexString:@"#4A4A4A"] forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:16];
        [_cancelButton addTarget:self action:@selector(closeTansactionViewAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

#pragma mark 交易类型
-(LabelsView *)typeLabelsView{
    if (!_typeLabelsView) {
        _typeLabelsView = [[LabelsView alloc] initWithFrame:CGRectZero];
        _typeLabelsView.selectedIndex = self.transactionType==4?0:self.transactionType;
        _typeLabelsView.labelsArray = [NSMutableArray arrayWithArray:typesArray];
        
        kSelfWeak;
        __weak typeof(_typeLabelsView) weakLabelsView = _typeLabelsView;
        _typeLabelsView.viewHeightRecalc = ^(CGFloat height) {
            weakLabelsView.frame = CGRectMake(0, weakSelf.titleLabel.bottom+33, kScreenWidth, height);
        };
        _typeLabelsView.didClickItem = ^(NSInteger itemIndex) {
            weakSelf.transactionType = itemIndex==0?4:itemIndex;
        };
    }
    return _typeLabelsView;
}

#pragma mark 确定
-(UIButton *)confirmButton{
    if (!_confirmButton) {
        _confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(43, kMyHeight-(kScreenWidth-95)*(128.0/588.0)-20, kScreenWidth-95,(kScreenWidth-95)*(128.0/588.0))];
        [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmButton setBackgroundImage:[UIImage imageNamed:@"login_bg_btn"] forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(confirmSelectedTransactionTypeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

@end
