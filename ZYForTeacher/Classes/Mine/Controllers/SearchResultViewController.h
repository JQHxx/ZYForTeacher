//
//  SearchResultViewController.h
//  ZYForTeacher
//
//  Created by vision on 2018/9/4.
//  Copyright © 2018年 vision. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchResultViewControllerDelegate<NSObject>

-(void)searchResultViewControllerDidSelelctSchoolText:(NSString *)schoolText;

@end

@interface SearchResultViewController : UITableViewController

@property(nonatomic, weak ) id<SearchResultViewControllerDelegate>myDelegate;
@property(nonatomic, copy ) NSString* searchText;


@end
