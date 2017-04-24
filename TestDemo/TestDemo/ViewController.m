//
//  ViewController.m
//  TestDemo
//
//  Created by 栾美娜 on 2017/2/15.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "ViewController.h"
#import "GTTooltipView.h"
#import <CoreMotion/CoreMotion.h>
#import "../../RiskControlSDK/RiskControlSDK/RiskControlSDK.h"
// location
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
// 接口
#import "CommonService.h"


//
#import "sys/utsname.h"
#import <AdSupport/AdSupport.h>

#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

#import <sys/sockio.h>
#import <sys/ioctl.h>
#import <arpa/inet.h>

#define showTip(Message) [GTTooltipView createTooltipViewWithMarkedWords:Message view:self.view];NSLog(@"%@", Message);

@interface ViewController () <BMKLocationServiceDelegate>

@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UIButton *btn1;
@property (nonatomic, strong) UIButton *btn2;
@property (nonatomic, strong) UIButton *btn3;


@property (nonatomic, weak) UITextField *userTextField;
@property (nonatomic, weak) UITextField *pwdTextField;
@property (nonatomic, weak) UITextField *typeTextField;

@property (nonatomic, strong) NSMutableArray *infoArray;

@property (nonatomic, strong) BMKLocationService *locService;


@property (nonatomic, strong) RiskControlSDK *sdk_risk;

@end

#define screenW [UIScreen mainScreen].bounds.size.width

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
    [self requestToken];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
  
    [self.locService startUserLocationService];
    
    
    
}

// 获取token
- (void)requestToken {
    [CommonService requestAccesstokensuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject[@"retcode"] integerValue] == 0)
        {
            
            NSLog(@"请求token成功 %@", [responseObject objectForKey:@"data"]);
            [[NSUserDefaults standardUserDefaults] setObject:[responseObject objectForKey:@"data"] forKey:@"tmpToken"];
        }
        else
        {

            NSLog(@"请求token错误信息 %@", responseObject[@"msg"]);
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"tmpToken"];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // 存储
        
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"tmpToken"];
        NSString *errorStr = [NSString stringWithFormat:@"error: %ld",[[operation response] statusCode]];
        NSLog(@"%@", errorStr);

    }];
    
}

//
- (void)judgeLocationWithSuccess:(void(^)())success {
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status) {
        NSLog(@"定位服务当前可能尚未打开，请设置打开！");
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"定位服务未开启" message:@"请在系统设置中开启定位服务" delegate:self cancelButtonTitle:@"手动搜索地址" otherButtonTitles:nil, nil];
        [alertView show];
    } else {
        if (success) {
            success();
        }
    }
}

