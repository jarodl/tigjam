//
//  CCNavigationController.m
//  Nuked
//
//  Created by Jerrod Putman on 8/12/11.
//  Copyright 2011 Tiny Tim Games. All rights reserved.
//

#import "CCNavigationController.h"


#define kSlideAnimationOffset 300.0f
#define kZoomAnimationOffset 0.5f

const float CCNavigationControllerAnimationDurationDefault = 0.35f;

typedef enum
{
	CCNavigationControllerAnimationDirectionPush,
	CCNavigationControllerAnimationDirectionPop,
	
} CCNavigationControllerAnimationDirection;





@implementation CCNavigationController
{
	NSMutableArray *nodeStack;
}

@synthesize animationStyle;
@synthesize animationDuration;
@synthesize delegate;


#pragma mark - Private

- (void)slideAnimationWithDirection:(CCNavigationControllerAnimationDirection)direction incomingNode:(CCNode *)incomingNode outgoingNode:(CCNode *)outgoingNode
{
	CGPoint moveByPosition = (direction == CCNavigationControllerAnimationDirectionPush) ? ccp(-kSlideAnimationOffset, 0) : ccp(kSlideAnimationOffset, 0);
	CGPoint incomingInitialPosition = ccpAdd(incomingNode.position, (direction == CCNavigationControllerAnimationDirectionPush) ? ccp(kSlideAnimationOffset, 0) : ccp(-kSlideAnimationOffset, 0));
	
	if(outgoingNode != nil)
	{
		CCRenderTexture *outgoingTex = [CCRenderTexture renderTextureWithWidth:outgoingNode.contentSize.width height:outgoingNode.contentSize.height];
		[outgoingTex begin];
		[outgoingNode visit];
		[outgoingTex end];

		outgoingTex.position = outgoingNode.position;
		[outgoingTex.sprite setOpacityModifyRGB:YES];
		outgoingTex.sprite.opacity = 255;

		[self addChild:outgoingTex];
		[outgoingNode removeFromParentAndCleanup:(direction == CCNavigationControllerAnimationDirectionPop)];
		
		[outgoingTex.sprite runAction:
		 [CCSequence actions:
		  [CCSpawn actions:
		   [CCEaseSineInOut actionWithAction:[CCMoveBy actionWithDuration:animationDuration position:moveByPosition]],
		   [CCFadeTo actionWithDuration:animationDuration opacity:0],
		   nil],
		  [CCCallBlock actionWithBlock:^{
			 [outgoingTex removeFromParentAndCleanup:YES];
		   }],
		  nil]
		 ];
	}
	
	CCRenderTexture *incomingTex = [CCRenderTexture renderTextureWithWidth:incomingNode.contentSize.width height:incomingNode.contentSize.height];
	[incomingTex begin];
	[incomingNode visit];
	[incomingTex end];

	incomingTex.position = incomingInitialPosition;
	[incomingTex.sprite setOpacityModifyRGB:YES];
	incomingTex.sprite.opacity = 0;
	
	[self addChild:incomingTex];

	[incomingTex.sprite runAction:
	 [CCSequence actions:
	  [CCSpawn actions:
	   [CCEaseSineInOut actionWithAction:[CCMoveBy actionWithDuration:animationDuration position:moveByPosition]],
	   [CCFadeTo actionWithDuration:animationDuration opacity:255],
	   nil],
	  [CCCallBlock actionWithBlock:^{
		 [incomingTex removeFromParentAndCleanup:YES];
		 [self addChild:incomingNode];
		 
		 if(delegate != nil
			&& [delegate respondsToSelector:@selector(navigationController:didShowNode:animated:)])
			 [delegate navigationController:self didShowNode:incomingNode animated:YES];
	   }],
	  nil]
	 ];
}


