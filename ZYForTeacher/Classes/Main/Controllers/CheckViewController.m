//
//  CheckViewController.m
//  ZYForTeacher
//
//  Created by vision on 2018/9/1.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "CheckViewController.h"

@interface CheckViewController ()

@property (nonatomic ,strong) UIScrollView *photoScrollView;
@property (nonatomic ,strong) UIView       *toolBar;

@end

@implementation CheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view insertSubview:self.photoScrollView atIndex:0];
    [self.view addSubview:self.toolBar];
}

#pragma mark -- Event response
#pragma mark 设置画笔颜色、粗细，清空画笔
-(void)setBrushAction:(UIButton *)sender{
    
}

#pragma mark  结束
-(void)endCheckAction{
    
}

#pragma mark 上一页、下一页
-(void)setPageAction:(UIButton *)sender{
    
}

#pragma mark -- Getters
#pragma mark 作业图片
-(UIScrollView *)photoScrollView{
    if (!_photoScrollView) {
        _photoScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-50)];
        NSArray *images = @[@"1.jpg",@"2.jpg",@"3.jpg",@"4.jpg",@"5.jpg"];
        for (NSInteger i=0; i<images.count; i++) {
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(i*kScreenWidth, 0, kScreenWidth,  kScreenHeight-50)];
            imgView.image = [UIImage imageNamed:images[i]];
            [_photoScrollView addSubview:imgView];
        }
        _photoScrollView.contentSize = CGSizeMake(kScreenWidth*images.count,  kScreenHeight-50);
        _photoScrollView.showsHorizontalScrollIndicator = NO;
        _photoScrollView.bounces = NO;
        _photoScrollView.pagingEnabled = YES;
    }
    return _photoScrollView;
}

#pragma mark 工具栏
-(UIView *)toolBar{
    if (!_toolBar) {
        _toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-50, kScreenWidth, 50)];
        _toolBar.backgroundColor = [UIColor whiteColor];
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
        line.backgroundColor = kLineColor;
        [_toolBar addSubview:line];
        
        CGFloat kCapWidth = (kScreenWidth/2.0-90-15)/4.0;
        NSArray *btnImages = @[@"color",@"thick",@"return",@"delete"];
        for (NSInteger i=0; i<btnImages.count; i++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(kCapWidth+i*(30+kCapWidth), 10, 30, 30)];
            [btn setImage:[UIImage imageNamed:btnImages[i]] forState:UIControlStateNormal];
            btn.tag = i;
            [btn addTarget:self action:@selector(setBrushAction:) forControlEvents:UIControlEventTouchUpInside];
            [_toolBar addSubview:btn];
        }
        
        UIButton *endBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth/2.0-15,-10, 60, 60)];
        [endBtn setTitle:@"结束" forState:UIControlStateNormal];
        [endBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        endBtn.backgroundColor = [UIColor whiteColor];
        endBtn.layer.cornerRadius =30.0;
        endBtn.layer.borderColor = [UIColor blackColor].CGColor;
        endBtn.layer.borderWidth = 1.0;
        endBtn.clipsToBounds = YES;
        [endBtn addTarget:self action:@selector(endCheckAction) forControlEvents:UIControlEventTouchUpInside];
        [_toolBar addSubview:endBtn];
        
        CGFloat pageWidth = (kScreenWidth/2.0-50)/2;
        NSArray *btnTitles = @[@"上一页",@"下一页"];
        for (NSInteger i=0; i<2; i++) {
            UIButton *pageBtn = [[UIButton alloc] initWithFrame:CGRectMake(endBtn.right+5+pageWidth*i, 10, pageWidth, 30)];
            [pageBtn setTitle:btnTitles[i] forState:UIControlStateNormal];
            [pageBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            pageBtn.tag = i;
            [pageBtn addTarget:self action:@selector(setPageAction:) forControlEvents:UIControlEventTouchUpInside];
            [_toolBar addSubview:pageBtn];
        }
    }
    return _toolBar;
}

@end
