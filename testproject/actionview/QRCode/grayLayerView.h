//
//  grayLayerView.h
//  testproject
//
//  Created by bocom on 2018/3/5.
//  Copyright © 2018年 bestn1nja. All rights reserved.
//

#import <UIKit/UIKit.h>
#define MASK_COLOR [UIColor colorWithRed:1 green:1 blue:1 alpha:0.6]

@interface grayLayerView : UIView
@property(nonatomic) CGFloat finderscale;

-(id)initWidthScale:(CGFloat )scale;
@end
