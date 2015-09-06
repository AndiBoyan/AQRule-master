//
//  GalleryViewController.h
//  AQRule
//
//  Created by icePhoenix on 15/7/23.
//  Copyright (c) 2015年 3vjia. All rights reserved.
//

//图库
#import <UIKit/UIKit.h>
#import "JSGridView.h"

@interface GalleryViewController : UIViewController
{
    
@private
    JSGridView *_gridView;

    NSInteger _lefeHeight;
    NSInteger _rightHeight;

    NSMutableArray *_leftArray;
    NSMutableArray *_rightArray;
    NSInteger _loadCount;
    
    UIView *examineView;
BOOL _isLoading;
}

//@property (strong, nonatomic) id detailItem;

@property (retain, nonatomic) IBOutlet JSGridView *gridView;

@end
