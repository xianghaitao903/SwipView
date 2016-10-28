# 界面切换
实现思路: 一组UIButton 和 一个滑动的UILabel，UILabel给一个动画，跟随某一个被点击的UIButton
滑动时根据UIScrollView的代理，获取当前获得焦点的UIButton。每一个界面对应一个UIViewController,
实现逻辑分离。


# 图片轮播
实现思路: ScrollView 中加入三个UIImageView,ScrollView 静止时一直显示中间的UIImageView,
定时器每次向右滚动一页，动画完成后,修改三个 UIImageView 的image，然后直接设置ScrollView 的contextOffset 显示中间界面（无动画）；
滑动过后，修改三个 UIImageView 的image，然后直接设置ScrollView 的contextOffset 显示中间界面（无动画）；


# AutoLayut
Autolayout里有两个词，约束，参照
* 要想显示一个控件，需要两个东西，位置，尺寸
* 添加约束不宜过多，当添加的约束足以表达该控件的位置与尺寸，就足够了
* 约束就是对控件的大小或者位置进行约束，参照就是以某个控件的位置进行约束，其实这两者没有明确的分别，它们都可以对控件的位置与尺寸起到作用。
* 所有控件，都逃不开位置，尺寸，Autolayout就是拿来干这个用的，

```
/**
  *  这个是系统默认添加约束的方法，它是NSLayoutConstraint的类方法
  *
  *  @param view1      传入想要添加约束的控件
  *  @param attr1      传入想要添加约束的方向，这个枚举值有很多，可以自己看看
  *  @param relation   传入与约束值的关系，大于，等于还是小于
  *  @param view2      传入被参照对象
  *  @param attr2      传入被参照对象所被参照的方向，如顶部，左边，右边等等
  *  @param multiplier 传入想要的间距倍数关系
  *  @param c          传入最终的差值
  *
  *  @return NSLayoutConstraint对象
  */   

  + (instancetype)constraintWithItem:(id)view1
                          attribute:(NSLayoutAttribute)attr1
                          relatedBy:(NSLayoutRelation)relation
                             toItem:(id)view2
                          attribute:(NSLayoutAttribute)attr2
                         multiplier:(CGFloat)multiplier
                           constant:(CGFloat)c
```



 只有在没有参照控件的情况下，约束才加到自身，不然加到父控件上
```
// _orangeView 与 self.view 等宽
 //只有在没有参照控件的情况下，约束才加到自身，不然加到父控件上
 [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:self.orangeView
                                       attribute:NSLayoutAttributeWidth
                                       relatedBy:NSLayoutRelationEqual
                                          toItem:self.view
                                       attribute:NSLayoutAttributeWidth
                                      multiplier:0.4
                                        constant:0]];

//    _orangeView 高度为100
  [self.orangeView
      addConstraint:[NSLayoutConstraint
                        constraintWithItem:self.orangeView
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:1
                                  constant:100.0]];
```
## 优先级
优先级的范围是0~1000，数字越大，优先级越高，在不设置的情况下默认为1000
优先级低的约束,只有在它的冲突约束被抹掉后，它才能实现
```
NSLayoutConstraint *yellowAnotherLeft = [NSLayoutConstraint constraintWithItem:yellowV attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:redView attribute:NSLayoutAttributeRight multiplier:1.0f constant:20];
   UILayoutPriority priority = 250;//设置优先级
   yellowAnotherLeft.priority = priority;
   //与其他控件发生约束，所以约束添加到父控件上
   [self.view addConstraint:yellowAnotherLeft];
```   

## VFL（Visual Format Language）
VFL的思想与其他的实现方法有所不同，它更为宏观化，它将约束分成了两块
* 水平方向（H：）
* 垂直方向（V：）
也就是说，在创建约束的时候，得把水平与垂直方向的约束用字符串一并表达出来，而不是一个一个的添加

```
/**
   *  VFL创建约束的API
   *
   *  @param format
   * 传入某种格式构成的字符串，用以表达想要添加的约束，如@"H:|-margin-[redView(50)]"，水平方向上，redView与父控件左边缘保持“margin”间距，redView的宽为50
   *  @param opts    对齐方式，是个枚举值
   *  @param metrics 一般传入以间距为KEY的字典，如： @{
   * @"margin":@20}，KEY要与format参数里所填写的“margin”相同
   *  @param views
   * 传入约束中提到的View，也是要传入字典，但是KEY一定要和format参数里所填写的View名字相同，如：上面填的是redView，所以KEY是@“redView”
   *
   *  @return 返回约束的数组
   */
+ (NSArray *)constraintsWithVisualFormat:(NSString *)format
                                 options:(NSLayoutFormatOptions)opts
                                 metrics:(NSDictionary *)metrics
                                   views:(NSDictionary *)views

//部分NSLayoutFormatOptions的枚举选项
/*
NSLayoutFormatAlignAllLeft = (1 << NSLayoutAttributeLeft),//左边缘对齐
NSLayoutFormatAlignAllRight = (1 << NSLayoutAttributeRight),//右边缘对齐
NSLayoutFormatAlignAllTop = (1 << NSLayoutAttributeTop),
NSLayoutFormatAlignAllBottom = (1 << NSLayoutAttributeBottom),
NSLayoutFormatAlignAllLeading = (1 <<
NSLayoutAttributeLeading),//左边缘对齐
NSLayoutFormatAlignAllTrailing = (1 <<
NSLayoutAttributeTrailing),//右边缘对齐
NSLayoutFormatAlignAllCenterX = (1 <<
NSLayoutAttributeCenterX),//垂直方向中心对齐
NSLayoutFormatAlignAllCenterY = (1 <<
NSLayoutAttributeCenterY),//水平方向中心对齐
*/
```
