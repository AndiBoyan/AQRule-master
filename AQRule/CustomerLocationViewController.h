//
//  地理位置信息类
//  AQRule
//
//  Created by icePhoenix on 15/7/24.
//  Copyright (c) 2015年 3vjia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI/BMKMapView.h>
#import <BaiduMapAPI/BMapKit.h>

@interface CustomerLocationViewController : UIViewController<BMKMapViewDelegate,BMKLocationServiceDelegate,
                                                             BMKGeoCodeSearchDelegate>
{
    BMKGeoCodeSearch* _geocodesearch;
    BMKGeoCodeSearch* _searcher;
    BMKMapView* mapView;
}
@property (nonatomic,strong) NSString *navTitle;

@end
