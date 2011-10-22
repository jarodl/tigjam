//
//  Environment.m
//  tigjam
//
//  Created by Jarod Luebbert on 10/21/11.
//  Copyright (c) 2011 MindSnacks. All rights reserved.
//

#import "Environment.h"
#import "SynthesizeSingleton.h"

@interface Environment ()
@property (nonatomic, assign) CGRect screenArea;
@property (nonatomic, assign) CGPoint screenCenter;
@end

@implementation Environment

@synthesize screenSize;
@synthesize screenArea;
@synthesize screenCenter;

+ (Environment *)sharedInstance
{
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc] init];
    });
}

- (id)init
{
    if ((self = [super init]))
    {
        self.screenSize = [[CCDirector sharedDirector] winSize];
    }
    
    return self;
}

- (void)setScreenSize:(CGSize)size
{
    screenSize = size;
	screenArea = CGRectMake(0, 0, screenSize.width, screenSize.height);
	screenCenter = ccp(screenSize.width/2, screenSize.height/2);
}

- (CGPoint)fromCenterX:(float)x y:(float)y
{
    return ccp(screenCenter.x + x, screenCenter.y + y);
}

- (CGPoint)fromBottomLeftX:(float)x y:(float)y
{
    return ccp(x, y);
}

- (CGPoint)fromBottomRightX:(float) x y:(float)y
{
    return ccp(screenSize.width - x, y);
}

- (CGPoint)fromTopLeftX:(float)x y:(float)y
{
    return ccp(x, screenSize.height - y);
}

- (CGPoint)fromTopRightX:(float)x y:(float)y
{
    return ccp(screenSize.width - x, screenSize.height - y);
}

- (CGPoint)fromTopMiddleX:(float)x y:(float)y
{
    return ccp(screenSize.width / 2 + x, screenSize.height - y);
}

- (CGPoint)fromBottomMiddleX:(float)x y:(float)y
{
    return ccp(screenSize.width / 2 + x, y);
}

- (CGPoint)fromLeftMiddleX:(float)x y:(float)y
{
    return ccp(x, screenSize.height / 2 + y);
}

- (CGPoint)fromRightMiddleX:(float)x y:(float)y
{
    return ccp(screenSize.width - x, screenSize.height / 2 + y);
}

@end
