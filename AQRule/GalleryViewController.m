//
//  GalleryViewController.m
//  AQRule
//
//  Created by icePhoenix on 15/7/23.
//  Copyright (c) 2015年 3vjia. All rights reserved.
//

#import "GalleryViewController.h"

#define  kOneCellImageWidth 150//图片宽度
#define  kOnceLoadingCount 40

@interface GalleryViewController ()<JSGridViewDataSource, JSGridViewDelegate> {
    NSArray *_images;
}
@end
//"00000028"
@implementation GalleryViewController
@synthesize gridView = _gridView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.gridView = [[JSGridView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-65)];
    self.gridView.delegate = self;
    self.gridView.dataSource = self;
    [self.view addSubview:self.gridView];
    // Do any additional setup after loading the view.
    // Do any additional setup after loading the view, typically from a nib.
    _leftArray = [[NSMutableArray alloc] init];
    _rightArray = [[NSMutableArray alloc] init];
    _loadCount = 10;
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
    for (int i=0; i<_loadCount; i++) {
        UIImage *img = [_images objectAtIndex:i%10];
        float height = img.size.height/(img.size.width/150);//(float)(arc4random()%225);
        if (height<50) height += 50;
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
    return kOneCellImageWidth+5;
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
        [self addTableViewData];
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
        //        [imageView setDelegate:self];
        //        imageView.backgroundColor = HHColor(110.0, 110.0, 110.0, 0.4);
        [cell addSubview:imageView];
        
        UILabel *lab = [[UILabel alloc]init];
        lab.backgroundColor = [UIColor redColor];
        lab.tag = 60;
        [cell addSubview:lab];
        
        cell.delegate = self;
    }
    cell.row = row;
    cell.column = column;
    NSDictionary *oneDic = [array objectAtIndex:row];
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:50];
    float height = [[oneDic objectForKey:@"usingHeight"] floatValue];
    imageView.frame = CGRectMake(5, 5, kOneCellImageWidth, height);
    int i = (row*column+row+column)%[_images count];
    imageView.image = [_images objectAtIndex:i];
    
    UILabel *lab = (UILabel*)[cell viewWithTag:60];
    lab.frame = CGRectMake(5, height-20, kOneCellImageWidth, 20);
    
    return cell;
}

- (void)gridViewCellWasTouched:(JSGridViewCell *)gridViewCell {
    NSLog(@"row : %d, column : %d", gridViewCell.row, gridViewCell.column);
}


@end
