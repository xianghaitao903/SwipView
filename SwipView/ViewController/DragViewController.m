//
//  DragViewController.m
//  SwipView
//
//  Created by xianghaitao on 16/8/29.
//
//

#import "DragViewController.h"
#import "DraggabbleView.h"

@interface DragViewController ()

@property(nonatomic, strong) DraggabbleView *draggableView;

@property(nonatomic, strong) UILabel *label;

@end

@implementation DragViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"视图拖动";
  [self.view addSubview:self.draggableView];
  // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (DraggabbleView *)draggableView {
  if (!_draggableView) {
    _draggableView =
        [[DraggabbleView alloc] initWithFrame:CGRectMake(50, 100, 200, 200)];
    _draggableView.backgroundColor = [UIColor orangeColor];
  }
  return _draggableView;
}

- (void)test {
}

@end
