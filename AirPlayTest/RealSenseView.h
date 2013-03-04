//
//  RealSenseView.h
//  SmartTVGesture
//
//  Created by Lin Cooper on 13/2/26.
//  Copyright (c) 2013年 Lin Cooper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DisplayData.h"
#import "RealSenseTarget.h"
#import <MediaPlayer/MediaPlayer.h>
#import "MPAudioDeviceController.h"
@interface RealSenseView : UIView{
    Boolean flagShowing;
    CGPoint touchPoint;
    int targetCount;
    int targetWidth;
    NSMutableArray* targets;
    NSMutableArray* realSenseTargets;
    float pointDegree;
    MPAudioDeviceController* audoDeviceController;
}
- (id)initWithFrame:(CGRect)frame Target:(NSMutableArray*)t Controller:(MPAudioDeviceController *)c;
-(void)updateDegree:(float)d;
-(void)showOnTV;
@end
