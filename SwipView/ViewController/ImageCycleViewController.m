//
//  ImageCycleViewController.m
//  SwipView
//
//  Created by xianghaitao on 16/8/29.
//
//

#import "ImageCycleViewController.h"

@interface ImageCycleViewController () <UIScrollViewDelegate>

@property(nonatomic, strong) UIScrollView *scrollerView;
@property(nonatomic, strong) UIPageControl *pageControl;
@property(nonatomic, strong) UIImageView *currentImageView;
@property(nonatomic, strong) UIImageView *leftImageView;
@property(nonatomic, strong) UIImageView *rightImageView;
@property(nonatomic, strong) NSTimer *timer;
@property(nonatomic, strong) NSArray *imageArr;

@property(nonatomic, assign) NSInteger currentIndex;

@end

@implementation ImageCycleViewController

#pragma mark - life cycle
- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"图片轮播";
  [self setupSubviews];
  [self setLayout];
  [self setupTimer];
  // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  [self.timer fire];
  self.timer = nil;
}

#pragma mark setup methods
- (void)setupSubviews {
  [self.view addSubview:self.scrollerView];
  [self.scrollerView addSubview:self.leftImageView];
  [self.scrollerView addSubview:self.currentImageView];
  [self.scrollerView addSubview:self.rightImageView];

  [self.view addSubview:self.pageControl];
}

- (void)setLayout {
  self.scrollerView.frame = CGRectMake(0, 0, KScreenWidth, 200);
  self.leftImageView.frame = CGRectMake(0, 0, KScreenWidth, 200);
  self.currentImageView.frame = CGRectMake(KScreenWidth, 0, KScreenWidth, 200);
  self.rightImageView.frame =
      CGRectMake(2 * KScreenWidth, 0, KScreenWidth, 200);

  self.pageControl.center = CGPointMake(CGRectGetMidX(self.view.frame), 180);
  self.pageControl.numberOfPages = self.imageArr.count;
  CGSize size = [self.pageControl sizeForNumberOfPages:self.imageArr.count];
  self.pageControl.bounds = CGRectMake(0, 0, size.width, size.height);
}

- (void)setupTimer {
  _timer = [NSTimer timerWithTimeInterval:2.0
                                   target:self
                                 selector:@selector(timerChanged)
                                 userInfo:nil
                                  repeats:YES];
  [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}

#pragma mark - event response
/**
 *  定时轮播 每次当前页+1 向右移动一页
 *  动画完成过后 ，把当前页剧中，左右图片视图重新赋值
 */
- (void)timerChanged {
  [UIView animateWithDuration:0.3
      animations:^{
        [_scrollerView setContentOffset:CGPointMake(2 * KScreenWidth, 0)];
      }
      completion:^(BOOL finished) {
        [self reloadSubviewsInScrollView];
        [_scrollerView setContentOffset:CGPointMake(KScreenWidth, 0)
                               animated:NO];
      }];
}

#pragma mark - UIScrollViewDelegate
/**
 *  手势滑动开始前停止timer
 *
 *  @param scrollView scrollView
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
  [self.timer invalidate];
}

/**
 *  手势滑动结束之后
 *  把当前页居中，左右图片视图重新赋值
 *  @param scrollView scrollView
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  [self reloadSubviewsInScrollView];
  [scrollView setContentOffset:CGPointMake(KScreenWidth, 0) animated:NO];
  [self setupTimer];
}

#pragma mark - private methods

/**
 *  当前页 左移减1 右移加 1
 *  移动之后重新给ScrollView中的三个ImageView 的 image 赋值
 */
- (void)reloadSubviewsInScrollView {
  NSInteger leftIndex, rightIndex;
  CGPoint offset = [self.scrollerView contentOffset];
  if (offset.x == 2 * KScreenWidth) {
    _currentIndex = (_currentIndex + 1) % self.imageArr.count;
    self.pageControl.currentPage = _currentIndex;
  } else if (offset.x == 0) {
    _currentIndex = (_currentIndex - 1) % self.imageArr.count;
    self.pageControl.currentPage = _currentIndex;
  }
  leftIndex = (_currentIndex - 1) % self.imageArr.count;
  rightIndex = (_currentIndex + 1) % self.imageArr.count;
  self.currentImageView.image = self.imageArr[_currentIndex];
  self.leftImageView.image = self.imageArr[leftIndex];
  self.rightImageView.image = self.imageArr[rightIndex];
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
    _scrollerView.contentSize = CGSizeMake(3 * KScreenWidth, 0);
    [_scrollerView setContentOffset:CGPointMake(KScreenWidth, 0) animated:NO];
  }
  return _scrollerView;
}

- (UIPageControl *)pageControl {
  if (!_pageControl) {
    _pageControl = [UIPageControl new];
    _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    _pageControl.pageIndicatorTintColor = [UIColor grayColor];
  }
  return _pageControl;
}

- (NSArray *)imageArr {
  if (!_imageArr) {
    NSMutableArray *arr = [NSMutableArray new];
    for (int i = 1; i < 5; ++i) {
      NSString *imageName = [NSString stringWithFormat:@"%d.jpg", i];
      UIImage *image = [UIImage imageNamed:imageName];
      [arr addObject:image];
    }
    _imageArr = arr;
  }
  return _imageArr;
}

- (UIImageView *)currentImageView {
  if (!_currentImageView) {
    _currentImageView = [[UIImageView alloc] init];
    _currentImageView.image = self.imageArr.firstObject;
  }
  return _currentImageView;
}

- (UIImageView *)leftImageView {
  if (!_leftImageView) {
    _leftImageView = [[UIImageView alloc] init];
    _leftImageView.image = self.imageArr.lastObject;
  }
  return _leftImageView;
}

- (UIImageView *)rightImageView {
  if (!_rightImageView) {
    _rightImageView = [[UIImageView alloc] init];
    _rightImageView.image = self.imageArr[1];
  }
  return _rightImageView;
}

@end
