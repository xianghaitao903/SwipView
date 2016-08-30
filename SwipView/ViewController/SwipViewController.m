//
//  SwipViewController.m
//  SwipView
//
//  Created by xianghaitao on 16/8/29.
//
//

#import "SwipViewController.h"
#import "TableViewController.h"

@interface SwipViewController () <UIScrollViewDelegate>

@property(nonatomic, strong) UIScrollView *scrollerView;

@property(nonatomic, strong) UIView *navView;
@property(nonatomic, strong) UIButton *nearByButton;
@property(nonatomic, strong) UIButton *squareButton;
@property(nonatomic, strong) UIButton *recommendButton;
@property(nonatomic, strong) UILabel *sliderLabel;

@property(nonatomic, strong) TableViewController *nearByVC;
@property(nonatomic, strong) TableViewController *squareVC;
@property(nonatomic, strong) TableViewController *recommendVC;

@end

@implementation SwipViewController

#pragma mark - life cycle
- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"视图切换";
  [self setupSubviews];
  [self setLayout];
  [self setupScrollView];
  // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - setup methods
- (void)setupSubviews {
  [self.view addSubview:self.navView];
  [self.view addSubview:self.scrollerView];
}

- (void)setLayout {
  CGFloat navViewHeight = 40.0;
  self.navView.frame = CGRectMake(0, 0, KScreenWidth, navViewHeight);
  self.nearByButton.frame = CGRectMake(0, 0, KScreenWidth / 3, navViewHeight);
  self.squareButton.frame =
      CGRectMake(KScreenWidth / 3, 0, KScreenWidth / 3, navViewHeight);
  self.recommendButton.frame =
      CGRectMake(2 * KScreenWidth / 3, 0, KScreenWidth / 3, navViewHeight);
  self.sliderLabel.frame =
      CGRectMake(0, navViewHeight - 4, KScreenWidth / 3, 2);

  CGFloat scrollerViewHeight = KScreenHeight - 64 - navViewHeight;
  self.scrollerView.frame =
      CGRectMake(0, navViewHeight, KScreenWidth, scrollerViewHeight);
}

/**
 *  初始化ScrollView上的子视图
 */
- (void)setupScrollView {
  NSArray *views =
      @[ self.nearByVC.view, self.squareVC.view, self.recommendVC.view ];
  CGFloat width = CGRectGetWidth(self.scrollerView.frame);
  CGFloat height = CGRectGetHeight(self.scrollerView.frame);
  for (int i = 0; i < views.count; i++) {
    //添加背景，把三个VC的view贴到mainScrollView上面
    UIView *pageView = [[UIView alloc]
        initWithFrame:CGRectMake(KScreenWidth * i, 0, width, height)];
    [pageView addSubview:views[i]];
    [self.scrollerView addSubview:pageView];
  }
  self.scrollerView.contentSize = CGSizeMake(KScreenWidth * (views.count), 0);
}

#pragma mark - event response
- (void)sliderAction:(UIButton *)sender {
  [self sliderAnimationWithTag:sender.tag];
  [UIView animateWithDuration:0.3
      animations:^{
        self.scrollerView.contentOffset =
            CGPointMake(KScreenWidth * (sender.tag - 1), 0);
      }
      completion:^(BOOL finished){

      }];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  double index_ = scrollView.contentOffset.x / KScreenWidth;
  [self sliderAnimationWithTag:(int)(index_ + 0.5) + 1];
}

#pragma mark - private method
/**
 *   sliderLabel滑动动画
 *
 *  @param tag 点击按钮的tag
 */
