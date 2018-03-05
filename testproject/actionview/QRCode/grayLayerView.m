//
//  grayLayerView.m
//  testproject
//
//  Created by bocom on 2018/3/5.
//  Copyright © 2018年 bestn1nja. All rights reserved.
//

#import "grayLayerView.h"

@implementation grayLayerView

-(id)initWidthScale:(CGFloat )scale {
    self = [super init];
    if (self) {
        self.finderscale = scale;
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
//    [self setBackgroundColor:[UIColor whiteColor]];
    //分四块添加非取景框部分，直接和取景框宽度finderwidth建立关系，这样只需要调整finderwidth即可调整整个的取景框布局
    [super drawRect:rect];
    CGFloat finderwidth = rect.size.width*self.finderscale;
    CALayer *layertop = [[CALayer alloc] init];
    [layertop setBackgroundColor:MASK_COLOR.CGColor];
    [layertop setFrame:CGRectMake(0, 0, rect.size.width, (rect.size.height - finderwidth)/2)];
    
    CALayer *layerbottom = [[CALayer alloc] init];
    [layerbottom setBackgroundColor:MASK_COLOR.CGColor];
    [layerbottom setFrame:CGRectMake(0, (rect.size.height + finderwidth)/2, rect.size.width, (rect.size.height - finderwidth)/2)];
    
    CALayer *layerleft = [[CALayer alloc] init];
    [layerleft setFrame:CGRectMake(0, (rect.size.height - finderwidth)/2, (rect.size.width-finderwidth)/2, finderwidth)];
    [layerleft setBackgroundColor:MASK_COLOR.CGColor];
    
    CALayer *layerright = [[CALayer alloc] init];
    [layerright setFrame:CGRectMake((rect.size.width + finderwidth)/2, (rect.size.height - finderwidth)/2, (rect.size.width-finderwidth)/2, finderwidth)];
    [layerright setBackgroundColor:MASK_COLOR.CGColor];
    
    [self.layer addSublayer:layertop];
    [self.layer addSublayer:layerbottom];
    [self.layer addSublayer:layerleft];
    [self.layer addSublayer:layerright];
    
}


@end
