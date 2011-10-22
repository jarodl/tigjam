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

#define kObjectsSpriteSheetName @"Objects"
#define kBackgroundColor ccc4(177, 235, 255, 255)
#define kWaveOffset 75.0f

@interface GameScene ()
@property (nonatomic, retain) FrontWaterLayer *frontWater;
@property (nonatomic, retain) WaterLayer *water;
@end

@implementation GameScene

@synthesize water;
@synthesize frontWater;

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
        
        CloudLayer *clouds = [CloudLayer node];
        [self addChild:clouds];
        [clouds startAnimations];
        
        self.water = [WaterLayer node];
        water.position = [[Environment sharedInstance] fromBottomLeftX:0.0f y:-(self.contentSize.height - kWaveOffset)];
        [self addChild:water];
        [water startAnimating];
        
        self.frontWater = [FrontWaterLayer node];
        self.frontWater.position = ccpSub([water frontWavePosition], ccp(0, self.contentSize.height - kWaveOffset));
        [self addChild:frontWater];
        
        [self scheduleUpdate];
    }
    
    return self;
}

- (void)dealloc
{
    self.water = nil;
    [super dealloc];
}

- (void)update:(ccTime)dt
{
    self.frontWater.position = ccpSub([water frontWavePosition], ccp(0, self.contentSize.height - kWaveOffset));
}

@end
