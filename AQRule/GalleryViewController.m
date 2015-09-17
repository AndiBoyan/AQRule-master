//
//  GalleryViewController.m
//  AQRule
//
//  Created by icePhoenix on 15/7/23.
//  Copyright (c) 2015年 3vjia. All rights reserved.
//

#import "GalleryViewController.h"
#import "ImageExamine.h"

#define  kOnceLoadingCount 40

@interface GalleryViewController ()<JSGridViewDataSource, JSGridViewDelegate> {
    NSArray *_images;
    float cellImageWidth;
    NSArray *name;
}
@end


@implementation GalleryViewController
@synthesize gridView = _gridView;

- (void)viewDidLoad {
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:239/255.0 green:185/255.0 blue:75/255.0 alpha:1.0]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
    //self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [super viewDidLoad];
    cellImageWidth = (self.view.frame.size.width/2)-10;
    self.gridView = [[JSGridView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-45)];
    self.gridView.delegate = self;
    self.gridView.dataSource = self;
    [self.view addSubview:self.gridView];
    _leftArray = [[NSMutableArray alloc] init];
    _rightArray = [[NSMutableArray alloc] init];
    _loadCount = 11;
    _isLoading = NO;
    _images = [[NSArray alloc] initWithObjects:
               [UIImage imageNamed:@"粉色公主房.jpg"],
               [UIImage imageNamed:@"粉色系现代厨房.jpg"],
               [UIImage imageNamed:@"黑白调.jpg"],
               [UIImage imageNamed:@"简约黄白.jpg"],
               [UIImage imageNamed:@"精装现代卧室.jpg"],
               [UIImage imageNamed:@"卡布其诺.jpg"],
               [UIImage imageNamed:@"蓝色静谧.jpg"],
               [UIImage imageNamed:@"蓝天白云.jpg"],
               [UIImage imageNamed:@"美式厨风.jpg"],
               [UIImage imageNamed:@"品味现代.jpg"],
               [UIImage imageNamed:@"秋之白华.jpg"],
               [UIImage imageNamed:@"少女情怀.jpg"],
               //[UIImage imageNamed:@"现代绿色 吧台 厨房.jpg"],
               //[UIImage imageNamed:@"现代生活.jpg"],
               //[UIImage imageNamed:@"悠闲生活.jpg"],
               [UIImage imageNamed:@"中灰色调.jpg"],
               [UIImage imageNamed:@"中庸之道.jpg"],
               nil];
    name = [[NSArray alloc]initWithObjects:@"粉色公主房",@"粉色系现代厨房",@"黑白调",@"简约黄白",@"精装现代卧室",@"卡布其诺",@"蓝色静谧",@"蓝天白云",@"美式厨风",@"品味现代",@"秋之白华",@"少女情怀",
            //@"现代绿色 吧台 厨房",
           // @"现代生活",
           // @"悠闲生活",
            @"中灰色调",@"中庸之道", nil];
    [self addTableViewData];
}

-(void)viewDidAppear:(BOOL)animated
{
    [examineView removeFromSuperview];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Helper
- (NSArray *)arrayValueByTableKey:(NSInteger)columnIndex {
    NSArray *array = [NSArray array];
    if (columnIndex==0) {
        array = _leftArray;
    } else if (columnIndex==1) {
        array = _rightArray;
    }
    return array;
}

- (void)addTableViewData {
   // _loadCount += kOnceLoadingCount;
    for (int i = 0; i<_images.count; i++) {
        UIImage *img = [_images objectAtIndex:i];
        float height = img.size.height/(img.size.width/150);//(float)(arc4random()%225);
        double mininum = MIN(_lefeHeight, _rightHeight);
        // data info
        NSDictionary *info = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%f", height]
                                                         forKey:@"usingHeight"];
        if (_lefeHeight == mininum) {
            _lefeHeight += height;
            [_leftArray addObject:info];
        } else if (_rightHeight == mininum) {
            _rightHeight += height;
            [_rightArray addObject:info];
        }
    }
    [_gridView reloadData];
}

#pragma mark - JSGridView


- (JSGridViewConstSize)constSizeForGeidView:(JSGridView *)gridView {
    return JSGridViewConstSizeWidth;
}

