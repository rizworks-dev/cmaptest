//
//  ViewController.m
//  cmaptest
//
//  Created by AppleUser on 2016/03/27.
//  Copyright © 2016年 rizworks. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CGRect rect1 = [[UIScreen mainScreen] bounds];
    float mapW = rect1.size.width;
    float mapH = rect1.size.height;
    // 生成
    MKMapView *mv = [[MKMapView alloc] init];
    mv.frame = 	CGRectMake(0,0,mapW,mapH);
    
    // 表示位置を設定（ここでは東京都庁の経度緯度を例としています）
    CLLocationCoordinate2D co;
    co.latitude = 35.68664111; // 経度
    co.longitude = 139.6948839; // 緯度
    [mv setCenterCoordinate:co animated:NO];
    
    // 縮尺を指定
    MKCoordinateRegion cr = mv.region;
    cr.center = co;
    cr.span.latitudeDelta = 0.5;
    cr.span.longitudeDelta = 0.5;
    [mv setRegion:cr animated:NO];
    
    // addSubview
    [self.view addSubview:mv];
    
    self.mapView = mv;
//    // 表示タイプを航空写真と地図のハイブリッドに設定
//    self.mapView.mapType = MKMapTypeStandard;
//    
//    self.mapView.showsUserLocation = YES;
//    
//    // view に追加
//    [self.view addSubview:self.mapView];
    
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc]init];
        _locationManager.delegate = self;
    }
    
    
    if ([CLLocationManager locationServicesEnabled]) {
        CLAuthorizationStatus authStatus = [CLLocationManager authorizationStatus];
        if (authStatus < kCLAuthorizationStatusAuthorized)
        {
            [_locationManager requestWhenInUseAuthorization];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    // 位置情報更新
    CLLocationDegrees longitude = newLocation.coordinate.longitude;
    CLLocationDegrees latitude = newLocation.coordinate.latitude;
    
    CLLocationCoordinate2D co;
    co.latitude = latitude; // 緯度
    co.longitude = longitude; // 経度
    [self.mapView setCenterCoordinate:co animated:YES];
    
    
    CLGeocoder* geocoder;
    if (!geocoder) {
        geocoder = [[CLGeocoder alloc] init];
    }
    
    [geocoder reverseGeocodeLocation:newLocation completionHandler:
     ^(NSArray* placemarks, NSError* error){
         if ([placemarks count] > 0)
         {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             NSString* postCode = placemark.postalCode;
             NSString* subLocality = [placemark subLocality];
             NSLog(@"%@ %@", postCode, subLocality);
         }
     }
     ];
}

-(void)locationManager:(CLLocationManager *)locationManager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            break;
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            // 位置情報取得開始
            [locationManager startUpdatingLocation];
        case kCLAuthorizationStatusDenied:
        case kCLAuthorizationStatusRestricted:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
