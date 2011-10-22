//
//  RNG.h
//  MouseMadness
//
//  Created by Karl Stenerud on 10-02-15.
//

#import <Foundation/Foundation.h>

/** Random number generator interface */
@interface RNG : NSObject
{
	unsigned int seedValue;
}
/** The current seed value being used */
@property(nonatomic,readwrite,assign) unsigned int seedValue;

+ (id)sharedInstance;

/** Initialize with the specified seed value.
 * This must ONLY be called BEFORE accessing sharedInstance.
 */
- (id) initWithSeed:(unsigned int) seed;

/** Returns a random unsigned int from 0 to 0xffffffff */
- (unsigned int) randomUnsignedInt;

/** Returns a random probability value from 0.0 to 1.0 */
- (double) randomProbability;

/** Returns a 53-bit precision probability value from 0.0 to 1.0 */
- (double) random53BitProbability;

/** Returns a random integer from minValue to maxValue */
- (int) randomNumberFrom: (int) minValue to: (int) maxValue;

/** Returns a random integer from minValue to maxValue, but does not return exceptValue */
- (int) randomNumberFrom: (int) minValue to: (int) maxValue except:(int) exceptValue;

/** Returns an array of n unique random integers from minValue to maxValue */
- (NSMutableArray*) randomNumberArrayWith: (int) n elementsFrom: (int) minValue to: (int) maxValue;

/** Returns a mutable array containing all numbers from startValue to endValue, in random order. */
- (NSMutableArray*) randomlyOrderedNumbersFrom:(int) startValue to:(int) endValue;

/** Returns a random float from minValue to maxValue */
- (float) randomFloatFrom: (float) minValue to: (float) maxValue;

/** Randomly returns YES or NO */
- (bool) randomBool;

@end
