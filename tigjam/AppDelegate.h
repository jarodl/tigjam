//
//  AppDelegate.h
//  tigjam
//
//  Created by Jarod Luebbert on 10/14/11.
//  Copyright MindSnacks 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate>
{
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
