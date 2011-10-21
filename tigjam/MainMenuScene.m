//
//  MainMenuScene.m
//  tigjam
//
//  Created by Jarod Luebbert on 10/21/11.
//  Copyright (c) 2011 MindSnacks. All rights reserved.
//

#import "MainMenuScene.h"
#import "ImageLoader.h"
#import "Environment.h"
#import "RNG.h"
#import "Button.h"

#define kEnvironmentSpritesheetName @"Environment"
#define kUISpritesheetName @"UI"
#define kCloudFrameNameFormat @"cloud_%d.png"
#define kGameTitleSpriteFrameName @"game_title.png"
#define kPlayButtonFrameName @"play_button.png"
#define kSettingsButtonFrameNaem @"settings_button.png"
#define kBackgroundColor ccc4(177, 235, 255, 255)
#define kNumberOfClouds 5
#define kButtonMargin 15.0f

@interface MainMenuScene ()
@property (nonatomic, retain) NSMutableArray *clouds;
@property (nonatomic, retain) Button *playButton;
@property (nonatomic, retain) Button *settingsButton;

- (CCFiniteTimeAction *)movingCloudAction;
- (void)startCloudAnimations;
- (void)startSettingsScene;
- (void)startGamingScene;
@end

@implementation MainMenuScene

@synthesize clouds;
@synthesize playButton;
@synthesize settingsButton;

+ (CCScene *)scene
{
    return [[[self alloc] init] autorelease];
}

- (id)init
{
    if ((self = [super init]))
    {
        [[ImageLoader sharedInstance] loadSpriteSheet:kEnvironmentSpritesheetName];
        [[ImageLoader sharedInstance] loadSpriteSheet:kUISpritesheetName];

        // background elements
        CCLayerColor *backgroundLayer = [CCLayerColor layerWithColor:kBackgroundColor];
        [self addChild:backgroundLayer];
        
        NSArray *cloudPositions = [NSArray arrayWithObjects:
                                   [NSValue valueWithCGPoint:[[Environment sharedInstance] fromTopLeftX:75.0f y:25.0f]],
                                   [NSValue valueWithCGPoint:[[Environment sharedInstance] fromTopRightX:35.0f y:100.0f]],
                                   [NSValue valueWithCGPoint:[[Environment sharedInstance] fromTopLeftX:25.0f y:50.0f]],
                                   [NSValue valueWithCGPoint:[[Environment sharedInstance] fromTopRightX:50.0f y:75.0f]],
                                   [NSValue valueWithCGPoint:[[Environment sharedInstance] fromTopMiddleX:10.0f y:125.0f]],
                                   nil];
        self.clouds = [NSMutableArray arrayWithCapacity:kNumberOfClouds];
        for (int i = 0; i < kNumberOfClouds; i++)
        {
            NSString *frameName = [NSString stringWithFormat:kCloudFrameNameFormat, i];
            CCSprite *cloud = [CCSprite spriteWithSpriteFrameName:frameName];
            NSValue *position = [cloudPositions objectAtIndex:i];
            cloud.position = [position CGPointValue];
            cloud.opacity = 0;
            [self.clouds addObject:cloud];
            [self addChild:cloud];
        }
        
        CCSprite *gameTitle = [CCSprite spriteWithSpriteFrameName:kGameTitleSpriteFrameName];
        gameTitle.position = [[Environment sharedInstance] fromTopMiddleX:0.0f y:100.0f];
        [self addChild:gameTitle];
        
        // UI
        CCSprite *settingsSprite = [CCSprite spriteWithSpriteFrameName:kSettingsButtonFrameNaem];
        self.settingsButton = [Button buttonWithTouchablePortion:settingsSprite target:self selector:@selector(startSettingsScene)];
        self.settingsButton.position = [[Environment sharedInstance] fromBottomMiddleX:0.0f y:75.0f];
        [self addChild:settingsButton];
        CCSprite *playSprite = [CCSprite spriteWithSpriteFrameName:kPlayButtonFrameName];
        self.playButton = [Button buttonWithTouchablePortion:playSprite target:self selector:@selector(startGamingScene)];
        self.playButton.position = ccpAdd(settingsButton.position, ccp(0.0f, settingsButton.contentSize.height + kButtonMargin));
        [self addChild:playButton];
        
        [self startCloudAnimations];
    }
    
    return self;
}

#pragma mark -
#pragma mark Cloud actions

- (void)startCloudAnimations
{
    for (CCSprite *cloud in clouds)
    {
        [cloud runAction:[CCFadeIn actionWithDuration:5.0f]];
        [cloud runAction:[self movingCloudAction]];
    }
}

- (CCFiniteTimeAction *)movingCloudAction
{
    float duration = [[RNG sharedInstance] randomFloatFrom:20.0f to:35.0f];
    float direction = ([[RNG sharedInstance] randomBool]) ? 1.0f : -1.0f;
    return [CCRepeatForever actionWithAction:[CCSequence actions:
                                              [CCMoveBy actionWithDuration:duration
                                                                  position:ccp(direction * self.contentSize.width, 0)],
                                              [CCDelayTime actionWithDuration:[[RNG sharedInstance] randomFloatFrom:1.0f to:3.0f]],
                                              [CCMoveBy actionWithDuration:duration
                                                                  position:ccp(-1 * direction * self.contentSize.width, 0)],
                                              [CCDelayTime actionWithDuration:[[RNG sharedInstance] randomFloatFrom:1.0f to:3.0f]],
                                              nil]];
}

#pragma mark -
#pragma mark Button actions

- (void)startSettingsScene
{
    [TestFlight passCheckpoint:@"Tapped settings button"];
}

- (void)startGamingScene
{
    [TestFlight passCheckpoint:@"Tapped play button"];
}

#pragma mark -
#pragma mark Clean up

- (void)dealloc
{
    self.clouds = nil;
    self.playButton = nil;
    self.settingsButton = nil;
    [super dealloc];
}

@end
