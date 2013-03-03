//
//  DisplayData.h
//  SmartTVGesture
//
//  Created by Lin Cooper on 13/2/26.
//  Copyright (c) 2013年 Lin Cooper. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DisplayData : NSObject{
    float degree;
    int selfId;
    UIColor* color;
    bool flagSelect;
    int selectSize;
}
-(id)initWithId:(int)i Degree:(float)d;
-(float)getDegree;
-(UIColor*)getColor;
-(void)setSelect:(bool)f;
-(bool)getSelect;
-(void)setSize:(int)s;
-(int)getSize;
@end