- (void)setupUI {
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)]];
    
    UILabel *userId = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, screenW*0.5-20, 30)];
    userId.text = @"用户名";
    [self.view addSubview:userId];
    
    UITextField *userTextField = [[UITextField alloc] initWithFrame:CGRectMake(screenW*0.5, 100, screenW*0.5-20, 30)];
    userTextField.borderStyle = UITextBorderStyleRoundedRect;
    userTextField.textAlignment = 2;
    userTextField.placeholder = @"请输入用户名";
    userTextField.text = @"18611757869";
    [self.view addSubview:userTextField];
    self.userTextField = userTextField;
    
    
    UILabel *pwdLab =[[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(userId.frame)+10, screenW*0.5-20, 30)];
    pwdLab.text = @"密码";
    [self.view addSubview:pwdLab];
    
    UITextField *pwdTextField = [[UITextField alloc] initWithFrame:CGRectMake(screenW*0.5, CGRectGetMinY(pwdLab.frame), screenW*0.5-20, 30)];
    pwdTextField.borderStyle = UITextBorderStyleRoundedRect;
    pwdTextField.textAlignment = 2;
    pwdTextField.placeholder = @"请输入密码";
    pwdTextField.text = @"aaa123";
    [self.view addSubview:pwdTextField];
    self.pwdTextField = pwdTextField;
    
    
    UILabel *typeLab = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(pwdLab.frame)+10, screenW*0.5-20, 30)];
    typeLab.text = @"producttype";
    [self.view addSubview:typeLab];
    
    UITextField *typeTextField = [[UITextField alloc] initWithFrame:CGRectMake(screenW*0.5, CGRectGetMinY(typeLab.frame), screenW*0.5-20, 30)];
    typeTextField.textAlignment = 2;
    typeTextField.borderStyle = UITextBorderStyleRoundedRect;
    typeTextField.placeholder = @"输入productType";
    typeTextField.text = @"pettyloan";
    [self.view addSubview:typeTextField];
    self.typeTextField = typeTextField;
    
    
    
    _btn = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn.frame = CGRectMake(20, CGRectGetMaxY(typeLab.frame)+60, screenW-40, 30);
    [_btn setTitle:@"绑定用户" forState:UIControlStateNormal];
    [_btn setBackgroundColor:[UIColor purpleColor]];
    [_btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    _btn.tag = 1000;
    [self.view addSubview:_btn];
    
    _btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn2.frame = CGRectMake(20, CGRectGetMaxY(_btn.frame)+30,screenW-40, 30);
    [_btn2 setTitle:@"进入SDK" forState:UIControlStateNormal];
    [_btn2 setBackgroundColor:[UIColor purpleColor]];
    _btn2.tag = 1001;
    [_btn2 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btn2];
    
    _btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn1.frame = CGRectMake(20, CGRectGetMaxY(_btn2.frame)+30,screenW-40, 30);
    [_btn1 setTitle:@"查看信息" forState:UIControlStateNormal];
    [_btn1 setBackgroundColor:[UIColor purpleColor]];
    _btn1.tag = 1002;
    [_btn1 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btn1];
    
    
    _btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn3.frame = CGRectMake(20, CGRectGetMaxY(_btn1.frame)+30,screenW-40, 30);
    [_btn3 setTitle:@"授权列表" forState:UIControlStateNormal];
    [_btn3 setBackgroundColor:[UIColor purpleColor]];
    _btn3.tag = 1003;
    [_btn3 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btn3];
    
}

- (void)btnAction:(UIButton *)sender {
    _sdk_risk = [RiskControlSDK new];
    _sdk_risk.tokenInvalid = ^{
        NSLog(@"果然失效");
    };
    
    
    if (sender.tag == 1000) { // 绑定信息
        [CommonService requestLoginOfaccess_token:[[NSUserDefaults standardUserDefaults] objectForKey:@"tmpToken"] username:self.userTextField.text password:self.pwdTextField.text lastPosition:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"绑定成功");
            showTip(@"绑定成功");
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"绑定失败");
            showTip(@"绑定失败");
        }];
    }
    else if (sender.tag == 1001) { // 进入SDK
        
        [_sdk_risk presentSDKWithToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"tmpToken"] productType:self.typeTextField.text];
        _sdk_risk.callBlock = ^(id responseObject) {
            NSLog(@"all data:%@", responseObject);
        };
    }
    else if (sender.tag == 1002) { // 查看信息
        [_sdk_risk presnetSDKViewInformationWithToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"tmpToken"] productType:self.typeTextField.text];
        
    }
    else if (sender.tag == 1003) { // 查看所有授权
        [_sdk_risk presentSDKAuthWithToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"tmpToken"] productType:self.typeTextField.text];
    }

}


- (void)tapAction {
    [self.view endEditing:true];
}

#pragma mark - 定位
- (BMKLocationService *)locService {
    if (!_locService) {
        //初始化BMKLocationService
        _locService = [[BMKLocationService alloc]init];
        _locService.delegate = self;
        
    }
    return _locService;
}

#pragma mark  实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    //NSLog(@"heading is %@",userLocation.heading);
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation 纬度 %f,经度 %f, 海拔 %f, 航向 %f, 行走速度%f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude, userLocation.location.altitude, userLocation.location.course, userLocation.location.speed);
    
  
    [self.locService stopUserLocationService];
}


