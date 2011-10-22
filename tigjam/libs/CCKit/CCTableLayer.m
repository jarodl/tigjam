//
//  CCTableLayer.m
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

#import "CCTableLayer.h"
#import "CCTableLayerCell.h"


#if __has_feature(objc_arc) == 0
#warning This code was designed to run under ARC. Without it, you will experience lots of memory leaks.
#endif


@interface CCScrollLayer ()

@property (nonatomic, strong) CCLayer *container;

- (void)scrollLayerDidScroll;

@end


#pragma mark -


@implementation CCTableLayer
{
    NSMutableArray *cellsUsed;
    NSMutableArray *cellsFreed;
}

@synthesize delegate;
@synthesize dataSource;


#pragma mark - Private

- (void)addCellIfNecessary:(CCTableLayerCell *)cell
{
    if (cell.node.parent != self.container)
	{
        NSAssert(!cell.node.parent, @"CCTableView: _addCellIfNecessary: cell from another table view is returned from data source");  
        [self.container addChild:cell.node];
    }
}


- (void)updateContentSize
{
    CGSize     size, cellSize;
    NSUInteger cellCount;
    
    cellSize  = [[dataSource cellClassForTable:self] cellSize];
    cellCount = [dataSource numberOfCellsInTableLayer:self];
    
    switch (self.direction)
	{
        case CCScrollLayerDirectionHorizontal:
            size = CGSizeMake(cellCount * cellSize.width, self.viewSize.height);
            if (size.width < self.viewSize.width)
                size.width = self.viewSize.width;

            break;
			
        default:
            size = CGSizeMake(self.viewSize.width, cellCount * cellSize.height);
            if (size.height < self.viewSize.height)
                size.height = self.viewSize.height;

            break;
    }
	
    [self setContentSize:size];
}


- (CGPoint)offsetFromIndex:(NSUInteger)index
{
    CGPoint offset;
    CGSize  cellSize;
    
    NSAssert(index != NSNotFound, @"CCTableView: _offsetFromIndex: invalid index");
    
    cellSize = [[dataSource cellClassForTable:self] cellSize];
    switch (self.direction)
	{
        case CCScrollLayerDirectionHorizontal:
            offset = ccp(cellSize.width * index, 0.0f);
            break;
			
        default:
            offset = ccp(0.0f, cellSize.height * index);
            break;
    }
    
    return offset;
}


- (NSUInteger)indexFromOffset:(CGPoint)offset
{
    NSInteger  index;
    CGSize     cellSize;
    
    cellSize = [[dataSource cellClassForTable:self] cellSize];
    
    switch (self.direction)
	{
        case CCScrollLayerDirectionHorizontal:
            index = offset.x/cellSize.width;
            break;
			
        default:
            index = offset.y/cellSize.height;
            break;
    }
    
    index = MAX(0, index);
    index = MIN(((NSInteger)[dataSource numberOfCellsInTableLayer:self])-1, index);
    return ((NSUInteger)index);
}


- (CCTableLayerCell *)cellWithIndex:(NSUInteger)cellIndex
{
	CCTableLayerCell   *cell;
	NSPredicate       *pred;
	NSArray           *array;
	
	pred  = [NSPredicate predicateWithFormat:@"idx == %i", cellIndex];
	array = [cellsUsed filteredArrayUsingPredicate:pred];
	cell  = nil;
	
	if (array && [array count] > 0)
	{
		if ([array count] > 1)
			NSLog(@"%s: %s: duplicate cells at index, %i", __FILE__, __FUNCTION__, cellIndex);

		cell = [array objectAtIndex:0];
	}
	
	return cell;
}


- (void)moveCellOutOfSight:(CCTableLayerCell *)cell
{
    [cellsFreed addObject:cell];
    [cellsUsed removeObject:cell];
    [self.container removeChild:cell.node cleanup:YES];
    cell.idx       = NSNotFound;
    cell.node      = nil;
}


