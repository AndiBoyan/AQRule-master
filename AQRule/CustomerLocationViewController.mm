//
//  CustomerLocationViewController.m
//  AQRule
//
//  Created by icePhoenix on 15/7/24.
//  Copyright (c) 2015年 3vjia. All rights reserved.
//

#import "CustomerLocationViewController.h"
#import "NSAlertView.h"

@interface CustomerLocationViewController ()

@end

@implementation CustomerLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //地图初始化
    mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    mapView.delegate = self;
    [self.view addSubview:mapView];
    [mapView setZoomLevel:14];
    [self initNavigation];
    [self geocodeSearch];

}
#pragma mark 初始化导航栏

-(void)initNavigation
{
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 65)];
    
    //创建一个导航栏集合
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:nil];
    navigationItem.title = self.navTitle;
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"back.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    navigationItem.leftBarButtonItem = leftButton;
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    navigationBar.barStyle = UIBarStyleBlack;
    [navigationBar setBarTintColor:[UIColor colorWithRed:239/255.0 green:185/255.0 blue:75/255.0 alpha:1.0]];
    [navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
    [self.view addSubview:navigationBar];
    
}
-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 搜索服务

-(void)geocodeSearch
{
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    _geocodesearch.delegate = self;
    BMKGeoCodeSearchOption *geocodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
    geocodeSearchOption.city= @"广州市";
    geocodeSearchOption.address = @"天河区软件路15号";
    BOOL flag = [_geocodesearch geoCode:geocodeSearchOption];
    if(!flag)
    {
        [NSAlertView alert:@"geo检索发送失败"];
    }
}

#pragma mark 地理编码

- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
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

@end