- (CGFloat)gridView:(JSGridView *)gridView heightForCellAtRow:(NSInteger)row column:(NSInteger)column {
    id obj = [[self arrayValueByTableKey:column] objectAtIndex:row];
    return [[obj objectForKey:@"usingHeight"] intValue]+5;
}

- (CGFloat)gridView:(JSGridView *)gridView widthForCellAtColumnIndex:(NSInteger)column {
    return cellImageWidth+5;
}

- (NSInteger)numberOfRowsInGridView:(JSGridView *)gridView forConstColumnWithIndex:(NSInteger)column {
    return [[self arrayValueByTableKey:column] count];
}

- (NSInteger)numberOfConstColumnsInGridView:(JSGridView *)gridView {
    return 2;
}

- (void)gridView:(JSGridView *)gridView scrolledToEdge:(JSGridViewEdge)edge {
    if (edge == JSGridViewEdgeBottom) {
        //        _isLoading = YES;
        //[self addTableViewData];
    }
}
- (JSGridViewCell *)gridView:(JSGridView *)gridView viewForRow:(NSInteger)row column:(NSInteger)column {
    NSArray *array = [self arrayValueByTableKey:column];
    NSString *identifier = @"testCell";
    JSGridViewCell *cell = [gridView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[JSGridViewCell alloc] initWithReuseIdentifier:identifier];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        imageView.tag = 50;
        imageView.layer.cornerRadius = 5;
        imageView.layer.masksToBounds = YES;
        
        [cell addSubview:imageView];
        
        UILabel *lab = [[UILabel alloc]init];
        lab.backgroundColor = [UIColor groupTableViewBackgroundColor];
        lab.tag = 60;
        [cell addSubview:lab];
        
        cell.delegate = self;
    }
    cell.row = row;
    cell.column = column;
    NSDictionary *oneDic = [array objectAtIndex:row];
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:50];
    float height = [[oneDic objectForKey:@"usingHeight"] floatValue];
    imageView.frame = CGRectMake(5, 5, cellImageWidth, height);
    NSInteger i = (row*2+column)%[_images count];
    /*if (row*2+column == _images.count) {
        i =_images.count-1;
    }*/
    imageView.image = [_images objectAtIndex:i];
    
    UILabel *lab = (UILabel*)[cell viewWithTag:60];
    lab.frame = CGRectMake(5, height-25, cellImageWidth, 30);
    lab.textAlignment = NSTextAlignmentCenter ;
    lab.font = [UIFont systemFontOfSize:10.0f];
    lab.text = [name objectAtIndex:i];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:lab.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = lab.bounds;
    maskLayer.path = maskPath.CGPath;
    lab.layer.mask = maskLayer;

    return cell;
}

- (void)gridViewCellWasTouched:(JSGridViewCell *)gridViewCell {
    
    examineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];

    [self.view addSubview:examineView];
    examineView.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.0f];
    UIImage *image = [_images objectAtIndex:(gridViewCell.row*2+gridViewCell.column)%(_images.count)];
    if (gridViewCell.row*2+gridViewCell.column == _images.count) {
        image = [_images objectAtIndex:_images.count-1];
    }
    float w = self.view.frame.size.width-40;
    float h = (w*image.size.height)/image.size.width;
    
    UIImageView *imageExamine = [[UIImageView alloc]initWithFrame:CGRectMake(20, (self.view.frame.size.height-h)/2, w, h)];
    imageExamine.image = image;
    [examineView addSubview:imageExamine];
    UIBezierPath *maskPath1 = [UIBezierPath bezierPathWithRoundedRect:imageExamine.bounds  byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc] init];
    maskLayer1.frame = imageExamine.bounds;
    maskLayer1.path = maskPath1.CGPath;
    imageExamine.layer.mask = maskLayer1;
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(self.view.frame.size.width-50, (self.view.frame.size.height-h)/2, 30, 30);
    
    [closeBtn setImage:[[UIImage imageNamed:@"delete_img"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    
    [closeBtn addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    [examineView addSubview:closeBtn];
    
}

-(void)close:(id)sender
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         examineView.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         [examineView removeFromSuperview];
                     }];
}

@end
