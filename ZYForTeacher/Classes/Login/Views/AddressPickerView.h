//
//  AddressPickerView.h
//  ZYForTeacher
//
//  Created by vision on 2018/11/30.
//  Copyright © 2018 vision. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef void (^DidSelectedAddressCallBack) (NSString *province ,NSString *city ,NSString *town);

@interface AddressPickerView : UIView

@property (nonatomic , copy ) DidSelectedAddressCallBack getAddressCallBack;

@property (nonatomic, strong) NSArray    *provinces;
@property (nonatomic, strong) NSArray    *cities;
@property (nonatomic, strong) NSArray    *areas;

@property (nonatomic, strong) NSString *province;           /** 省 */
@property (nonatomic, strong) NSString *city;               /** 市 */
@property (nonatomic, strong) NSString *district;           /** 区 */

@property (nonatomic, strong) UIPickerView *myPickerView;

@end

NS_ASSUME_NONNULL_END
