//
//  NSMutableArray-Shuffle.m
//  MindSnacks
//
//  Created by Karl Stenerud on 10-05-19.
//

#import "NSMutableArray+Shuffle.h"
#import "LoadableCategory.h"
#import "SFMT.h"

MAKE_CATEGORIES_LOADABLE(NSMutableArray_Shuffle);

@implementation NSMutableArray (Shuffle)

- (void) shuffle
{
    NSUInteger count = [self count];
    for (NSUInteger i = 0; i < count; ++i) {
        // Select a random element between i and end of array to swap with.
        int nElements = count - i;
        int n = (gen_rand32() % nElements) + i;
        [self exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
}

@end
