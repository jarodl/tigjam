//
//  GameScene.m
//  tigjam
//
//  Created by Jarod Luebbert on 10/19/11.
//  Copyright (c) 2011 MindSnacks. All rights reserved.
//

#import "GameScene.h"
#import "ImageLoader.h"
#import "CloudLayer.h"
#import "WaterLayer.h"
#import "Environment.h"
//#import "CCGestureRecognizer.h"

#define kObjectsSpriteSheetName @"Objects"
#define kBackgroundColor ccc4(177, 235, 255, 255)
#define kWaveOffset 75.0f

@interface GameScene ()
@property (nonatomic, retain) FrontWaterLayer *frontWater;
@property (nonatomic, retain) WaterLayer *water;
@property (nonatomic, retain) CloudLayer *clouds;
//@property (nonatomic, retain) CCGestureRecognizer *gestureRecognizer;

- (void)handleTapGesture;
@end

@implementation GameScene

@synthesize water;
@synthesize frontWater;
@synthesize clouds;
//@synthesize gestureRecognizer;

#pragma mark -
#pragma mark Set up

+ (CCScene *)scene
{
    return [[[self alloc] init] autorelease];
}

- (id)init
{
    if ((self = [super init]))
    {
        [[ImageLoader sharedInstance] loadSpriteSheet:kObjectsSpriteSheetName];
        CCLayerColor *backgroundLayer = [CCLayerColor layerWithColor:kBackgroundColor];
        [self addChild:backgroundLayer];
        
        self.clouds = [CloudLayer node];
        [self addChild:clouds];
        
        self.water = [WaterLayer node];
        water.position = [[Environment sharedInstance] fromBottomLeftX:0.0f y:-(self.contentSize.height - kWaveOffset)];
        [self addChild:water];
        
        self.frontWater = [FrontWaterLayer node];
        self.frontWater.position = ccpSub([water frontWavePosition], ccp(0, self.contentSize.height - kWaveOffset));
        [self addChild:frontWater];
        
//        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] init];
//        self.gestureRecognizer = [CCGestureRecognizer recognizerWithRecognizer:tapGestureRecognizer
//                                                                        target:self
//                                                                        action:@selector(handleTapGesture)];
//        [tapGestureRecognizer release];
//        [self addGestureRecognizer:gestureRecognizer];
    }
    
    return self;
}

#pragma mark -
#pragma mark Clean up

- (void)onExit
{
    [super onExit];
//    [self removeGestureRecognizer:gestureRecognizer];
}

- (void)dealloc
{
    self.clouds = nil;
    self.water = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark Update

- (void)onEnterTransitionDidFinish
{
    [super onEnterTransitionDidFinish];
    [water startAnimating];
    [clouds startAnimations];
    [self scheduleUpdate];
}

- (void)update:(ccTime)dt
{
    self.frontWater.position = ccpSub([water frontWavePosition], ccp(0, self.contentSize.height - kWaveOffset));
}

#pragma mark -
#pragma mark Handle touch events

- (void)handleTapGesture
{
    NSLog(@"Received tap gesture");
}

@end
