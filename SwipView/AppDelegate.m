//
//  AppDelegate.m
//  SwipView
//
//  Created by xianghaitao on 16/8/29.
//
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

#pragma mark - life cycle
- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  // Override point for customization after application launch.
  [self setupRootViewController];
  [self setupCustomAppearance];
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state.
  // This can occur for certain types of temporary interruptions (such as an
  // incoming phone call or SMS message) or when the user quits the application
  // and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down
  // OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate
  // timers, and store enough application state information to restore your
  // application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called
  // instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the inactive state;
  // here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the
  // application was inactive. If the application was previously in the
  // background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if
  // appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - private methods

- (void)setupRootViewController {
  UIViewController *viewController = [ViewController new];
  UINavigationController *rootViewController = [[UINavigationController alloc]
      initWithRootViewController:viewController];
  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  self.window.rootViewController = rootViewController;
  self.window.backgroundColor = [UIColor whiteColor];
  [self.window makeKeyAndVisible];
}

- (void)setupCustomAppearance {
  /// 设置状态栏
  [[UIApplication sharedApplication]
      setStatusBarStyle:UIStatusBarStyleLightContent];

  /** 设置导航 */
  UINavigationBar *navigationBar = [UINavigationBar appearance];
  [navigationBar setBarTintColor:[UIColor purpleColor]];
  NSDictionary *navbarTitleTextAttributes = @{
    NSForegroundColorAttributeName : [UIColor whiteColor],
    NSFontAttributeName : [UIFont boldSystemFontOfSize:16.0]
  };
  // View 从导航之下开始
  navigationBar.translucent = NO;
  [navigationBar setTitleTextAttributes:navbarTitleTextAttributes];
  [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];

  /** 设置返回按钮 */
  //[[UIBarButtonItem appearance] setBackButtonBackgroundImage:img
  //                                                 forState:UIControlStateNormal
  //                                               barMetrics:UIBarMetricsDefault];
  // 设置文本与图片的偏移量
  [[UIBarButtonItem appearance]
      setBackButtonTitlePositionAdjustment:UIOffsetMake(5, 0)
                             forBarMetrics:UIBarMetricsDefault];
}

@end
