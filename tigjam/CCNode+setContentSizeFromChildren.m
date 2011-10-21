//
//  CCNode+ChildContentSize.m
//  MindSnacks
//
//  Created by Karl Stenerud on 5/9/11.
//

#import "CCNode+setContentSizeFromChildren.h"
#import "LoadableCategory.h"

MAKE_CATEGORIES_LOADABLE(CCNode_ChildContentSize)

@implementation CCNode (ChildContentSize)

- (void)setContentSizeFromChildren
{
	float minX = 1000000;
	float minY = 1000000;
	float maxX = -1000000;
	float maxY = -1000000;
	
	for(CCNode* node in children_) {
		float nextMinX = node.position.x - node.contentSize.width * node.scaleX * node.anchorPoint.x;
		float nextMaxX = nextMinX + node.contentSize.width * node.scaleX;
		float nextMinY = node.position.y - node.contentSize.height * node.scaleY * node.anchorPoint.y;
		float nextMaxY = nextMinY + node.contentSize.height * node.scaleY;
		
		if(nextMinX < minX) {
			minX = nextMinX;
		}
		if(nextMaxX > maxX) {
			maxX = nextMaxX;
		}
		if(nextMinY < minY) {
			minY = nextMinY;
		}
		if(nextMaxY > maxY) {
			maxY = nextMaxY;
		}
	}
	
	self.contentSize = CGSizeMake(maxX - minX, maxY - minY);
}

@end
