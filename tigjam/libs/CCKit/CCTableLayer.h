//
//  CCTableLayer.h
//  CCExtensions
//
//  Created by Jerrod Putman on 7/29/11.
//  Copyright 2011 Tiny Tim Games. All rights reserved.
//
//  Portions created by Sangwoo Im.
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//	THE SOFTWARE.
//

#import "cocos2d.h"
#import "CCScrollLayer.h"


@class CCTableLayerCell, CCTableLayer;


// A protocol that objects can conform to to respond to table layer events.
@protocol CCTableLayerDelegate <CCScrollLayerDelegate>

-(void)table:(CCTableLayer *)table cellTouched:(CCTableLayerCell *)cell;

@end


// A protocol that an object can conform to to supply data to the table layer.
@protocol CCTableLayerDataSource<NSObject>

- (Class)cellClassForTable:(CCTableLayer *)table;
- (CCTableLayerCell *)table:(CCTableLayer *)table cellAtIndex:(NSUInteger)idx;
- (NSUInteger)numberOfCellsInTableLayer:(CCTableLayer *)table;

@end


@interface CCTableLayer : CCScrollLayer

#pragma mark - Properties

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_5_0
// Data source.
@property (nonatomic, weak) id<CCTableLayerDataSource> dataSource;

// Delegate.
@property (nonatomic, weak) id<CCTableLayerDelegate> delegate;
#else
// Data source.
@property (nonatomic, assign) id<CCTableLayerDataSource> dataSource;

// Delegate.
@property (nonatomic, assign) id<CCTableLayerDelegate> delegate;
#endif


#pragma mark - Creating a table view

// An intialized table view object
+ (id)tableLayerWithDataSource:(id<CCTableLayerDataSource>)dataSource size:(CGSize)size;


#pragma mark - Updating the table cells

// Updates the content of the cell at a given index.
- (void)updateCellAtIndex:(NSUInteger)idx;

// Inserts a new cell at a given index
- (void)insertCellAtIndex:(NSUInteger)idx;

// Removes a cell at a given index
- (void)removeCellAtIndex:(NSUInteger)idx;

// Reloads data from data source. The view will be refreshed.
- (void)reloadData;

// Dequeues a free cell if available. nil if not.
- (CCTableLayerCell *)dequeueCell;


@end
