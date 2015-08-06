//
//  CustomerLocationViewController.m
//  AQRule
//
//  Created by icePhoenix on 15/7/24.
//  Copyright (c) 2015年 3vjia. All rights reserved.
//

#import "CustomerLocationViewController.h"
#import <BaiduMapAPI/BMKMapView.h>
#import <BaiduMapAPI/BMapKit.h>

@interface CustomerLocationViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
{
    BMKGeoCodeSearch* _geocodesearch;
    BMKMapView* mapView;
    BOOL updataState;
    bool isGeoSearch;
}

@end

@implementation CustomerLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    mapView.delegate = self;
    [self.view addSubview:mapView];
    [mapView setZoomLevel:14];
    [self initNavigation];

}
-(void)viewDidAppear:(BOOL)animated
{
    // Do any additional setup after loading the view.
   
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    _geocodesearch.delegate = self;
    BMKGeoCodeSearchOption *geocodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
    geocodeSearchOption.city= @"广州市";
    geocodeSearchOption.address = @"天河区软件路15号";
    BOOL flag = [_geocodesearch geoCode:geocodeSearchOption];
    if(flag)
    {
        NSLog(@"geo检索发送成功");
    }
    else
    {
        NSLog(@"geo检索发送失败");
    }
    [super viewDidAppear:YES];
}
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
   // NSArray* array = [NSArray arrayWithArray:mapView.annotations];
    //[mapView removeAnnotations:array];
   // array = [NSArray arrayWithArray:mapView.overlays];
    //[mapView removeOverlays:array];
    if (error == 0) {
        BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
        item.coordinate = result.location;
        item.title = result.address;
        [mapView addAnnotation:item];
        mapView.centerCoordinate = result.location;
    }
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
        return newAnnotationView;
    }
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initNavigation
{
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 65)];
    
    //创建一个导航栏集合
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:nil];
    navigationItem.title = self.navTitle;
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    navigationItem.leftBarButtonItem = leftButton;
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    [self.view addSubview:navigationBar];

}
-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)updataLocation
{
    
}
@end