- (void)evictCell
{
    if ([cellsFreed count] > 0)
        return;
	
	NSUInteger        startIdx, endIdx;
	CGSize            cellSize;
	NSArray           *clippedCells;
	CGPoint           offset;
	NSPredicate       *pred;
	
	offset   = [self contentOffset];
	offset   = ccp(-offset.x, -offset.y);
	cellSize = [[dataSource cellClassForTable:self] cellSize];
	startIdx = [self indexFromOffset:offset];
	
	switch (self.direction)
	{
		case CCScrollLayerDirectionHorizontal:
			offset.x += self.viewSize.width;
			offset.y =  self.viewSize.height;
			break;
			
		default:
			offset.x =  self.viewSize.width;
			offset.y += self.viewSize.height;
			break;
	}
	endIdx = [self indexFromOffset:offset];
	
	pred         = [NSPredicate predicateWithFormat:@"idx < %i",startIdx];
	clippedCells = [cellsUsed filteredArrayUsingPredicate:pred];
	
	for(CCTableLayerCell *cell in clippedCells)
	{
		[self moveCellOutOfSight:cell];
	}
	
	pred         = [NSPredicate predicateWithFormat:@"idx > %i", endIdx];
	clippedCells = [cellsUsed filteredArrayUsingPredicate:pred];
	
	for(CCTableLayerCell *cell in clippedCells)
	{
		[self moveCellOutOfSight:cell];
	}
}


- (void)setIndex:(NSUInteger)index forCell:(CCTableLayerCell *)cell
{
    CGPoint    offset;
    CGSize     cellSize;
    CCNode     *item;
	
    NSAssert(cell != nil, @"CCTableView: _setIndex:forCell: cell is nil!");
    
    offset   = [self offsetFromIndex:index];
    cellSize = [[dataSource cellClassForTable:self] cellSize];
    
    if (!CGSizeEqualToSize(cell.node.contentSize, cellSize))
        NSLog(@"%s: %s: inconsistent cell size", __FILE__, __FUNCTION__);
    
    item             = cell.node;
    item.anchorPoint = ccp(0.0f, 0.0f);
    item.position    = offset;
    cell.idx         = index;
}


- (void)scrollLayerDidScroll
{
	[super scrollLayerDidScroll];
	
	NSUInteger        startIdx, endIdx;
	CGSize            cellSize;
	NSArray           *clippedCells;
	CGPoint           offset;
	NSPredicate       *pred;
	
	offset   = [self contentOffset];
	offset   = ccp(-offset.x, -offset.y);
	cellSize = [[dataSource cellClassForTable:self] cellSize];
	startIdx = [self indexFromOffset:offset];
	
	switch (self.direction) 
	{
		case CCScrollLayerDirectionHorizontal:
			offset.x += self.viewSize.width;
			offset.y =  self.viewSize.height;
			break;
			
		default:
			offset.x =  self.viewSize.width;
			offset.y += self.viewSize.height;
			break;
	}
	endIdx = [self indexFromOffset:offset];
	
	pred         = [NSPredicate predicateWithFormat:@"idx < %i",startIdx];
	clippedCells = [cellsUsed filteredArrayUsingPredicate:pred];
	
	for (CCTableLayerCell *cell in clippedCells) 
	{
		[self moveCellOutOfSight:cell];
	}
	
	pred         = [NSPredicate predicateWithFormat:@"idx > %i", endIdx];
	clippedCells = [cellsUsed filteredArrayUsingPredicate:pred];
	
	for (CCTableLayerCell *cell in clippedCells) 
	{
		[self moveCellOutOfSight:cell];
	}
	
	for (NSUInteger i=startIdx; i <= endIdx; i++) 
	{
		if ([self cellWithIndex:i]) 
			continue;
		
		[self updateCellAtIndex:i];
	}
}


#pragma mark - Creating a table view

+ (id)tableLayerWithDataSource:(id<CCTableLayerDataSource>)dataSource size:(CGSize)size
{
    CCTableLayer *table;
    table = [[CCTableLayer alloc] initWithViewSize:size];
    table.dataSource = dataSource;
    [table updateContentSize];
    return table;
}


+ (id)scrollLayerWithViewSize:(CGSize)size
{
    NSLog(@"%s: %s: You can not use this method", __FILE__, __FUNCTION__);
    return nil;
}


- (id)initWithViewSize:(CGSize)size
{
    if ((self = [super initWithViewSize:size]))
	{
        cellsUsed      = [NSMutableArray new];
        cellsFreed     = [NSMutableArray new];
        self.direction  = CCScrollLayerDirectionVertical;
    }
	
    return self;
}


#pragma mark -
#pragma mark Properties

- (void)setDirection:(CCScrollLayerDirection)direction
{
    NSAssert(direction != CCScrollLayerDirectionBoth, @"CCTableView: setDirection: table view does not support CCScrollViewDirectionBoth");
	
    [super setDirection:direction];
}


