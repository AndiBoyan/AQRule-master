//
//  GalleryViewController.m
//  AQRule
//
//  Created by icePhoenix on 15/7/23.
//  Copyright (c) 2015年 3vjia. All rights reserved.
//

#import "GalleryViewController.h"

#define  kOnceLoadingCount 40

@interface GalleryViewController ()<JSGridViewDataSource, JSGridViewDelegate> {
    NSArray *_images;
    float cellImageWidth;
}
@end
//"00000028"
@implementation GalleryViewController
@synthesize gridView = _gridView;

- (void)viewDidLoad {
    [super viewDidLoad];
    cellImageWidth = (self.view.frame.size.width/2)-10;
    self.gridView = [[JSGridView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-65)];
    self.gridView.delegate = self;
    self.gridView.dataSource = self;
    [self.view addSubview:self.gridView];
    _leftArray = [[NSMutableArray alloc] init];
    _rightArray = [[NSMutableArray alloc] init];
    _loadCount = 11;
    _isLoading = NO;
    _images = [[NSArray alloc] initWithObjects:
               [UIImage imageNamed:@"0.jpeg"],
               [UIImage imageNamed:@"1.jpeg"],
               [UIImage imageNamed:@"2.jpeg"],
               [UIImage imageNamed:@"3.jpeg"],
               [UIImage imageNamed:@"4.jpeg"],
               [UIImage imageNamed:@"5.jpeg"],
               [UIImage imageNamed:@"6.jpeg"],
               [UIImage imageNamed:@"7.jpeg"],
               [UIImage imageNamed:@"8.jpeg"],
               [UIImage imageNamed:@"9.jpeg"],
               [UIImage imageNamed:@"10.jpeg"], nil];
    [self addTableViewData];
    
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
    NSLog(@"%ld",_images.count);
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
    NSLog(@"l = %@r = %@",_leftArray,_rightArray);
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
    if (row*2+column == _images.count) {
        i = _images.count-1;
    }
    imageView.image = [_images objectAtIndex:i];
    
    UILabel *lab = (UILabel*)[cell viewWithTag:60];
    lab.frame = CGRectMake(5, height-15, cellImageWidth, 20);
    lab.textAlignment = NSTextAlignmentCenter ;
    lab.text = [NSString stringWithFormat:@"%ld",i];
    lab.layer.cornerRadius = 5;
    lab.layer.masksToBounds = YES;

    return cell;
}

- (void)gridViewCellWasTouched:(JSGridViewCell *)gridViewCell {
    NSLog(@"row : %ld, column : %ld", gridViewCell.row, gridViewCell.column);
}


@end
