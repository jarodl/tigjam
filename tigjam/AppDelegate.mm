//
//  AppDelegate.m
//  tigjam
//
//  Created by Jarod Luebbert on 10/14/11.
//  Copyright MindSnacks 2011. All rights reserved.
//

#import "AppDelegate.h"
#import "MainMenuScene.h"
#import "RootViewController.h"
#import "Environment.h"
#import "ImageLoader.h"

#define kTestFlightToken @"b4ce235c6239b040dc81faa44ad4ad2c_MzQ2NjUyMDExLTEwLTE0IDIyOjA4OjE0LjEyMTg2Nw"
#define kEnvironmentSpritesheetName @"Environment"

@implementation AppDelegate

@synthesize window;

- (void) removeStartupFlicker
{
	CC_ENABLE_DEFAULT_GL_STATES();
	CCDirector *director = [CCDirector sharedDirector];
	CGSize size = [director winSize];
	CCSprite *sprite = [CCSprite spriteWithFile:@"Default.png"];
	sprite.position = ccp(size.width/2, size.height/2);
	sprite.rotation = -90;
	[sprite visit];
	[[director openGLView] swapBuffers];
	CC_ENABLE_DEFAULT_GL_STATES();
}

- (void) applicationDidFinishLaunching:(UIApplication*)application
{
    [TestFlight takeOff:kTestFlightToken];
	// Init the window
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	// Try to use CADisplayLink director
	// if it fails (SDK < 3.1) use the default director
	if( ! [CCDirector setDirectorType:kCCDirectorTypeDisplayLink] )
		[CCDirector setDirectorType:kCCDirectorTypeDefault];
	
	
	CCDirector *director = [CCDirector sharedDirector];
	
	// Init the View Controller
	viewController = [[RootViewController alloc] initWithNibName:nil bundle:nil];
	viewController.wantsFullScreenLayout = YES;
	
	//
	// Create the EAGLView manually
	//  1. Create a RGB565 format. Alternative: RGBA8
	//	2. depth format of 0 bit. Use 16 or 24 bit for 3d effects, like CCPageTurnTransition
	//
	//
	EAGLView *glView = [EAGLView viewWithFrame:[window bounds]
								   pixelFormat:kEAGLColorFormatRGBA8	// kEAGLColorFormatRGBA8
								   depthFormat:0						// GL_DEPTH_COMPONENT16_OES
						];
	
	// attach the openglView to the director
	[director setOpenGLView:glView];
	
	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
	if (![director enableRetinaDisplay:YES])
		CCLOG(@"Retina Display Not supported");
    
	[director setDeviceOrientation:kCCDeviceOrientationPortrait];
	[director setAnimationInterval:1.0/60];
	[director setDisplayFPS:YES];
	
	// make the OpenGLView a child of the view controller
	[viewController setView:glView];
	
	// make the View Controller a child of the main window
	[window addSubview: viewController.view];
	
	[window makeKeyAndVisible];
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
    
	// Removes the startup flicker
	[self removeStartupFlicker];
    
    [[ImageLoader sharedInstance] loadSpriteSheet:kEnvironmentSpritesheetName];
	
	// Run the intro Scene
	[[CCDirector sharedDirector] runWithScene:[MainMenuScene new]];
    
    [TestFlight passCheckpoint:@"Application did finish launching"];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	[[CCDirector sharedDirector] pause];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	[[CCDirector sharedDirector] resume];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	[[CCDirector sharedDirector] purgeCachedData];
}

-(void) applicationDidEnterBackground:(UIApplication*)application
{
	[[CCDirector sharedDirector] stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application
{
	[[CCDirector sharedDirector] startAnimation];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	CCDirector *director = [CCDirector sharedDirector];
	
	[[director openGLView] removeFromSuperview];
	
	
	
	[director end];
    [TestFlight passCheckpoint:@"Application was terminated"];
}

- (void)applicationSignificantTimeChange:(UIApplication *)application
{
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void)dealloc
{
	[[CCDirector sharedDirector] end];
}

@end
