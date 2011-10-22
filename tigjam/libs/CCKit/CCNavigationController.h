//
//  CCNavigationController.h
//  Nuked
//
//  Created by Jerrod Putman on 8/12/11.
//  Copyright 2011 Tiny Tim Games. All rights reserved.
//

#import "cocos2d.h"

@class CCNavigationController;


// Enumeration for the styles of animation the navigation controller supports.
typedef enum
{
	CCNavigationControllerAnimationStyleNone,
	
	CCNavigationControllerAnimationStyleSlide,
	CCNavigationControllerAnimationStyleZoom,
	
	CCNavigationControllerAnimationStyleDefault = CCNavigationControllerAnimationStyleSlide,
	
} CCNavigationControllerAnimationStyle;


// Constant for the default animation duration.
extern const float CCNavigationControllerAnimationDurationDefault;


// Protocol for a delegate that responds to navigation controller events.
@protocol CCNavigationControllerDelegate <NSObject>

@optional

// Called when a navigation controller is about to show a new node (before animation).
- (void)navigationController:(CCNavigationController *)navigationController willShowNode:(CCNode *)node animated:(BOOL)animated;

// Called when a navigation controller has finished showing a node (after animation).
- (void)navigationController:(CCNavigationController *)navigationController didShowNode:(CCNode *)node animated:(BOOL)animated;

@end


#pragma mark -


@interface CCNavigationController : CCLayer

#pragma mark - Creating a navigation controller

// Initializes and returns a newly created navigation controller.
- (id)initWithRootNode:(CCNode *)node;


#pragma mark - Modifying the navigation controller animations

// Sets the animation type when pushing and popping between nodes.
@property (nonatomic, assign) CCNavigationControllerAnimationStyle animationStyle;

// The duration of push and pop animations.
@property (nonatomic, assign) float animationDuration;


#pragma mark - Accessing items on the navigation stack

// The node at the top of the navigation stack. This is also the current visible node.
@property (nonatomic, readonly) CCNode *topNode;

// All of the nodes in the navigation stack, from bottom to top.
@property (nonatomic, copy) NSArray *nodes;

// Allows explicitly setting the nodes of the navigation stack, with the ability to perform a transition animation.
- (void)setNodes:(NSArray *)nodes animated:(BOOL)animated;


#pragma mark - Pushing and popping stack items

// Pushes a node onto the stack, with or without animation.
- (void)pushNode:(CCNode *)node animated:(BOOL)animated;

// Pops the current top node from the stack, with or without animation.
- (CCNode *)popNodeAnimated:(BOOL)animated;

// Pops to the root node of the stack, with or without animation.
- (NSArray *)popToRootAnimated:(BOOL)animated;

// Pops to a specific node on the stack, with or without animation.
- (NSArray *)popToNode:(CCNode *)node animated:(BOOL)animated;


#pragma mark - Accessing the delegate

// A delegate which allows objects to respond to navigation controller events.
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_5_0
@property (nonatomic, weak) id<CCNavigationControllerDelegate> delegate;
#else
@property (nonatomic, assign) id<CCNavigationControllerDelegate> delegate;
#endif


@end


#pragma mark -


@interface CCNode (NavigationControllerAdditions)

// A convenience property for accessing the navigation controller of a node.
@property (nonatomic, readonly) CCNavigationController *navigationController;


@end