- (void)zoomAnimationWithDirection:(CCNavigationControllerAnimationDirection)direction incomingNode:(CCNode *)incomingNode outgoingNode:(CCNode *)outgoingNode
{
	float outgoingFinalScale = (direction == CCNavigationControllerAnimationDirectionPush) ? 2.0f : 0.5f;
	float incomingInitialScale = ((direction == CCNavigationControllerAnimationDirectionPush) ? 0.5f : 2.0f);
	float incomingFinalScale = ((direction == CCNavigationControllerAnimationDirectionPush) ? 2.0f : 0.5f);
	
	if(outgoingNode != nil)
	{
		CCRenderTexture *outgoingTex = [CCRenderTexture renderTextureWithWidth:outgoingNode.contentSize.width height:outgoingNode.contentSize.height];
		[outgoingTex begin];
		[outgoingNode visit];
		[outgoingTex end];
		
		outgoingTex.anchorPoint = CGPointZero;
		outgoingTex.position = outgoingNode.position;
		[outgoingTex.sprite setOpacityModifyRGB:YES];
		outgoingTex.sprite.opacity = 255;
		
		[self addChild:outgoingTex];
		[outgoingNode removeFromParentAndCleanup:(direction == CCNavigationControllerAnimationDirectionPop)];
		
		[outgoingTex.sprite runAction:
		 [CCSequence actions:
		  [CCSpawn actions:
		   [CCEaseSineInOut actionWithAction:[CCScaleTo actionWithDuration:animationDuration scaleX:outgoingFinalScale scaleY:-outgoingFinalScale]],
		   [CCFadeTo actionWithDuration:animationDuration opacity:0],
		   nil],
		  [CCCallBlock actionWithBlock:^{
			 [outgoingTex removeFromParentAndCleanup:YES];
		   }],
		  nil]
		 ];
	}
	
	CCRenderTexture *incomingTex = [CCRenderTexture renderTextureWithWidth:incomingNode.contentSize.width height:incomingNode.contentSize.height];
	[incomingTex begin];
	[incomingNode visit];
	[incomingTex end];

	incomingTex.anchorPoint = CGPointZero;
	incomingTex.position = incomingNode.position;
	incomingTex.scaleX = incomingInitialScale;
	incomingTex.scaleY = incomingInitialScale;
	[incomingTex.sprite setOpacityModifyRGB:YES];
	incomingTex.sprite.opacity = 0;
	
	[self addChild:incomingTex];
	
	[incomingTex.sprite runAction:
	 [CCSequence actions:
	  [CCSpawn actions:
	   [CCEaseSineInOut actionWithAction:[CCScaleTo actionWithDuration:animationDuration scaleX:incomingFinalScale scaleY:-incomingFinalScale]],
	   [CCFadeTo actionWithDuration:animationDuration opacity:255],
	   nil],
	  [CCCallBlock actionWithBlock:^{
		 [self addChild:incomingNode];
		 [incomingTex removeFromParentAndCleanup:YES];
		 
		 if(delegate != nil
			&& [delegate respondsToSelector:@selector(navigationController:didShowNode:animated:)])
			 [delegate navigationController:self didShowNode:incomingNode animated:YES];
	   }],
	  nil
	  ]
	 ];
}


- (void)playTransitionAnimationWithDirection:(CCNavigationControllerAnimationDirection)direction incomingNode:(CCNode *)incomingNode outgoingNode:(CCNode *)outgoingNode
{
	if(delegate != nil
	   && [delegate respondsToSelector:@selector(navigationController:willShowNode:animated:)])
		[delegate navigationController:self willShowNode:incomingNode animated:YES];
	
	switch(animationStyle)
	{
		case CCNavigationControllerAnimationStyleSlide:
			[self slideAnimationWithDirection:direction incomingNode:incomingNode outgoingNode:outgoingNode];
			break;
			
		case CCNavigationControllerAnimationStyleZoom:
			[self zoomAnimationWithDirection:direction incomingNode:incomingNode outgoingNode:outgoingNode];
			break;

		default:
			if(delegate != nil
			   && [delegate respondsToSelector:@selector(navigationController:willShowNode:animated:)])
				[delegate navigationController:self willShowNode:incomingNode animated:NO];
			break;
	}
}


#pragma mark - Creating the navigation controller

- (id)initWithRootNode:(CCNode *)node
{
	if((self = [super init]))
	{
		nodeStack = [[NSMutableArray alloc] initWithCapacity:3];
		
		animationStyle = CCNavigationControllerAnimationStyleDefault;
		animationDuration = CCNavigationControllerAnimationDurationDefault;
		
		[self pushNode:node animated:NO];
	}
	
	return self;
}


#pragma mark - Accessing items on the navigation stack

- (CCNode *)topNode
{
	return [nodeStack lastObject];
}


- (NSArray *)nodes
{
	return [NSArray arrayWithArray:nodeStack];
}


