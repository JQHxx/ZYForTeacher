//
//  AddressPickerView.m
//  ZYForTeacher
//
//  Created by vision on 2018/11/30.
//  Copyright © 2018 vision. All rights reserved.
//

#import "AddressPickerView.h"

static CGFloat bgViewHeith = 260;
static CGFloat pickViewHeigh = 200;
static CGFloat toolsViewHeith = 50;

@interface AddressPickerView()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, strong) UIView *bgView;              /** 背景view */
@property (nonatomic, strong) UIView *toolsView;           /** 自定义标签栏 */
@property (nonatomic ,strong) UILabel *titleLab;           /** 标题  **/
@property (nonatomic, strong) UIButton *sureButton;        /** 确认按钮 */
@property (nonatomic, strong) UIButton *cancelButton;      /** 取消按钮 */


@end

@implementation AddressPickerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initAddressPickerView];
        
        self.provinces = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"addresses.plist" ofType:nil]];
        self.cities = [[self.provinces objectAtIndex:0] objectForKey:@"cities"];
        self.areas = [[self.cities objectAtIndex:0] objectForKey:@"areas"];
        
        self.province = [self.provinces[0] objectForKey:@"state"];
        self.city = [self.cities[0] objectForKey:@"city"];
        self.district = self.areas[0];
    }
    return self;
}

#pragma mark -- UIPickerViewDataSource and UIPickerViewDelegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    switch (component) {
        case 0:
            return [self.provinces count];
            break;
        case 1:
            return [self.cities count];
            break;
        case 2:
            return [self.areas count];
            break;
        default:
            return 0;
            break;
    }
    
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width/3.0, 30)];
    label.adjustsFontSizeToFitWidth = YES;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont pingFangSCWithWeight:FontWeightStyleRegular size:14];
    if (component == 0) {
        label.text = [[self.provinces objectAtIndex:row] objectForKey:@"state"];
    }else if (component == 1){
        label.text =  [[self.cities objectAtIndex:row] objectForKey:@"city"];
    }else if (component == 2){
        label.text =  [self.areas objectAtIndex:row];
    }
    return label;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    switch (component) {
        case 0:
            self.cities = [[self.provinces objectAtIndex:row] objectForKey:@"cities"];
            [self.myPickerView selectRow:0 inComponent:1 animated:YES];
            [self.myPickerView reloadComponent:1];
            
            if (self.cities.count == 0) {
                self.city = @"";
            }else{
                self.areas = [[self.cities objectAtIndex:0] objectForKey:@"areas"];
                [self.myPickerView selectRow:0 inComponent:2 animated:YES];
                [self.myPickerView reloadComponent:2];
                self.city = [[self.cities objectAtIndex:0] objectForKey:@"city"];
            }
            
            self.province = [[self.provinces objectAtIndex:row] objectForKey:@"state"];
            
            if ([self.areas count] > 0) {
                self.district = [self.areas objectAtIndex:0];
            } else{
                self.district = @"";
            }
            break;
        case 1:
            self.areas = [[self.cities objectAtIndex:row] objectForKey:@"areas"];
            [self.myPickerView selectRow:0 inComponent:2 animated:YES];
            [self.myPickerView reloadComponent:2];
            
            self.city = [[self.cities objectAtIndex:row] objectForKey:@"city"];
            
            if ([self.areas count] > 0) {
                self.district = [self.areas objectAtIndex:0];
            } else{
                self.district = @"";
            }
            break;
        case 2:
            if ([self.areas count] > 0) {
                self.district = [self.areas objectAtIndex:row];
            } else{
                self.district = @"";
            }
            break;
        default:
            break;
    }
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40.0;
}

#pragma mark -- Event Response
#pragma mark 取消
- (void)cancelButtonClick{
    [self hidePickView];
}

#pragma mark 确定
- (void)sureButtonClick{
    [self hidePickView];
    if (self.getAddressCallBack) {
        self.getAddressCallBack(self.province,self.city,self.district);
    }
}


#pragma mark - Private methods
#pragma mark 初始化界面
-(void)initAddressPickerView{
    self.frame = [UIApplication sharedApplication].keyWindow.bounds;
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.toolsView];
    [self.toolsView addSubview:self.cancelButton];
    [self.toolsView addSubview:self.sureButton];
    [self.toolsView addSubview:self.titleLab];
    
    [self.bgView addSubview:self.myPickerView];
    
    [self showPickerView];
}


#pragma mark 显示
- (void)showPickerView{
    [UIView animateWithDuration:0.25 animations:^{
        self.bgView.frame = CGRectMake(0, kScreenHeight - bgViewHeith, kScreenWidth, bgViewHeith);
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark 隐藏
- (void)hidePickView{
    [UIView animateWithDuration:0.25 animations:^{
        self.bgView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, bgViewHeith);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - Getters
#pragma mark 背景视图
- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, bgViewHeith)];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

#pragma mark 工具栏视图
- (UIView *)toolsView{
    if (!_toolsView) {
        _toolsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,kScreenWidth, toolsViewHeith)];
        _toolsView.layer.borderWidth = 0.5;
        _toolsView.layer.borderColor = kLineColor.CGColor;
    }
    return _toolsView;
}

#pragma mark 标题
- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(50, 10, kScreenWidth - 100, 30)];
        _titleLab.textColor = [UIColor colorWithHexString:@"#4A4A4A"];
        _titleLab.font = [UIFont pingFangSCWithWeight:FontWeightStyleMedium size:16];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.text = @"所在地区";
    }
    return _titleLab;
}

#pragma mark 地址选择器
- (UIPickerView *)myPickerView{
    if (!_myPickerView) {
        _myPickerView=[[UIPickerView alloc] initWithFrame:CGRectMake(0.0,toolsViewHeith, kScreenWidth, pickViewHeigh)];
        _myPickerView.delegate=self;
        _myPickerView.dataSource=self;
        _myPickerView.backgroundColor = [UIColor whiteColor];
    }
    return _myPickerView;
}

#pragma mark 取消
- (UIButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 50, toolsViewHeith)];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor colorWithHexString:@"#828282"]  forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

#pragma mark 确定
- (UIButton *)sureButton{
    if (!_sureButton) {
        _sureButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 10 - 50, 0, 50, toolsViewHeith)];
        [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [_sureButton setTitleColor:[UIColor colorWithHexString:@"#4A4A4A"] forState:UIControlStateNormal];
        [_sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}

@end
