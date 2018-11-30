//
//  SearchResultViewController.m
//  ZYForTeacher
//
//  Created by vision on 2018/9/4.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "SearchResultViewController.h"
#import "PinYin4Objc.h"

@interface SearchResultViewController (){
    NSArray   *colleges;
}

@property(nonatomic, strong )NSMutableArray *schoolsArray;  //搜索结果

@end

@implementation SearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.schoolsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"SchoolResultCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = self.schoolsArray[indexPath.row];
    cell.textLabel.font = kFontWithSize(14);
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSString *schoolText = self.schoolsArray[indexPath.row];
    if ([self.myDelegate respondsToSelector:@selector(searchResultViewControllerDidSelelctSchoolText:) ]) {
        [self.myDelegate searchResultViewControllerDidSelelctSchoolText:schoolText];
    }
}

#pragma mark -- Getters and Setters
#pragma mark 学校
-(NSMutableArray *)schoolsArray{
    if (!_schoolsArray) {
        _schoolsArray = [[NSMutableArray alloc] init];
    }
    return _schoolsArray;
}

#pragma mark 传入搜索字符
-(void)setSearchText:(NSString *)searchText{
    _searchText = searchText;
    
    
    NSString *body = [NSString stringWithFormat:@"words=%@&token=%@",searchText,kUserTokenValue];
    [TCHttpRequest postMethodWithURL:kSearchCollegeAPI body:body success:^(id json) {
        NSArray *data = [json objectForKey:@"data"];
        NSMutableArray * tempArr = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in data) {
            [tempArr addObject:dict[@"college"]];
        }
        self.schoolsArray = tempArr;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

@end
