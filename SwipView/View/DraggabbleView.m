//
//  DraggabbleView.m
//  SwipView
//
//  Created by xianghaitao on 16/8/29.
//
//

#import "DraggabbleView.h"

@implementation DraggabbleView {
  CGPoint startLocation;
}

- (instancetype)init {
  return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self setUserInteractionEnabled:YES];
  }
  return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [super touchesBegan:touches withEvent:event];
  // Retrieve the touch point
  CGPoint pt = [[touches anyObject] locationInView:self];
  startLocation = pt;
  [[self superview] bringSubviewToFront:self];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  [super touchesEnded:touches withEvent:event];
  // Move relative to the original touch point
  CGPoint pt = [[touches anyObject] locationInView:self];
  CGRect frame = [self frame];
  frame.origin.x += pt.x - startLocation.x;
  frame.origin.y += pt.y - startLocation.y;
  [self setFrame:frame];
}

@end
