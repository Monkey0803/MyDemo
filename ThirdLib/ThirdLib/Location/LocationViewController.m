//
//  LocationViewController.m
//  ThirdLib
//
//  Created by 王博 on 2018/7/12.
//  Copyright © 2018年 胡晓辉. All rights reserved.
//

#import "LocationViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "LocationGeocoderViewController.h"
@interface LocationViewController ()<CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *clManager;
@property (nonatomic, strong) CLGeocoder *clGeo;
@end

@implementation LocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    [self initLocation];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编码" style:UIBarButtonItemStyleDone target:self action:@selector(coder:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -------------- coder --------------

- (void)coder:(UIBarButtonItem *)item
{
    LocationGeocoderViewController *geoVC = [[LocationGeocoderViewController alloc] initWithNibName:@"LocationGeocoderViewController" bundle:nil];
    [self.navigationController pushViewController:geoVC animated:YES];
}

#pragma mark -------------- 初始化location --------------

- (void)initLocation
{
    _clManager = [CLLocationManager new];
    _clGeo = [CLGeocoder new];
    BOOL serviceEnabled = [CLLocationManager locationServicesEnabled];
    NSLog(@"serviceEnabled = %d", serviceEnabled);
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusNotDetermined) {
        [_clManager requestAlwaysAuthorization];
    }else if (status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusRestricted) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [alertC addAction:[UIAlertAction actionWithTitle:@"打开设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSURL *setURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:setURL]) {
                if (@available(iOS 10.0, *)) {
                    [[UIApplication sharedApplication] openURL:setURL options:@{} completionHandler:nil];
                } else {
                    [[UIApplication sharedApplication] openURL:setURL];
                }
            }
            
        }]];
        [alertC addAction:[UIAlertAction actionWithTitle:@"" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [alertC presentViewController:alertC animated:YES completion:nil];
    }
    _clManager.delegate = self;
    //    每隔多少米定位一次 (这里的设置为任何的移动）
    _clManager.distanceFilter = kCLDistanceFilterNone;
    //定位精度 ，精度越高越耗电
    _clManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    if (@available(iOS 11.0, *)) {
        _clManager.showsBackgroundLocationIndicator = YES;
    } else {
        // Fallback on earlier versions
    }
    [_clManager startUpdatingLocation];
    
}
#pragma mark -------------- 地理编码 --------------

- (void)geocoder:(CLLocation *)location
{
    __weak typeof(self) weakSelf = self;
    if (@available(iOS 11.0, *)) {
        [self.clGeo reverseGeocodeLocation:location preferredLocale:[NSLocale currentLocale] completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            [weakSelf dealPlacemark: [placemarks firstObject]];
        }];
    } else {
        
        [self.clGeo reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            [weakSelf dealPlacemark: [placemarks firstObject]];
        }];
    }
}

- (void)dealPlacemark:(CLPlacemark *)placemark
{
    NSString *name = placemark.name;
    //大路
    NSString *thoroughfare = placemark.thoroughfare;
    //小路
    NSString *subThoroughfare = placemark.subThoroughfare;
    //省份
    NSString *locality = placemark.locality;
    //市
    NSString *subLocality = placemark.subLocality;
    //邮编
    NSString *postalCode = placemark.postalCode;
    //国家代码(CN)
    NSString *ISOcountryCode = placemark.ISOcountryCode;
    //国家
    NSString *country = placemark.country;
    //
    NSString *inlandWater = placemark.inlandWater;
    //大洋
    NSString *ocean = placemark.ocean;
    //附近的景点
    NSArray *areasOfInterest = placemark.areasOfInterest;
    NSString *totalStr = [NSString stringWithFormat:@"%@(%@) %@ %@",country, ISOcountryCode, locality, subLocality];
    
    
}

#pragma mark -------------- CLLocationManagerDelegate --------------

//定位失败
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"%@", error.description);
}
//定位更新
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *lastCL = [locations lastObject];
    [self geocoder:lastCL];
//    路线，航向（取值范围是0.0° ~ 359.9°，0.0°代表真北方向）
    CLLocationDirection course = lastCL.course;
//    行走速度（单位是m/s）
    CLLocationSpeed speed = lastCL.speed;
    //水平精度
    CLLocationAccuracy horizontalAccuracy = lastCL.horizontalAccuracy;
    //垂直精度
    CLLocationAccuracy verticalAccuracy = lastCL.verticalAccuracy;
    //定位时间
    NSDate *timestamp = lastCL.timestamp;
    
    //海拔
    CLLocationDistance altitude = lastCL.altitude;
    //坐标
    CLLocationCoordinate2D coordinate = lastCL.coordinate;
    //纬度
    CLLocationDegrees latitude = coordinate.latitude;
    //精度
    CLLocationDegrees longitude = coordinate.longitude;
    
    
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
    
}

//暂停定位
- (void)locationManagerDidPauseLocationUpdates:(CLLocationManager *)manager
{
    
}
//暂停后重新开始定位
- (void)locationManagerDidResumeLocationUpdates:(CLLocationManager *)manager
{
    
}

//进入某个区域
- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    
}
//离开某个区域
- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    
}

//定位权限改变
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"定位权限改变了" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertC addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alertC animated:YES completion:nil];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
