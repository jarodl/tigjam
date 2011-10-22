//
//  CCActionCyclic.h
//  TestCycle
//
//  Created by Karl Stenerud on 9/14/11.
//  Copyright 2011 Mindsnacks. All rights reserved.
//

@interface CCActionCyclic : CCActionInterval
{
    CGFloat normalizedPhase_;
    CGFloat phaseShift_;
    CCActionInterval* action_;
    BOOL alreadyStarted_;
}

+ (CCActionCyclic*) actionWithAction:(CCActionInterval*) action;
- (id) initWithAction:(CCActionInterval*) action;
+ (CCActionCyclic*) actionWithPhaseShift:(CGFloat) phaseShift action:(CCActionInterval*) action;
- (id) initWithPhaseShift:(CGFloat) phaseShift action:(CCActionInterval*) action;

@end
