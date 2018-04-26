//
//  BSJTabBarController.m
//  NJHuProject
//
//  Created by chrisbin on 12/03/2018.
//  Copyright © 2018 chrisbin. All rights reserved.
//

#import "BSJTabBarController.h"
#import "MainNavigationController.h"

@interface BSJTabBarController ()

@end

@implementation BSJTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tabBar.tintColor = [UIColor redColor];
    [self addTabbarItems];
    [self addChildViewControllers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addTabbarItems {
    NSDictionary *firstAttributes = @{
                                      CYLTabBarItemTitle : @"精华",
                                      CYLTabBarItemImage : @"tabBar_essence_icon",
                                      CYLTabBarItemSelectedImage : @"tabBar_essence_click_icon",
                                      };
    NSDictionary *secondAttributes = @{
                                       CYLTabBarItemTitle : @"新帖",
                                       CYLTabBarItemImage : @"tabBar_new_icon",
                                       CYLTabBarItemSelectedImage : @"tabBar_new_click_icon",
                                       };
    NSDictionary *thirdAttributes = @{
                                      CYLTabBarItemTitle : @"关注",
                                      CYLTabBarItemImage : @"tabBar_friendTrends_icon",
                                      CYLTabBarItemSelectedImage : @"tabBar_friendTrends_click_icon",
                                      };
    NSDictionary *fourthAttributes = @{
                                       CYLTabBarItemTitle : @"我",
                                       CYLTabBarItemImage : @"tabBar_me_icon",
                                       CYLTabBarItemSelectedImage : @"tabBar_me_click_icon"
                                       };
    self.tabBarItemsAttributes = @[firstAttributes, secondAttributes, thirdAttributes, fourthAttributes];
}

- (void)addChildViewControllers {
    MainNavigationController *firstNav = [[MainNavigationController alloc] initWithRootViewController:[[UIViewController alloc] init]];
    MainNavigationController *secondNav = [[MainNavigationController alloc] initWithRootViewController:[[UIViewController alloc] init]];
    MainNavigationController *thirdNav = [[MainNavigationController alloc] initWithRootViewController:[[UIViewController alloc] init]];
    MainNavigationController *fourthNav = [[MainNavigationController alloc] initWithRootViewController:[[UIViewController alloc] init]];
    self.viewControllers = @[firstNav, secondNav, thirdNav, fourthNav];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
