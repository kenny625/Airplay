//
//  DisplayData.m
//  SmartTVGesture
//
//  Created by Lin Cooper on 13/2/26.
//  Copyright (c) 2013年 Lin Cooper. All rights reserved.
//

#import "DisplayData.h"

@implementation DisplayData
-(id)initWithId:(int) i Degree:(float)d{
    self=[super init];
    selfId=i;
    switch (selfId) {
        case 0:
            color=[UIColor colorWithRed:221/255.f green:166/255.f blue:40/255.f alpha:1];
            break;

        case 1:
            color=[UIColor colorWithRed:155/255.f green:186/255.f blue:59/255.f alpha:1];
            break;

        case 2:
            color=[UIColor colorWithRed:91/255.f green:182/255.f blue:185/255.f alpha:1];
            break;
    }
    degree=d;
    return self;
}
-(float)getDegree{
    return degree;
}
-(UIColor*)getColor{
return color;
}
-(void)setSelect:(bool)f{
    flagSelect=f;
}
-(bool)getSelect{
    return flagSelect;
}
-(void)setSize:(int)s{
    selectSize=s;
}
-(int)getSize{
    return selectSize;
}
@end