#pragma mark - 获取设备信息
- (void)setupInfo {
    self.infoArray = [NSMutableArray array];
    
    NSString *deviceName = [self getDeviceName];
    NSLog(@"设备型号-->%@", deviceName);
    NSDictionary *dict1 = @{
                            @"infoKey"   : @"设备型号",
                            @"infoValue" : deviceName
                            };
    [self.infoArray addObject:dict1];
    
    
    NSString *iPhoneName = [UIDevice currentDevice].name;
    NSLog(@"iPhone名称-->%@", iPhoneName);
    NSDictionary *dict2 = @{
                            @"infoKey"   : @"iPhone名称",
                            @"infoValue" : iPhoneName
                            };
    [self.infoArray addObject:dict2];
    
    
    NSString *appVerion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"app版本号-->%@", appVerion);
    NSDictionary *dict3 = @{
                            @"infoKey"   : @"app版本号",
                            @"infoValue" : appVerion
                            };
    [self.infoArray addObject:dict3];
    
    
    CGFloat batteryLevel = [[UIDevice currentDevice] batteryLevel];
    NSLog(@"电池电量-->%f", batteryLevel);
    NSDictionary *dict4 = @{
                            @"infoKey"   : @"电池电量",
                            @"infoValue" : [@(batteryLevel) stringValue]
                            };
    [self.infoArray addObject:dict4];
    
    
    NSString *localizedModel = [UIDevice currentDevice].localizedModel;
    NSLog(@"localizedModel-->%@", localizedModel);
    NSDictionary *dict5 = @{
                            @"infoKey"   : @"localizedModel",
                            @"infoValue" : localizedModel
                            };
    [self.infoArray addObject:dict5];
    
    NSString *systemName = [UIDevice currentDevice].systemName;
    NSLog(@"当前系统名称-->%@", systemName);
    NSDictionary *dict6 = @{
                            @"infoKey"   : @"当前系统名称",
                            @"infoValue" : systemName
                            };
    [self.infoArray addObject:dict6];
    
    NSString *systemVersion = [UIDevice currentDevice].systemVersion;
    NSLog(@"当前系统版本号-->%@", systemVersion);
    NSDictionary *dict7 = @{
                            @"infoKey"   : @"当前系统版本号",
                            @"infoValue" : systemVersion
                            };
    [self.infoArray addObject:dict7];
    
    // 广告位标识符：在同一个设备上的所有App都会取到相同的值，是苹果专门给各广告提供商用来追踪用户而设的，用户可以在 设置|隐私|广告追踪里重置此id的值，或限制此id的使用，故此id有可能会取不到值，但好在Apple默认是允许追踪的，而且一般用户都不知道有这么个设置，所以基本上用来监测推广效果，是戳戳有余了
    NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    NSLog(@"广告位标识符idfa-->%@", idfa);
    NSDictionary *dict8 = @{
                            @"infoKey"   : @"广告位标识符idfa",
                            @"infoValue" : idfa
                            };
    [self.infoArray addObject:dict8];
    
    //  UUID是Universally Unique Identifier的缩写，中文意思是通用唯一识别码。它是让分布式系统中的所有元素，都能有唯一的辨识资讯，而不需要透过中央控制端来做辨识资讯的指 定。这样，每个人都可以建立不与其它人冲突的 UUID。在此情况下，就不需考虑数据库建立时的名称重复问题。苹果公司建议使用UUID为应用生成唯一标识字符串。
    NSString *uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSLog(@"唯一识别码uuid-->%@", uuid);
    NSDictionary *dict9 = @{
                            @"infoKey"   : @"唯一识别码uuid",
                            @"infoValue" : uuid
                            };
    [self.infoArray addObject:dict9];
    
    NSString *device_token_crc32 = [[NSUserDefaults standardUserDefaults]objectForKey:@"device_token_crc32"];
    NSLog(@"device_token_crc32真机测试才会显示-->%@", device_token_crc32);
    if (device_token_crc32 == nil) {
        device_token_crc32 = @"";
    }
    NSDictionary *dict10 = @{
                             @"infoKey"   : @"device_token_crc32真机测试才会显示",
                             @"infoValue" : device_token_crc32
                             };
    [self.infoArray addObject:dict10];
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *device_model = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    NSLog(@"device_model-->%@", device_model);
    NSDictionary *dict11 = @{
                             @"infoKey"   : @"device_model",
                             @"infoValue" : device_model
                             };
    [self.infoArray addObject:dict11];
    
    
    NSString *macAddress = [self getMacAddress];
    NSLog(@"macAddress-->%@", macAddress);
    NSDictionary *dict12 = @{
                             @"infoKey"   : @"macAddress",
                             @"infoValue" : macAddress
                             };
    [self.infoArray addObject:dict12];
    
    NSString *deviceIP = [self getDeviceIPAddresses];
    NSLog(@"deviceIP-->%@", deviceIP);
    NSDictionary *dict13 = @{
                             @"infoKey"   : @"deviceIP",
                             @"infoValue" : deviceIP
                             };
    [self.infoArray addObject:dict13];
}

