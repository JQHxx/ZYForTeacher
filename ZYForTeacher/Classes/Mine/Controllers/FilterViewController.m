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


@interface FilterViewController (){
    NSArray   *typesArray;
    CGFloat   myHeight;
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
        myHeight = IS_IPAD?287:200;
        self.contentSizeInPopup = CGSizeMake(kScreenWidth, myHeight);
        self.landscapeContentSizeInPopup = CGSizeMake(kScreenHeight, myHeight);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isHiddenNavBar = YES;
    
    typesArray = @[@"全部",@"作业检查",@"作业辅导",@"提现"];
    
    [self initFilterView];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"交易类型"];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"交易类型"];
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
    
    CGRect lineFrame = IS_IPAD?CGRectMake(0, 69, kScreenWidth, 0.5):CGRectMake(0, 45, kScreenWidth, 0.5);
    UILabel *line = [[UILabel alloc] initWithFrame:lineFrame];
    line.backgroundColor = [UIColor colorWithHexString:@"#D8D8D8"];
    [self.view addSubview:line];
    
    [self.view addSubview:self.typeLabelsView];
    [self.view addSubview:self.confirmButton];
}


#pragma mark -- getters and setters
#pragma mark 标题
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        CGRect titleFrame = IS_IPAD?CGRectMake(120, 17, kScreenWidth-240, 36):CGRectMake(80, 12, kScreenWidth-160, 22);
        CGFloat fontSize = IS_IPAD?25:16;
        _titleLabel = [[UILabel alloc] initWithFrame:titleFrame];
        _titleLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:fontSize];
        _titleLabel.text = @"交易类型";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

#pragma mark 关闭
-(UIButton *)cancelButton{
    if(!_cancelButton){
        CGRect titleFrame = IS_IPAD?CGRectMake(20, 17,60, 36):CGRectMake(16, 12, 32,22);
        CGFloat fontSize = IS_IPAD?25:16;
        _cancelButton = [[UIButton alloc] initWithFrame:titleFrame];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor colorWithHexString:@"#4A4A4A"] forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:fontSize];
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
            weakLabelsView.frame = CGRectMake(0, weakSelf.titleLabel.bottom+43, kScreenWidth, height);
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
        CGRect btnFrame = IS_IPAD?CGRectMake((kScreenWidth-515)/2.0,myHeight-95,515, 75):CGRectMake(48,myHeight-80,kScreenWidth-96, 60);
        _confirmButton = [[UIButton alloc] initWithFrame:btnFrame];
        [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmButton setBackgroundImage:IS_IPAD?[UIImage imageNamed:@"login_bg_btn_ipad"]:[UIImage imageNamed:@"login_bg_btn"] forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(confirmSelectedTransactionTypeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

@end
