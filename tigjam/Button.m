//
//  Button.m
//
//  Created by Karl Stenerud on 10-01-21.
//

#import "Button.h"
#import "CCNode+setContentSizeFromChildren.h"

@implementation Button

@synthesize touchablePortion;
@synthesize target;
@synthesize selector;
@synthesize downColor;
@synthesize normalColor;

+ (id) buttonWithSize:(CGSize)size target:(id)target selector:(SEL)selector
{
    CCNode *node = [CCNode node];
    node.contentSize = size;
    return [Button buttonWithTouchablePortion:node target:target selector:selector];
}

+ (id) buttonWithTouchablePortion:(CCNode*) node target:(id) target selector:(SEL) selector
{
	return [[self alloc] initWithTouchablePortion:node target:target selector:selector];
}

- (id) initWithTouchablePortion:(CCNode*) node target:(id) targetIn selector:(SEL) selectorIn
{
	if(nil != (self = [super init]))
	{
		self.touchablePortion = node;
		
		touchPriority = 0;
		targetedTouches = YES;
		swallowTouches = YES;
		isTouchEnabled = YES;
		
		target = targetIn;
		selector = selectorIn;
        
        if([touchablePortion conformsToProtocol:@protocol(CCRGBAProtocol)])
		{
			normalColor = ((id<CCRGBAProtocol>)touchablePortion).color;
            downColor = ccc3(220, 220, 220);
        }
		
		self.isRelativeAnchorPoint = YES;
		self.anchorPoint = ccp(0.5, 0.5);
	}
	return self;
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	if([self touch:touch hitsNode:touchablePortion])
	{
		touchInProgress = YES;
		buttonWasDown = YES;
		[self onButtonDown];
		return YES;
	}
	return NO;
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{	
	if(touchInProgress)
	{
		if([self touch:touch hitsNode:touchablePortion])
		{
			if(!buttonWasDown)
			{
				[self onButtonDown];
			}
		}
		else
		{
			if(buttonWasDown)
			{
				[self onButtonUp];
			}
		}
	}
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{	
	if(buttonWasDown)
	{
		[self onButtonUp];
	}
	if(touchInProgress && [self touch:touch hitsNode:touchablePortion])
	{
		touchInProgress = NO;
		[self onButtonPressed];
	}
}

-(void) ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
	if(buttonWasDown)
	{
		[self onButtonUp];
	}
	touchInProgress = NO;
}

- (void) onButtonDown
{
	buttonWasDown = YES;
    if([touchablePortion conformsToProtocol:@protocol(CCRGBAProtocol)])
    {
        [((id<CCRGBAProtocol>)touchablePortion) setColor:downColor];
    }
}

- (void) onButtonUp
{
	buttonWasDown = NO;
    if([touchablePortion conformsToProtocol:@protocol(CCRGBAProtocol)])
    {
        [((id<CCRGBAProtocol>)touchablePortion) setColor:normalColor];
    }
}

- (void) onButtonPressed
{
	[target performSelector:selector withObject:self];
}

- (GLubyte) opacity
{
	for(CCNode* child in self.children)
	{
		if([child conformsToProtocol:@protocol(CCRGBAProtocol)])
		{
			return ((id<CCRGBAProtocol>)child).opacity;
		}
	}
	return 255;
}

- (void) setOpacity:(GLubyte) value
{
	for(CCNode* child in self.children)
	{
		if([child conformsToProtocol:@protocol(CCRGBAProtocol)])
		{
			[(id<CCRGBAProtocol>)child setOpacity:value];
		}
	}
}

- (ccColor3B) color
{
	for(CCNode* child in self.children)
	{
		if([child conformsToProtocol:@protocol(CCRGBAProtocol)])
		{
			return ((id<CCRGBAProtocol>)child).color;
		}
	}
	return ccWHITE;
}

- (void) setColor:(ccColor3B) value
{
	for(CCNode* child in self.children)
	{
		if([child conformsToProtocol:@protocol(CCRGBAProtocol)])
		{
			[(id<CCRGBAProtocol>)child setColor:value];
		}
	}
}

- (void) setTouchablePortion:(CCNode *) value
{
	if(nil != touchablePortion)
	{
		[self removeChild:touchablePortion cleanup:YES];
	}
	if(nil != value)
	{
		touchablePortion = value;
		[self addChild:touchablePortion];
		touchablePortion.anchorPoint = ccp(0,0);
		touchablePortion.position = ccp(0,0);
		[self setContentSizeFromChildren];
	}
}

@end
