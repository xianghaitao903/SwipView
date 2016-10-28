//
//  AutoLayoutViewController.m
//  SwipView
//
//  Created by xianghaitao on 16/8/31.
//
//

#import "AutoLayoutViewController.h"

@interface AutoLayoutViewController ()

@property(nonatomic, strong) UIView *orangeView;
@property(nonatomic, strong) UIView *grayView;
@property(nonatomic, strong) UIView *brownView;
@property(nonatomic, strong) UIView *purpleView;

@end

@implementation AutoLayoutViewController

#pragma mark - life cycle
- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"代码实现AutoLayout";
  // self.view.translatesAutoresizingMaskIntoConstraints = NO;
  [self setupSubviews];
  [self setLayout];
  // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - setup methods
- (void)setupSubviews {

  [self.view addSubview:self.orangeView];
  [self.view addSubview:self.grayView];
  [self.view addSubview:self.brownView];
  [self.view addSubview:self.purpleView];
}

- (void)setLayout {

  // _orangeView 与 self.view 等宽
  //只有在没有参照控件的情况下，约束才加到自身，不然加到父控件上
  //  [self.view addConstraint:[NSLayoutConstraint
  //                               constraintWithItem:self.orangeView
  //                                        attribute:NSLayoutAttributeWidth
  //                                        relatedBy:NSLayoutRelationEqual
  //                                           toItem:self.view
  //                                        attribute:NSLayoutAttributeWidth
  //                                       multiplier:0.4
  //                                         constant:0]];
  //  //    _orangeView 高度为100
  [self.orangeView
      addConstraint:[NSLayoutConstraint
                        constraintWithItem:self.orangeView
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:1
                                  constant:100.0]];
  //   _orangeView 的顶部距离self.viw 的顶部 30;
  [self.view
      addConstraint:[NSLayoutConstraint constraintWithItem:self.orangeView
                                                 attribute:NSLayoutAttributeTop
                                                 relatedBy:NSLayoutRelationEqual
                                                    toItem:self.view
                                                 attribute:NSLayoutAttributeTop
                                                multiplier:1.0
                                                  constant:30]];
  //  _orangeView 的左边距离self.viw 的左边 10;
  [self.view
      addConstraint:[NSLayoutConstraint constraintWithItem:self.orangeView
                                                 attribute:NSLayoutAttributeLeft
                                                 relatedBy:NSLayoutRelationEqual
                                                    toItem:self.view
                                                 attribute:NSLayoutAttributeLeft
                                                multiplier:1.0
                                                  constant:30]];

  // brownView 与 orangeView 等高
  [self.view addConstraint:[NSLayoutConstraint
                               constraintWithItem:self.brownView
                                        attribute:NSLayoutAttributeHeight
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:self.orangeView
                                        attribute:NSLayoutAttributeHeight
                                       multiplier:1.0
                                         constant:0]];

  // brownView 与 orangeView 等宽
  [self.view addConstraint:[NSLayoutConstraint
                               constraintWithItem:self.brownView
                                        attribute:NSLayoutAttributeWidth
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:self.orangeView
                                        attribute:NSLayoutAttributeWidth
                                       multiplier:1.0
                                         constant:0]];

  // brownView 与 orangeView 顶部位置相同
  [self.view
      addConstraint:[NSLayoutConstraint constraintWithItem:self.brownView
                                                 attribute:NSLayoutAttributeTop
                                                 relatedBy:NSLayoutRelationEqual
                                                    toItem:self.orangeView
                                                 attribute:NSLayoutAttributeTop
                                                multiplier:1.0
                                                  constant:0]];

  //   brownView 的右边 在  self.view 右边 偏移 -30 (左边30)
  [self.view addConstraint:[NSLayoutConstraint
                               constraintWithItem:self.brownView
                                        attribute:NSLayoutAttributeRight
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:self.view
                                        attribute:NSLayoutAttributeRight
                                       multiplier:1.0
                                         constant:-30]];

  //设置间距要替换的数值，用字典形式
  NSDictionary *metrics = @{ @"margin" : @30.0 };
  //把要添加约束的View都转成字典形式
  NSDictionary *views = NSDictionaryOfVariableBindings(_orangeView, _brownView,
                                                       _grayView, _purpleView);

  // 1.创建水平方向约束
  NSString *Hvfl = @"H:|-margin-[_grayView(==_orangeView)]-[_purpleView(==_"
                   @"orangeView)]-margin-|";
  //翻译过来就是，边缘-间距-_grayView（宽等于_orangeView的宽）-
  //_purpleView（宽等于_orangeView的宽）-间距-边缘
  //设置间距要替换的数值，用字典形式
  //设置对齐方式，顶部与底部都与红色View对齐
  NSLayoutFormatOptions ops =
      NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom;
  //创建水平方向约束
  NSArray *Hconstraints =
      [NSLayoutConstraint constraintsWithVisualFormat:Hvfl
                                              options:ops
                                              metrics:metrics
                                                views:views];

  //这里依然要设置红色view的高，因为水平方向的约束没有设置红色View的高，其他View仅仅是与它顶部底部对齐，但是高依然未知
  ops = NSLayoutFormatAlignAllLeft;
  NSString *Vvfl = @"V:[_orangeView]-margin-[_grayView(==_orangeView)]";
  //创建垂直方向约束
  NSArray *Vconstraints =
      [NSLayoutConstraint constraintsWithVisualFormat:Vvfl
                                              options:ops
                                              metrics:metrics
                                                views:views];
  //父控件添加约束

  [self.view addConstraints:Hconstraints];
  [self.view addConstraints:Vconstraints];
}

#pragma mark - getter and setter

- (UIView *)orangeView {
  if (!_orangeView) {
    _orangeView = [[UIView alloc] init];
    _orangeView.translatesAutoresizingMaskIntoConstraints = NO;
    _orangeView.backgroundColor = [UIColor orangeColor];
  }
  return _orangeView;
}

- (UIView *)grayView {
  if (!_grayView) {
    _grayView = [[UIView alloc] init];
    _grayView.translatesAutoresizingMaskIntoConstraints = NO;
    _grayView.backgroundColor = [UIColor grayColor];
  }
  return _grayView;
}

- (UIView *)brownView {
  if (!_brownView) {
    _brownView = [[UIView alloc] init];
    _brownView.translatesAutoresizingMaskIntoConstraints = NO;
    _brownView.backgroundColor = [UIColor brownColor];
  }
  return _brownView;
}

- (UIView *)purpleView {
  if (!_purpleView) {
    _purpleView = [[UIView alloc] init];
    _purpleView.translatesAutoresizingMaskIntoConstraints = NO;
    _purpleView.backgroundColor = [UIColor purpleColor];
  }
  return _purpleView;
}

@end
