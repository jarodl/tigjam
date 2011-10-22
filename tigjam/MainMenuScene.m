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
#import "Button.h"
#import "GameScene.h"
#import "CloudLayer.h"

#define kUISpritesheetName @"UI"
#define kGameTitleSpriteFrameName @"game_title.png"
#define kPlayButtonFrameName @"play_button.png"
#define kSettingsButtonFrameName @"settings_button.png"
#define kBackgroundColor ccc4(177, 235, 255, 255)
#define kButtonMargin 15.0f

@interface MainMenuScene ()
@property (nonatomic, strong) Button *playButton;
@property (nonatomic, strong) Button *settingsButton;

- (void)startSettingsScene;
- (void)startGamingScene;
@end

@implementation MainMenuScene

@synthesize playButton;
@synthesize settingsButton;

+ (CCScene *)scene
{
    return [[self alloc] init];
}

- (id)init
{
    if ((self = [super init]))
    {
        [[ImageLoader sharedInstance] loadSpriteSheet:kUISpritesheetName];
        
        // background elements
        CCLayerColor *backgroundLayer = [CCLayerColor layerWithColor:kBackgroundColor];
        [self addChild:backgroundLayer];
        
        CloudLayer *clouds = [CloudLayer node];
        [self addChild:clouds];
        [clouds startAnimations];
        
        CCSprite *gameTitle = [CCSprite spriteWithSpriteFrameName:kGameTitleSpriteFrameName];
        gameTitle.position = [[Environment sharedInstance] fromTopMiddleX:0.0f y:100.0f];
        [self addChild:gameTitle];
        
        // UI
        CCSprite *settingsSprite = [CCSprite spriteWithSpriteFrameName:kSettingsButtonFrameName];
        self.settingsButton = [Button buttonWithTouchablePortion:settingsSprite target:self selector:@selector(startSettingsScene)];
        self.settingsButton.position = [[Environment sharedInstance] fromBottomMiddleX:0.0f y:75.0f];
        [self addChild:settingsButton];
        CCSprite *playSprite = [CCSprite spriteWithSpriteFrameName:kPlayButtonFrameName];
        self.playButton = [Button buttonWithTouchablePortion:playSprite target:self selector:@selector(startGamingScene)];
        self.playButton.position = ccpAdd(settingsButton.position, ccp(0.0f, settingsButton.contentSize.height + kButtonMargin));
        [self addChild:playButton];
    }
    
    return self;
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
    [[CCDirector sharedDirector] replaceScene:[GameScene new]];
}

#pragma mark -
#pragma mark Clean up


@end