#pragma mark - Updating the table cells

- (void)reloadData
{
	for (CCTableLayerCell *cell in cellsUsed)
	{
		[cellsFreed addObject:cell];
		cell.idx            = NSNotFound;
		cell.node.visible   = NO;
	}
	cellsUsed = [NSMutableArray new];
	
	if ([dataSource numberOfCellsInTableLayer:self] > 0)
		[self scrollLayerDidScroll];
	[self updateContentSize];
}


- (void)updateCellAtIndex:(NSUInteger)idx
{
    if (idx == NSNotFound
		|| idx > [dataSource numberOfCellsInTableLayer:self]-1)
	{
        NSLog(@"%s: %s: invalid index", __FILE__, __FUNCTION__);
        return;
    }
    
	CCTableLayerCell *cell = [self cellWithIndex:idx];
	if (cell)
		[self moveCellOutOfSight:cell];

	cell = [dataSource table:self cellAtIndex:idx];
	[self addCellIfNecessary:cell];
	[self setIndex:idx forCell:cell];
	[cellsUsed addObject:cell];
}


- (void)insertCellAtIndex:(NSUInteger)idx
{
    if (idx == NSNotFound
		|| idx > [dataSource numberOfCellsInTableLayer:self]-1)
	{
        NSLog(@"%s: %s: invalid index", __FILE__, __FUNCTION__);
        return;
    }
	
	NSArray           *movingCells;
	NSPredicate       *pred;
	CCTableLayerCell   *cell;
	NSUInteger        newIdx;
	
	pred        = [NSPredicate predicateWithFormat:@"idx >= %i",idx];
	movingCells = [cellsUsed filteredArrayUsingPredicate:pred];
	
	//Pushing existing cells down.
	for(CCTableLayerCell *tCell in movingCells)
	{
		newIdx = cell.idx + 1;
		[self setIndex:newIdx forCell:tCell];
	}
	
	//insert a new cell
	cell = [dataSource table:self cellAtIndex:idx];
	[self addCellIfNecessary:cell];
	[self setIndex:idx forCell:cell];
	[cellsUsed addObject:cell];
	
	[self updateContentSize];
}


- (void)removeCellAtIndex:(NSUInteger)idx
{
    if (idx == NSNotFound
		|| idx > [dataSource numberOfCellsInTableLayer:self]-1)
	{
        NSLog(@"%s: %s: invalid index", __FILE__, __FUNCTION__);
        return;
    }
    
	CCTableLayerCell   *cell;
	NSUInteger        newIdx;
	NSArray           *movingCells;
	NSPredicate       *pred;
	
	cell = [self cellWithIndex:idx];
	if (!cell)
		return;

	// Remove first
	[self moveCellOutOfSight:cell];
	
	//pulling cells up
	pred        = [NSPredicate predicateWithFormat:@"idx > %i", idx];
	movingCells = [cellsUsed filteredArrayUsingPredicate:pred];
	
	for (cell in movingCells)
	{
		newIdx = cell.idx - 1;
		[self setIndex:newIdx forCell:cell];
	}
}


- (CCTableLayerCell *)dequeueCell
{
    CCTableLayerCell *cell;
    
    [self evictCell];
    if ([cellsFreed count] == 0)
        cell = nil;
    else
	{
        cell = [cellsFreed objectAtIndex:0];
        [cellsFreed removeObjectAtIndex:0];
    }
	
    return cell;
}


#pragma mark -
#pragma mark scrollView

#pragma mark -
#pragma mark Touch events

//- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    if ([touches count] == 1
//		&& !self.touchMoved
//		&& !CGPointEqualToPoint(ccp(-1.0f, -1.0f), self.touchPoint))
//	{
//        CGPoint           localPoint;
//        NSUInteger        index;
//        CCTableViewCell   *cell;
//        
//        localPoint = [self contentOffset];
//        localPoint = ccpAdd(ccp(-localPoint.x, -localPoint.y), self.touchPoint);
//        index      = [self indexFromOffset:localPoint];
//        cell       = [self cellWithIndex:index];
//        
//        NSAssert(cell, @"CCTableView: no cell exists with that index");
//        
//        [delegate table:self cellTouched:cell];
//    }
//	
//    [super ccTouchesEnded:touches withEvent:event];
//}


@end
