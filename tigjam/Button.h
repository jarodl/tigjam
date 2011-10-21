//
//  Button.h
//
//  Created by Karl Stenerud on 10-01-21.
//

#import "cocos2d.h"
#import "TouchableNode.h"

/**
 * A button is a touchable node that sends a message back to a listener when touched and released.
 * Note: It will only trigger if both the touch and release occur within the active area
 * (rectangle defined by the button's position and the touchableNode's contentSize).
 */
@interface Button : TouchableNode <CCRGBAProtocol>
{
	CCNode* touchablePortion;
	BOOL touchInProgress;
	BOOL buttonWasDown;
	
	id target;
	SEL selector;
}
/** The portion of this button that is actually touchable */
@property(nonatomic,readwrite,retain) CCNode* touchablePortion;

@property(readwrite,assign) id target;
@property(readwrite,assign) SEL selector;
@property (nonatomic, assign) ccColor3B normalColor;
@property (nonatomic, assign) ccColor3B downColor;

/** Create a new button.
 * @param node the node to use as a touchable portion.
 * @param target the target to notify when the button is pressed.
 * @param selector the selector to call when the button is pressed.
 * @return a new button.
 */
+ (id) buttonWithTouchablePortion:(CCNode*) node target:(id) target selector:(SEL) selector;

+ (id) buttonWithSize:(CGSize)size target:(id)target selector:(SEL)selector;

/** Initialize a button.
 * @param node the node to use as a touchable portion.
 * @param target the target to notify when the button is pressed.
 * @param selector the selector to call when the button is pressed.
 * @return the initialized button.
 */
- (id) initWithTouchablePortion:(CCNode*) node target:(id) target selector:(SEL) selector;

/** Called when a button press is detected.
 * Subclasses can use this method to add behavior to a button push.
 */
- (void) onButtonPressed;

/** Called when a button is pushed down.
 * Subclasses can use this method to add behavior to a button push.
 */
- (void) onButtonDown;

/** Called when a button is released.
 * Subclasses can use this method to add behavior to a button push.
 */
- (void) onButtonUp;

@end
