//
//  Interface.h
//  ZYForTeacher
//
//  Created by vision on 2018/8/27.
//  Copyright © 2018年 vision. All rights reserved.
//

#ifndef Interface_h
#define Interface_h
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      

#endif /* Interface_h */

#define isTrueEnvironment 0

#if isTrueEnvironment
//正式环境
#define kHostURL @"https://www.zuoye101.com"
#define kHostTempURL @"https://www.zuoye101.com%@"

#define kNIMApnsCername     @"zuoye101ForTeacherAPS"

#else
//测试环境
#define kHostURL @"https://test.zuoye101.com"
#define kHostTempURL @"https://test.zuoye101.com%@"

#define kNIMApnsCername     @"zuoye101ForTeacher"

#endif

//用户协议
#define kUserAgreementURL   @"http://zy.zuoye101.com/agreement.html"
#define kCommonProblemURL   @"https://www.zuoye101.com/h5/questions.html"

#define kUploadDeviceInfoAPI   @"/teacher/device"            //上传设备信息
#define kGetGradeAPI           @"/student/job/grade"         //获取年级
#define kGetSubjectAPI         @"/student/job/subject"       //获取科目
#define kUploadPicAPI          @"/teacher/upload"            //上传头像
#define kDataStatisticsAPI     @"/teacher/logs/count"        //数据统计
#define kSearchCollegeAPI      @"/teacher/college/search"    //搜索高校

/**作业管理**/
#define kSetOnlineAPI         @"/teacher/work/online"       //开启在线或关闭在线
#define kHomeAPI              @"/teacher"                   //首页作业检查或作业辅导
#define kHomeworkDetailsAPI   @"/teacher/work/find"         //查看作业详情
#define kJobCheckAPI          @"/teacher/work/check"        //去检查
#define kJobAcceptAPI         @"/teacher/work/accept"       //作业辅导接单
#define kJobTutoringAPI       @"/teacher/work/guide"        //去辅导
#define kFinishCheckAPI       @"/teacher/work/checked"      //结束检查
#define kCheckOverAPI         @"/teacher/work/checkover"    //作业检查结束（自动扣费）
#define kFinishTutoringAPI    @"/teacher/work/guided"       //结束辅导
#define kCancelReasonAPI      @"/teacher/reason"            //获取取消原因
#define kJobCancelAPI         @"/teacher/work/cancel"       //取消辅导
#define kConnectAPI           @"/teacher/online/connect"       //老师主动连线


/**老师管理***/
#define kGetCodeSign           @"/admin/code/get"            //发送手机验证码
#define kRegisterAPI           @"/teacher/user/register"     //注册
#define kLoginAPI              @"/teacher/user/login"        //登录
#define kCheckCodeAPI          @"/admin/code/check"          //验证验证码
#define kSetPwdAPI             @"/teacher/user/setpwd"       //修改密码
#define kSetUserInfoAPI        @"/teacher/user/setinfo"      //设置用户信息
#define kGetUserInfoAPI        @"/teacher/user/userinfo"      //个人信息
#define kCertifyIdentityAPI    @"/teacher/user/identity"      //实名认证
#define kCertifyEducationAPI   @"/teacher/user/education"      //学历认证
#define kCertifyTeacherAPI     @"/teacher/user/teacher"        //教师资质
#define kCertifySkillAPI       @"/teacher/user/skill"          //专业认证
#define kSearchCollegeAPI      @"/teacher/college/search"      //搜索高校
#define kCollegeInfoAPI        @"/teacher/college"             //高校

#define kConncetFromStuAPI     @"/teacher/online/fromstudent"  //学生连线老师

/**订单管理**/
#define kMyOrderAPI            @"/teacher/order"               //我的订单
#define kOrderDetailsAPI       @"/teacher/order/detail"        //订单详情
#define kOrderCancelAPI        @"/teacher/order/cancel"        //取消订单

/**消息管理**/
#define kMessageUnreadAPI      @"/teacher/message/unread"         //未读消息
#define kMessageLastAPI        @"/teacher/message/lastMessage"    //最新消息
#define kMessageListAPI        @"/teacher/message"                //消息列表
#define kMessageReadAPI        @"/teacher/message/read"           //设为已读


/**账户管理**/
#define kWalletMineAPI          @"/teacher/wallet/mine"           //我的钱包
#define kWalletDetailsAPI       @"/teacher/wallet/detail"         //明细
#define kWalletBillDetailsAPI   @"/teacher/wallet/billDetail"     //明细详情
#define kWalletExtractAPI       @"/teacher/wallet/doextract"      //提现
#define kBankInfoAPI            @"/teacher/wallet/bankinfo"        //银行卡
#define kAddBankCardAPI         @"/teacher/wallet/bankcard"        //绑定银行卡
#define kMyBankCardAPI          @"/teacher/wallet/myback"          //我的银行卡
#define kSearchBankAPI          @"/teacher/bank/search"            //根据卡号查找银行
#define kWalletExtractPageAPI   @"/teacher/wallet/extract"         //提现页面



#define kFeedbackAPI           @"/teacher/setting/feedback"     //意见反馈




