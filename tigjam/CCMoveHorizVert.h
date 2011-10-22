//
//  CCMoveHorizVert.h
//  MindSnacks
//
//  Created by Jarod L on 9/13/11.
//  Copyright 2011 MindSnacks. All rights reserved.
//

#import "cocos2d.h"

/** Moves a CCNode object to the position x,y. x and y are absolute coordinates by modifying it's position attribute.
 */
@interface CCMoveHorizontalTo : CCActionInterval <NSCopying>
{
	CGFloat endX;
	CGFloat startX;
	CGFloat delta;
}
/** creates the action */
+(id) actionWithDuration:(ccTime)duration horizontalPosition:(CGFloat)position;
/** initializes the action */
-(id) initWithDuration:(ccTime)duration horizontalPosition:(CGFloat)position;
@end

/**  Moves a CCNode object x,y pixels by modifying it's position attribute.
 x and y are relative to the position of the object.
 Duration is is seconds.
 */ 
@interface CCMoveHorizontalBy : CCMoveHorizontalTo <NSCopying>
{
}
/** creates the action */
+(id) actionWithDuration: (ccTime)duration horizontalPosition:(CGFloat)deltaPosition;
/** initializes the action */
-(id) initWithDuration: (ccTime)duration horizontalPosition:(CGFloat)deltaPosition;
@end


/** Moves a CCNode object to the position x,y. x and y are absolute coordinates by modifying it's position attribute.
 */
@interface CCMoveVerticalTo : CCActionInterval <NSCopying>
{
	CGFloat endY;
	CGFloat startY;
	CGFloat delta;
}
/** creates the action */
+(id) actionWithDuration:(ccTime)duration verticalPosition:(CGFloat)position;
/** initializes the action */
-(id) initWithDuration:(ccTime)duration verticalPosition:(CGFloat)position;
@end

/**  Moves a CCNode object x,y pixels by modifying it's position attribute.
 x and y are relative to the position of the object.
 Duration is is seconds.
 */ 
@interface CCMoveVerticalBy : CCMoveVerticalTo <NSCopying>
{
}
/** creates the action */
+(id) actionWithDuration: (ccTime)duration verticalPosition:(CGFloat)deltaPosition;
/** initializes the action */
-(id) initWithDuration: (ccTime)duration verticalPosition:(CGFloat)deltaPosition;
@end