- (void)sliderAnimationWithTag:(NSInteger)tag {
  self.nearByButton.selected = NO;
  self.squareButton.selected = NO;
  self.recommendButton.selected = NO;
  UIButton *sender = [self buttonWithTag:tag];
  sender.selected = YES;
  //动画
  [UIView animateWithDuration:0.3
      animations:^{
        CGFloat originX = CGRectGetMinX(sender.frame);
        CGFloat originY = CGRectGetMinY(self.sliderLabel.frame);
        CGFloat width = CGRectGetWidth(self.sliderLabel.frame);
        CGFloat height = CGRectGetHeight(self.sliderLabel.frame);
        self.sliderLabel.frame = CGRectMake(originX, originY, width, height);

      }
      completion:^(BOOL finished) {
        self.nearByButton.titleLabel.font = [UIFont systemFontOfSize:14];
        self.squareButton.titleLabel.font = [UIFont systemFontOfSize:14];
        self.recommendButton.titleLabel.font = [UIFont systemFontOfSize:14];

        sender.titleLabel.font = [UIFont boldSystemFontOfSize:15];
      }];
}

/**
 *  初始化Button
 *
 *  @param title 按钮的标题
 *  @param tag   按钮的标签
 *
 *  @return 绑定点击事件的按钮
 */
- (UIButton *)customButtonWithTitile:(NSString *)title andTag:(NSInteger)tag {
  UIButton *button = [[UIButton alloc] init];
  button.tag = tag;
  [button setTitle:title forState:UIControlStateNormal];
  button.titleLabel.font = [UIFont systemFontOfSize:14];
  [button addTarget:self
                action:@selector(sliderAction:)
      forControlEvents:UIControlEventTouchUpInside];
  return button;
}

/**
 *  根据标签获取button
 *
 *  @param tag 标签号
 *
 *  @return 标签值为tag的按钮
 */
- (UIButton *)buttonWithTag:(NSInteger)tag {
  if (tag == 1) {
    return self.nearByButton;
  } else if (tag == 2) {
    return self.squareButton;
  } else if (tag == 3) {
    return self.recommendButton;
  } else {
    return nil;
  }
}

#pragma mark - getter and setter
- (UIScrollView *)scrollerView {
  if (!_scrollerView) {
    _scrollerView = [[UIScrollView alloc] init];
    _scrollerView.delegate = self;
    _scrollerView.backgroundColor = [UIColor whiteColor];
    _scrollerView.pagingEnabled = YES;
    _scrollerView.showsHorizontalScrollIndicator = NO;
    _scrollerView.showsVerticalScrollIndicator = NO;
  }
  return _scrollerView;
}

- (UIButton *)nearByButton {
  if (!_nearByButton) {
    _nearByButton = [self customButtonWithTitile:@"附近" andTag:1];
    _nearByButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
  }
  return _nearByButton;
}

- (UIButton *)squareButton {
  if (!_squareButton) {
    _squareButton = [self customButtonWithTitile:@"广场" andTag:2];
  }
  return _squareButton;
}

- (UIButton *)recommendButton {
  if (!_recommendButton) {
    _recommendButton = [self customButtonWithTitile:@"推荐" andTag:3];
  }
  return _recommendButton;
}

- (TableViewController *)nearByVC {
  if (!_nearByVC) {
    _nearByVC = [TableViewController new];
  }
  return _nearByVC;
}

- (TableViewController *)squareVC {
  if (!_squareVC) {
    _squareVC = [TableViewController new];
  }
  return _squareVC;
}

- (TableViewController *)recommendVC {
  if (!_recommendVC) {
    _recommendVC = [TableViewController new];
  }
  return _recommendVC;
}

- (UIView *)navView {
  if (!_navView) {
    _navView = [[UIView alloc] init];
    _navView.backgroundColor = [UIColor lightGrayColor];
    [self.navView addSubview:self.nearByButton];
    [self.navView addSubview:self.squareButton];
    [self.navView addSubview:self.recommendButton];
    [self.navView addSubview:self.sliderLabel];
  }
  return _navView;
}

- (UILabel *)sliderLabel {
  if (!_sliderLabel) {
    _sliderLabel = [[UILabel alloc] init];
    _sliderLabel.backgroundColor = [UIColor whiteColor];
  }
  return _sliderLabel;
}

@end