- (void)setNodes:(NSArray *)nodes
{
	[self setNodes:nodes animated:NO];
}


- (void)setNodes:(NSArray *)nodes animated:(BOOL)animated
{
	CCNode *oldTop = self.topNode;
	CCNode *newTop = [nodes lastObject];
	
	// Determine the proper direction of the transition.
	CCNavigationControllerAnimationDirection animationDirection = CCNavigationControllerAnimationDirectionPush;
	if(animated
	   && [nodeStack containsObject:newTop])
		animationDirection = CCNavigationControllerAnimationDirectionPop;
	
	nodeStack = [NSMutableArray arrayWithArray:nodes];
	
	if(animated)
	{
		[self playTransitionAnimationWithDirection:animationDirection incomingNode:newTop outgoingNode:oldTop];
	}
	else
	{
		if(delegate != nil
		   && [delegate respondsToSelector:@selector(navigationController:willShowNode:animated:)])
			[delegate navigationController:self willShowNode:newTop animated:animated];
		
		if(oldTop != nil)
			[oldTop removeFromParentAndCleanup:![nodeStack containsObject:oldTop]];
		
		[self addChild:newTop];

		if(delegate != nil
		   && [delegate respondsToSelector:@selector(navigationController:willShowNode:animated:)])
			[delegate navigationController:self didShowNode:newTop animated:NO];
	}
}


#pragma mark - Pushing and popping stack items

- (void)pushNode:(CCNode *)node animated:(BOOL)animated
{
	CCNode *oldTop = self.topNode;
	CCNode *newTop = node;
	
	[nodeStack addObject:newTop];
	
	if(animated)
		[self playTransitionAnimationWithDirection:CCNavigationControllerAnimationDirectionPush incomingNode:newTop outgoingNode:oldTop];
	else
		self.nodes = nodeStack;
}


- (CCNode *)popNodeAnimated:(BOOL)animated
{
	if([nodeStack count] <= 1)
		return nil;
	
	CCNode *oldTop = self.topNode;
	[nodeStack removeLastObject];
	CCNode *newTop = self.topNode;
	
	if(animated)
		[self playTransitionAnimationWithDirection:CCNavigationControllerAnimationDirectionPop incomingNode:newTop outgoingNode:oldTop];
	else
		self.nodes = nodeStack;
	
	return oldTop;
}


- (NSArray *)popToRootAnimated:(BOOL)animated
{
	CCNode *oldTop = self.topNode;
	CCNode *newTop = [nodeStack objectAtIndex:0];
	
	if(oldTop == newTop)
		return nil;
	
	NSMutableArray *oldArray = nodeStack;
	[oldArray removeObjectAtIndex:0];
	
	nodeStack = [NSMutableArray arrayWithObject:newTop];
	
	if(animated)
		[self playTransitionAnimationWithDirection:CCNavigationControllerAnimationDirectionPop incomingNode:newTop outgoingNode:oldTop];
	else
		self.nodes = nodeStack;
	
	return [NSArray arrayWithArray:oldArray];
}


- (NSArray *)popToNode:(CCNode *)node animated:(BOOL)animated
{
	if(![nodeStack containsObject:node]
	   || [nodeStack count] <= 1)
		return nil;
	
	NSInteger oldTopIndex = [nodeStack indexOfObject:node];
	NSInteger newTopIndex = oldTopIndex - 1;
	
	CCNode *oldTop = node;
	CCNode *newTop = [nodeStack objectAtIndex:newTopIndex];
	
	if(oldTop == newTop)
		return nil;
	
	NSRange range = { oldTopIndex, [nodeStack count] - oldTopIndex };
	NSArray *removedArray = [nodeStack subarrayWithRange:range];
	[nodeStack removeObjectsInRange:range];
	
	if(animated)
		[self playTransitionAnimationWithDirection:CCNavigationControllerAnimationDirectionPop incomingNode:newTop outgoingNode:oldTop];
	else
		self.nodes = nodeStack;
	
	return removedArray;
}


@end


#pragma mark -


@implementation CCNode (NavigationControllerAdditions)

- (CCNavigationController *)navigationController
{
	if([self.parent isKindOfClass:[CCNavigationController class]])
		return (CCNavigationController *)self.parent;
	
	return nil;
}

@end

