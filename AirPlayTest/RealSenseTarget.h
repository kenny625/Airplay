//
//  RealSenseTarget.h
//  AirPlayTest
//
//  Created by Lin Cooper on 13/3/4.
//  Copyright (c) 2013年 朱唯辰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DisplayData.h"

@interface RealSenseTarget : UIImageView{
    DisplayData* target;
    float pointDegree;
    float myDegree;
    bool flagSelect;
    int selectSize;
}
- (id)initWithTarget:(DisplayData*)t;
-(void)setDegree:(float)d;
-(float)getDegree;
-(void)setSize:(int)s;
-(int)getSize;
-(void)setSelect:(bool)f;
-(bool)getSelect;
-(NSUInteger)getTVID;
@end
