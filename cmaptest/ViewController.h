//
//  ViewController.h
//  cmaptest
//
//  Created by AppleUser on 2016/03/27.
//  Copyright © 2016年 rizworks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController<CLLocationManagerDelegate>
{
    // ロケーションマネージャー
    CLLocationManager* _locationManager;
}
// マップビュー
@property (nonatomic, assign) MKMapView *mapView;

@end

