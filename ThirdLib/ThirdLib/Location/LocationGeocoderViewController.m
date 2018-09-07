//
//  LocationGeocoderViewController.m
//  ThirdLib
//
//  Created by 王博 on 2018/7/12.
//  Copyright © 2018年 胡晓辉. All rights reserved.
//

#import "LocationGeocoderViewController.h"
@import CoreLocation;
@interface LocationGeocoderViewController ()
@property (weak, nonatomic) IBOutlet UILabel *latitudeL;
@property (weak, nonatomic) IBOutlet UILabel *longtitudeL;
@property (weak, nonatomic) IBOutlet UITextView *addL;
@property (weak, nonatomic) IBOutlet UITextField *latitudeTF;
@property (weak, nonatomic) IBOutlet UITextField *longtitudeTF;
@property (weak, nonatomic) IBOutlet UITextView *geoTF;

@property (nonatomic, strong) CLGeocoder *geo;
@end

@implementation LocationGeocoderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *geoCode = [[UIBarButtonItem alloc] initWithTitle:@"编码" style:UIBarButtonItemStyleDone target:self action:@selector(coder)];
    UIBarButtonItem *geoDeCode = [[UIBarButtonItem alloc] initWithTitle:@"反编码" style:UIBarButtonItemStyleDone target:self action:@selector(deCoder)];
    self.navigationItem.rightBarButtonItems = @[geoCode, geoDeCode];

    _geo = [CLGeocoder new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -------------- action --------------

- (void)deCoder
{
    CLLocation *location = [[CLLocation alloc] initWithLatitude:[_latitudeTF.text floatValue] longitude:[_longtitudeTF.text floatValue]];
    [_geo reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *firstPM = [placemarks firstObject];
        self->_geoTF.text = [NSString stringWithFormat:@"%@(%@) %@ %@ %@ %@ %@", firstPM.country, firstPM.ISOcountryCode, firstPM.locality, firstPM.subLocality, firstPM.name, firstPM.thoroughfare, firstPM.subThoroughfare];
        CLLocationCoordinate2D Coordinate2D = firstPM.location.coordinate;
        CLLocationDegrees latitude = Coordinate2D.latitude;
        CLLocationDegrees longitude = Coordinate2D.longitude;
        self->_latitudeTF.text = [NSString stringWithFormat:@"%.2f", latitude];
        self->_longtitudeTF.text = [NSString stringWithFormat:@"%.2f", longitude];

    }];
}

- (void)coder
{
    NSString *address = _addressTF.text;
    [_geo geocodeAddressString:address completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error || placemarks.count == 0) {
            self->_addL.text = @"没有找到这个地址";
            return ;
        }
        /*
         61                     name:名称
         62                     locality:城市
         63                     country:国家
         64                     postalCode:邮政编码
         65                  */
        for (CLPlacemark *pm in placemarks) {
            NSLog(@"addressDictionary = %@, country = %@, ISOcountryCode = %@, locality = %@, subLocality = %@, name = %@, thoroughfare = %@, subThoroughfare = %@, administrativeArea = %@, subAdministrativeArea = %@, postalCode = %@, inlandWater = %@, ocean = %@, areasOfInterest = %@", pm.addressDictionary, pm.country, pm.ISOcountryCode, pm.locality, pm.subLocality, pm.name, pm.thoroughfare, pm.subThoroughfare, pm.administrativeArea, pm.subAdministrativeArea, pm.postalCode, pm.inlandWater, pm.ocean, pm.areasOfInterest);
        }
        
        CLPlacemark *firstPM = [placemarks firstObject];
        self->_addL.text = [NSString stringWithFormat:@"%@(%@) %@ %@ %@ %@ %@", firstPM.country, firstPM.ISOcountryCode, firstPM.locality, firstPM.subLocality, firstPM.name, firstPM.thoroughfare, firstPM.subThoroughfare];
        CLLocationCoordinate2D Coordinate2D = firstPM.location.coordinate;
        CLLocationDegrees latitude = Coordinate2D.latitude;
        CLLocationDegrees longitude = Coordinate2D.longitude;
        self->_latitudeL.text = [NSString stringWithFormat:@"%.2f", latitude];
        self->_longtitudeL.text = [NSString stringWithFormat:@"%.2f", longitude];
        
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