// 获取ip
- (NSString *)getDeviceIPAddresses {
    
    int sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    
    
    NSMutableArray *ips = [NSMutableArray array];
    
    int BUFFERSIZE = 4096;
    
    struct ifconf ifc;
    
    char buffer[BUFFERSIZE], *ptr, lastname[IFNAMSIZ], *cptr;
    
    struct ifreq *ifr, ifrcopy;
    
    ifc.ifc_len = BUFFERSIZE;
    ifc.ifc_buf = buffer;
    
    if (ioctl(sockfd, SIOCGIFCONF, &ifc) >= 0){
        
        for (ptr = buffer; ptr < buffer + ifc.ifc_len; ){
            
            ifr = (struct ifreq *)ptr;
            int len = sizeof(struct sockaddr);
            
            if (ifr->ifr_addr.sa_len > len) {
                len = ifr->ifr_addr.sa_len;
            }
            
            ptr += sizeof(ifr->ifr_name) + len;
            if (ifr->ifr_addr.sa_family != AF_INET) continue;
            if ((cptr = (char *)strchr(ifr->ifr_name, ':')) != NULL) *cptr = 0;
            if (strncmp(lastname, ifr->ifr_name, IFNAMSIZ) == 0) continue;
            
            memcpy(lastname, ifr->ifr_name, IFNAMSIZ);
            ifrcopy = *ifr;
            ioctl(sockfd, SIOCGIFFLAGS, &ifrcopy);
            
            if ((ifrcopy.ifr_flags & IFF_UP) == 0) continue;
            
            NSString *ip = [NSString  stringWithFormat:@"%s", inet_ntoa(((struct sockaddr_in *)&ifr->ifr_addr)->sin_addr)];
            [ips addObject:ip];
        }
    }
    
    close(sockfd);
    NSString *deviceIP = @"";
    
    for (int i=0; i < ips.count; i++) {
        if (ips.count > 0) {
            deviceIP = [NSString stringWithFormat:@"%@",ips.lastObject];
        }
    }
    return deviceIP;
}

/**
 *  获取mac地址
 *
 *  @return mac地址  为了保护用户隐私，每次都不一样，苹果官方哄小孩玩的
 */
- (NSString *)getMacAddress {
    int                    mib[6];
    size_t                len;
    char                *buf;
    unsigned char        *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl    *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    
    NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return [outstring uppercaseString];
}


// 获取设备型号
- (NSString *)getDeviceName
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceString isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPod5,1"])      return @"iPod Touch (5 Gen)";
    
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad1,2"])      return @"iPad 3G";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"iPad2,4"])      return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,6"])      return @"iPad Mini";
    if ([deviceString isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPad3,3"])      return @"iPad 3";
    if ([deviceString isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,5"])      return @"iPad 4";
    if ([deviceString isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([deviceString isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    if ([deviceString isEqualToString:@"iPad4,4"])      return @"iPad Mini 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad4,5"])      return @"iPad Mini 2 (Cellular)";
    if ([deviceString isEqualToString:@"iPad4,6"])      return @"iPad Mini 2";
    if ([deviceString isEqualToString:@"iPad4,7"])      return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad4,8"])      return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad4,9"])      return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad5,1"])      return @"iPad Mini 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad5,2"])      return @"iPad Mini 4 (LTE)";
    if ([deviceString isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad6,3"])      return @"iPad Pro 9.7";
    if ([deviceString isEqualToString:@"iPad6,4"])      return @"iPad Pro 9.7";
    if ([deviceString isEqualToString:@"iPad6,7"])      return @"iPad Pro 12.9";
    if ([deviceString isEqualToString:@"iPad6,8"])      return @"iPad Pro 12.9";
    
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    
    
    return deviceString;
}

@end
