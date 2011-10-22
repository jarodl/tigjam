//
//  RNG.m
//  MouseMadness
//
//  Created by Karl Stenerud on 10-02-15.
//

#import "RNG.h"
#import "SFMT.h"
#import "NSMutableArray+Shuffle.h"
#import "SynthesizeSingleton.h"

@implementation RNG

+ (id)sharedInstance
{
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc] init];
    });
}

- (id) init
{
	return [self initWithSeed:time(NULL)];
}

- (id) initWithSeed:(unsigned int) seedValueIn
{
	if(nil != (self = [super init]))
	{
		self.seedValue = seedValueIn;
	}
	return self;
}

@synthesize seedValue;

- (void) setSeedValue:(unsigned int) value
{
	seedValue = value;
	init_gen_rand(seedValue);
}

- (unsigned int) randomUnsignedInt
{
	return gen_rand32();
}

- (double) randomProbability
{
	return genrand_real1();
}

- (double) random53BitProbability
{
	return genrand_res53_mix();
}

- (int) randomNumberFrom: (int) minValue to: (int) maxValue
{
	double probability = gen_rand32() / 4294967296.0;
	double range = maxValue - minValue + 1;
	return range * probability + minValue;
}

- (int) randomNumberFrom: (int) minValue to: (int) maxValue except:(int) exceptValue
{
	if(minValue == maxValue)
	{
		return minValue;
	}
	int result;
	while(exceptValue == (result = [self randomNumberFrom:minValue to:maxValue]))
	{
	}
	return result;
}

- (NSMutableArray*) randomlyOrderedNumbersFrom:(int) startValue to:(int) endValue
{
	int numValues = endValue - startValue;
	NSMutableArray* array = [NSMutableArray arrayWithCapacity:numValues];
	for(int i = startValue; i <= endValue; i++)
	{
		[array addObject:[NSNumber numberWithInt:i]];
	}
	[array shuffle];
	return array;
}

- (NSMutableArray*) randomNumberArrayWith: (int) n elementsFrom: (int) minValue to: (int) maxValue
{
	NSMutableArray* list = [NSMutableArray arrayWithCapacity:n];
	
	while(n > 0)
	{
		int numToAdd;
		
		do
			numToAdd = [self randomNumberFrom:minValue to:maxValue];
		while([list containsObject:[NSNumber numberWithInt:numToAdd]]);
		
		[list addObject:[NSNumber numberWithInt:numToAdd]];
		n--;
	}
	
	return list;
}

- (float) randomFloatFrom: (float) minValue to: (float) maxValue
{
	double probability = genrand_real1();
	double range = maxValue - minValue;
	return range * probability + minValue;
}

- (bool) randomBool
{
	return gen_rand32() & 1;
}

@end
