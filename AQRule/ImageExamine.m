//
//  ImageExamine.m
//  AQRule
//
//  Created by 3Vjia on 15/8/11.
//  Copyright (c) 2015年 3vjia. All rights reserved.
//

#import "ImageExamine.h"

@implementation ImageExamine

- (void)drawRect:(CGRect)rect {
    // Drawing code
    float w = [UIScreen mainScreen].bounds.size.width;
    float h = [UIScreen mainScreen].bounds.size.height-65;
    
    UIView *examine = [[UIView alloc]initWithFrame:CGRectMake((w-self.imageWidth/2)/2, (h-self.imageHeigth/2)/2, self.imageWidth/2, self.imageHeigth/2)];
    [self addSubview:examine];
    
    UIImageView *examineIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, examine.frame.size.width, examine.frame.size.height)];

    examineIV.image = self.image;
    [examine addSubview:examineIV];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(examineIV.frame.size.width-30, 0, 30, 30);
    
    [closeBtn setImage:[[UIImage imageNamed:@"delete_img"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    
    [closeBtn addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    [examine addSubview:closeBtn];

}

-(void)close:(id)sender
{
    [self removeFromSuperview];
}

@end
