//
//  SearchSchoolViewController.m
//  ZYForTeacher
//
//  Created by vision on 2018/9/4.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "SearchSchoolViewController.h"
#import "SearchResultViewController.h"

@interface SearchSchoolViewController ()<UISearchBarDelegate,SearchResultViewControllerDelegate>

@property (nonatomic,strong) UISearchBar   *mySearchBar;         //搜索框
@property (nonatomic,strong) SearchResultViewController  *searchResultVC;

@end

@implementation SearchSchoolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isHiddenNavBar = YES;
    
    [self.view addSubview:self.mySearchBar];
    [self.mySearchBar becomeFirstResponder];
}

#pragma mark -- Custom Delegate
#pragma mark SearchResultViewControllerDelegate
-(void)searchResultViewControllerDidSelelctSchoolText:(NSString *)schoolText{
    [self.navigationController popViewControllerAnimated:YES];
    self.backBlock(schoolText);
}

#pragma mark -- UISearchBarDelegate
#pragma mark 搜索框编辑开始
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [self.mySearchBar setShowsCancelButton:YES animated:YES];
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{  if ([searchBar isFirstResponder]) {
    if ([[[searchBar textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[searchBar textInputMode] primaryLanguage]) {
        return NO;
    }
    
    //判断键盘是不是九宫格键盘
    if ([[ZYHelper sharedZYHelper] isNineKeyBoard:text] ){
        return YES;
    }else{
        if ([[ZYHelper sharedZYHelper] hasEmoji:text] || [[ZYHelper sharedZYHelper] strIsContainEmojiWithStr:text]){
            return NO;
        }
    }
}
    return YES;
    
}
#pragma mark 搜索框文字变化时
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSString *str = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (!kIsEmptyString(str)) {
        BOOL isSearchBool = [[ZYHelper sharedZYHelper] strIsContainEmojiWithStr:searchText];
        if (isSearchBool) {
            [self.view makeToast:@"不能搜索特殊符号" duration:1.0 position:CSToastPositionCenter];
        } else {
            [self.view addSubview:self.searchResultVC.view];
            self.searchResultVC.searchText = searchText;
        }
    }else{
        [self.searchResultVC.view removeFromSuperview];
        self.searchResultVC = nil;
    }
}

#pragma mark 搜索确定
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    BOOL isSearchBool = [[ZYHelper sharedZYHelper] strIsContainEmojiWithStr:searchBar.text];
    if (isSearchBool) {
        [self.view makeToast:@"不能搜索特殊符号" duration:1.0 position:CSToastPositionCenter];
        [self.mySearchBar resignFirstResponder];
    } else {
        [self.mySearchBar resignFirstResponder];
        
        NSString *searchText=[searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        searchBar.text=searchText;
        if (kIsEmptyString(searchText)) {
            searchBar.text=@"";
        }else{
            [self.view addSubview:self.searchResultVC.view];
            self.searchResultVC.searchText = searchText;
        }
    }
}

#pragma mark 点击取消按钮
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- Getters and Setters
#pragma mark 搜索框
-(UISearchBar *)mySearchBar{
    if (_mySearchBar==nil) {
        _mySearchBar=[[UISearchBar alloc] initWithFrame:CGRectMake(0, KStatusHeight, kScreenWidth, kNavHeight)];
        _mySearchBar.delegate=self;
        _mySearchBar.placeholder=@"请输入学校名称";
        [_mySearchBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(kScreenWidth, kNavHeight)]];
        
        //取出textfield
        UITextField *searchField=[_mySearchBar valueForKey:@"_searchField"];
        searchField.backgroundColor  = [UIColor colorWithHexString:@"#F1F1F2"];
        searchField.layer.cornerRadius = 4.0;
        
        UIButton *cancleBtn = [_mySearchBar valueForKey:@"_cancelButton"];
        [cancleBtn setTitleColor:[UIColor colorWithHexString:@"#4A4A4A"] forState:UIControlStateNormal];
        
    }
    return _mySearchBar;
}

#pragma mark  搜索结果
- (SearchResultViewController *)searchResultVC{
    if (!_searchResultVC) {
        _searchResultVC = [[SearchResultViewController alloc] init];
        _searchResultVC.view.frame = CGRectMake(0, self.mySearchBar.bottom, kScreenWidth, kScreenHeight-self.mySearchBar.bottom);
        _searchResultVC.myDelegate = self;
    }
    return _searchResultVC;
}


@end
