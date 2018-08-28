//
//  CancelViewController.m
//  ZuoYe
//
//  Created by vision on 2018/8/14.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "CancelViewController.h"

@interface CancelViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray *reasonsArr;
}

@property (nonatomic ,strong ) UITableView  *reasonTableView;
@property (nonatomic, strong) UIButton  *confirmBtn;

@property (nonatomic, assign) NSIndexPath *selIndexPath;   //单选，当前选中的行



@end

@implementation CancelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseTitle = @"取消辅导";
    
    reasonsArr = @[@"我选错科目了",@"老师解答不了我的问题",@"老师不在线",@"我临时有事，不能辅导了",@"我下错单了，想重新下单"];
    
    [self.view addSubview:self.reasonTableView];
    [self.view addSubview:self.confirmBtn];
}

#pragma mark -- UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return reasonsArr.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"请说明您的取消辅导的原因";
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = reasonsArr[indexPath.row];
    
    if(self.selIndexPath == indexPath){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //取消选择之前选中的
    UITableViewCell *celled = [tableView cellForRowAtIndexPath:self.selIndexPath];
    celled.accessoryType = UITableViewCellAccessoryNone;
    
    //记录当前选择的位置索引
    self.selIndexPath = indexPath;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
}

#pragma mark -- event response
#pragma mark 确定
-(void)confirmSelectedReasonAction{
    
}

#pragma mark -- Getters
-(UITableView *)reasonTableView{
    if (!_reasonTableView) {
        _reasonTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight-kNavHeight) style:UITableViewStylePlain];
        _reasonTableView.dataSource = self;
        _reasonTableView.delegate = self;
        _reasonTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _reasonTableView.tableFooterView = [[UIView alloc] init];
        _reasonTableView.backgroundColor = [UIColor bgColor_Gray];
    }
    return _reasonTableView;
}

#pragma mark 确定
-(UIButton *)confirmBtn{
    if (!_confirmBtn) {
        _confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, kScreenHeight-100, kScreenWidth-60, 45)];
        [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _confirmBtn.backgroundColor = [UIColor redColor];
        _confirmBtn.layer.cornerRadius=5;
        [_confirmBtn addTarget:self action:@selector(confirmSelectedReasonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}


@end
