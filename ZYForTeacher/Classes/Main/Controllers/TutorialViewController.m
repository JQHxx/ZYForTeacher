//
//  TutorialViewController.m
//  ZYForTeacher
//
//  Created by vision on 2018/9/1.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "TutorialViewController.h"
#import "PhotosView.h"

@interface TutorialViewController (){
    
    UILabel   *countTimeLabel;
}

@property (nonatomic, strong) PhotosView     *photosView;
@property (nonatomic, strong) UIScrollView   *whiteboardView;
@property (nonatomic ,strong) UIView         *toolBar;

//开始辅导
@property (nonatomic, strong) UILabel        *tipsLabel;
@property (nonatomic, strong) UIButton       *startButton;

@end

@implementation TutorialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.view insertSubview:self.photosView atIndex:0];
    [self.view addSubview:self.whiteboardView];
    [self.view addSubview:self.tipsLabel];
    [self.view addSubview:self.startButton];
    [self.view addSubview:self.toolBar];
 
    [self loadData];
}

#pragma mark -- Event Response
#pragma mark 开始辅导
-(void)startTutorialAction:(UIButton *)sender{
    if ([sender.currentTitle isEqualToString:@"开始审题"]) {
        [self.startButton setTitle:@"开始辅导" forState:UIControlStateNormal];
        self.tipsLabel.text = @"审题中";
    }else{
        [self.tipsLabel removeFromSuperview];
        [self.startButton removeFromSuperview];
        self.tipsLabel = nil;
        self.startButton = nil;
    }
}

#pragma mark 设置画笔
-(void)setBrushAction:(UIButton *)sender{
    
}

-(void)setPageAction:(UIButton *)sender{
    
}

#pragma mark -- Private Methods
-(void)loadData{
    NSArray *tempArr = @[@"1.jpg",@"2.jpg",@"3.jpg",@"4.jpg",@"5.jpg"];
    self.photosView.photosArray = [NSMutableArray arrayWithArray:tempArr];
}

#pragma mark -- Getters
#pragma mark 图片
-(PhotosView *)photosView{
    if (!_photosView) {
        _photosView = [[PhotosView alloc] initWithFrame:CGRectMake(0, KStatusHeight+10, kScreenWidth,300)];
    }
    return _photosView;
}

#pragma mark 白板
-(UIScrollView *)whiteboardView{
    if (!_whiteboardView) {
        _whiteboardView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.photosView.bottom, kScreenWidth, kScreenHeight-self.photosView.bottom)];
        _whiteboardView.backgroundColor = [UIColor whiteColor];
    }
    return _whiteboardView;
}

#pragma mark 提示
-(UILabel *)tipsLabel{
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, self.photosView.bottom+10, kScreenWidth-40, 30)];
        _tipsLabel.text = @"语音通话中";
        _tipsLabel.textColor = [UIColor blackColor];
        _tipsLabel.font = kFontWithSize(14);
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tipsLabel;
}

#pragma mark 开始辅导
-(UIButton *)startButton{
    if (!_startButton) {
        _startButton = [[UIButton alloc] initWithFrame:CGRectMake((kScreenWidth-100)/2, kScreenHeight-100, 100, 30)];
        [_startButton setTitle:@"开始审题" forState:UIControlStateNormal];
        [_startButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _startButton.layer.cornerRadius=3;
        _startButton.layer.borderColor = [UIColor blackColor].CGColor;
        _startButton.layer.borderWidth = 1.0;
        [_startButton addTarget:self action:@selector(startTutorialAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startButton;
}

#pragma mark 工具栏
-(UIView *)toolBar{
    if (!_toolBar) {
        _toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-50, kScreenWidth, 50)];
        _toolBar.backgroundColor = [UIColor clearColor];
        
        NSArray *btnImages = @[@"color",@"thick"];
        for (NSInteger i=0; i<btnImages.count; i++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20+i*(30+15), 10, 30, 30)];
            [btn setImage:[UIImage imageNamed:btnImages[i]] forState:UIControlStateNormal];
            btn.tag = i;
            [btn addTarget:self action:@selector(setBrushAction:) forControlEvents:UIControlEventTouchUpInside];
            [_toolBar addSubview:btn];
        }
        
        countTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth/2.0-40), 10, 80, 30)];
        countTimeLabel.text = @"00:00:00";
        countTimeLabel.textColor = [UIColor lightGrayColor];
        countTimeLabel.font = kFontWithSize(14);
        countTimeLabel.textAlignment = NSTextAlignmentCenter;
        [_toolBar addSubview:countTimeLabel];
        
        NSArray *images = @[@"delete",@"forward",@"return"];
        for (NSInteger i=0; i<images.count; i++) {
            UIButton *pageBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth/2.0+50+45*i, 10, 30, 30)];
            [pageBtn setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
            pageBtn.tag = i;
            [pageBtn addTarget:self action:@selector(setPageAction:) forControlEvents:UIControlEventTouchUpInside];
            [_toolBar addSubview:pageBtn];
        }
    }
    return _toolBar;
}


@end
