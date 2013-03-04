//
//  RealSenseView.h
//  SmartTVGesture
//
//  Created by Lin Cooper on 13/2/26.
//  Copyright (c) 2013年 Lin Cooper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DisplayData.h"

@interface RealSenseView : UIView{
    Boolean flagShowing;
    CGPoint touchPoint;
    int targetCount;
    int targetWidth;
    NSMutableArray* targets;
    float pointDegree;
}
- (id)initWithFrame:(CGRect)frame Target:(NSMutableArray*)t;
-(void)updateDegree:(float)d;
@end
