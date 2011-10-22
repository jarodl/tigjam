//
//  CCMoveHorizVert.m
//  MindSnacks
//
//  Created by Jarod L on 9/13/11.
//  Copyright 2011 MindSnacks. All rights reserved.
//

#import "CCMoveHorizVert.h"

//
// MoveHorizontalTo
//
#pragma mark -
#pragma mark MoveHorizontalTo

@implementation CCMoveHorizontalTo
+(id) actionWithDuration:(ccTime)t horizontalPosition:(CGFloat)p
{	
	return [[self alloc] initWithDuration:t horizontalPosition:p ];
}

-(id) initWithDuration: (ccTime) t horizontalPosition:(CGFloat) p
{
	if( (self=[super initWithDuration: t]) )
		endX = p;
	
	return self;
}

-(id) copyWithZone: (NSZone*) zone
{
	CCAction *copy = [[[self class] allocWithZone: zone] initWithDuration: [self duration] horizontalPosition: endX];
	return copy;
}

-(void) startWithTarget:(CCNode *)aTarget
{
	[super startWithTarget:aTarget];
	startX = [(CCNode*)target_ position].x;
	delta = endX - startX;
}

-(void) update: (ccTime) t
{	
	[target_ setPosition: ccp( (startX + delta * t ), [target_ position].y )];
}
@end

//
// MoveHorizontalBy
//
#pragma mark -
#pragma mark MoveHorizontalBy

@implementation CCMoveHorizontalBy
+(id) actionWithDuration: (ccTime) t horizontalPosition:(CGFloat) p
{	
	return [[self alloc] initWithDuration:t horizontalPosition:p ];
}

-(id) initWithDuration: (ccTime) t horizontalPosition:(CGFloat) p
{
	if( (self=[super initWithDuration: t]) )
		delta = p;
	
	return self;
}

-(id) copyWithZone: (NSZone*) zone
{
	CCAction *copy = [[[self class] allocWithZone: zone] initWithDuration: [self duration] horizontalPosition: delta];
	return copy;
}

-(void) startWithTarget:(CCNode *)aTarget
{
	CGFloat dTmp = delta;
	[super startWithTarget:aTarget];
	delta = dTmp;
}

-(CCActionInterval*) reverse
{
	return [[self class] actionWithDuration:duration_ horizontalPosition:-delta];
}
@end



//
// MoveVerticalTo
//
#pragma mark -
#pragma mark MoveVerticalTo

@implementation CCMoveVerticalTo
+(id) actionWithDuration:(ccTime)t verticalPosition:(CGFloat)p
{	
	return [[self alloc] initWithDuration:t verticalPosition:p ];
}

-(id) initWithDuration: (ccTime) t verticalPosition:(CGFloat) p
{
	if( (self=[super initWithDuration: t]) )
		endY = p;
	
	return self;
}

-(id) copyWithZone: (NSZone*) zone
{
	CCAction *copy = [[[self class] allocWithZone: zone] initWithDuration: [self duration] verticalPosition: endY];
	return copy;
}

-(void) startWithTarget:(CCNode *)aTarget
{
	[super startWithTarget:aTarget];
	startY = [(CCNode*)target_ position].y;
	delta = endY - startY;
}

-(void) update: (ccTime) t
{	
	[target_ setPosition: ccp( [target_ position].x, (startY + delta * t ) )];
}
@end

//
// MoveVerticalBy
//
#pragma mark -
#pragma mark MoveVerticalBy

@implementation CCMoveVerticalBy
+(id) actionWithDuration: (ccTime) t verticalPosition:(CGFloat) p
{	
	return [[self alloc] initWithDuration:t verticalPosition:p ];
}

-(id) initWithDuration: (ccTime) t verticalPosition:(CGFloat) p
{
	if( (self=[super initWithDuration: t]) )
		delta = p;
	
	return self;
}

-(id) copyWithZone: (NSZone*) zone
{
	CCAction *copy = [[[self class] allocWithZone: zone] initWithDuration: [self duration] verticalPosition: delta];
	return copy;
}

-(void) startWithTarget:(CCNode *)aTarget
{
	CGFloat dTmp = delta;
	[super startWithTarget:aTarget];
	delta = dTmp;
}

-(CCActionInterval*) reverse
{
	return [[self class] actionWithDuration:duration_ verticalPosition:-delta];
}
@end
