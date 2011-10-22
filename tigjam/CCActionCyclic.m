//
//  CCActionCyclic.m
//  TestCycle
//
//  Created by Karl Stenerud on 9/14/11.
//  Copyright 2011 Mindsnacks. All rights reserved.
//

#import "CCActionCyclic.h"
#import <math.h>

@implementation CCActionCyclic

+ (CCActionCyclic*) actionWithAction:(CCActionInterval*) action
{
    return [[self alloc] initWithAction:action];
}

- (id) initWithAction:(CCActionInterval*) action
{
    return [self initWithPhaseShift:0.0f action:action];
}

+ (CCActionCyclic*) actionWithPhaseShift:(CGFloat) phaseShift action:(CCActionInterval*) action
{
    return [[self alloc] initWithPhaseShift:phaseShift action:action];
}

- (id) initWithPhaseShift:(CGFloat) phaseShift action:(CCActionInterval*) action
{
    if((self = [super initWithDuration:action.duration*2.0f]))
    {
        phaseShift_ = phaseShift;
        action_ = action;
        normalizedPhase_ = phaseShift / action.duration;
    }
    return self;
}

-(id) copyWithZone: (NSZone*) zone
{
	CCAction *copy = [[[self class] allocWithZone: zone] initWithAction:[action_ copy]];
	return copy;
}

- (void) startWithTarget:(id)target
{
    [super startWithTarget:target];
    if(!alreadyStarted_)
    {
        [action_ startWithTarget:target];
        alreadyStarted_ = YES;
    }
}

- (void) stop
{
    [super stop];
}

- (void) update:(ccTime)time
{
    ccTime subTime = time + normalizedPhase_;
    if(subTime > 1.0f)
    {
        subTime = 1.0f - (subTime - 1.0f);
    }
    
    subTime *= 2.0f;
    if(subTime > 1.0f)
    {
        subTime = 1.0f - (subTime - 1.0f);
    }
    else if(subTime == 1.0f)
    {
        subTime = 1.0f - FLT_EPSILON;
    }
    [action_ update:subTime];
}

@end
