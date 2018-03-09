//
//  MainTabBarController.m
//  NJHuProject
//
//  Created by chrisbin on 07/03/2018.
//  Copyright © 2018 chrisbin. All rights reserved.
//

#import "MainTabBarController.h"
#import "MainNavigationController.h"
#import "PreviewViewController.h"
#import "BasicViewController.h"
#import "ExampleViewController.h"
#import "MoreViewController.h"
#import "ShareViewController.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tabBar.tintColor = [UIColor redColor];
    // 底部文字调整
//    [self setValue:[NSValue valueWithUIOffset:UIOffsetMake(0, -3)] forKey:@"titlePositionAdjustment"];
    
    NSDictionary *previewAttributes = @{
                                        CYLTabBarItemTitle: @"预演",
                                        CYLTabBarItemImage : @"tabBar_friendTrends_icon",
                                        CYLTabBarItemSelectedImage : @"tabBar_friendTrends_click_icon",
                                        };
    NSDictionary *basicAttributes = @{
                                      CYLTabBarItemTitle : @"基础",
                                      CYLTabBarItemImage : @"tabBar_essence_icon",
                                      CYLTabBarItemSelectedImage : @"tabBar_essence_click_icon",
                                      };
    NSDictionary *exampleAttributes = @{
                                        CYLTabBarItemTitle : @"实例",
                                        CYLTabBarItemImage : @"tabBar_new_icon",
                                        CYLTabBarItemSelectedImage : @"tabBar_new_click_icon",
                                        };
    NSDictionary *moreAttributes = @{
                                     CYLTabBarItemTitle : @"更多",
                                     CYLTabBarItemImage : @"tabbar_discover",
                                     CYLTabBarItemSelectedImage : @"tabbar_discover_highlighted"
                                     };
    NSDictionary *shareAttributes = @{
                                      CYLTabBarItemTitle : @"分享",
                                      CYLTabBarItemImage : @"tabBar_me_icon",
                                      CYLTabBarItemSelectedImage : @"tabBar_me_click_icon"
                                      };
    
    self.tabBarItemsAttributes = @[previewAttributes, basicAttributes, exampleAttributes, moreAttributes, shareAttributes];
    
    PreviewViewController *previewVC = [[PreviewViewController alloc] init];
    MainNavigationController *previewNav = [[MainNavigationController alloc] initWithRootViewController:previewVC];
    
    BasicViewController *basicVC = [[BasicViewController alloc] init];
    MainNavigationController *basicNav = [[MainNavigationController alloc] initWithRootViewController:basicVC];
    
    ExampleViewController *exampleVC = [[ExampleViewController alloc] init];
    MainNavigationController *exampleNav = [[MainNavigationController alloc] initWithRootViewController:exampleVC];
    
    MoreViewController *moreVC = [[MoreViewController alloc] init];
    MainNavigationController *moreNav = [[MainNavigationController alloc] initWithRootViewController:moreVC];
    
    ShareViewController *shareVC = [[ShareViewController alloc] init];
    MainNavigationController *shareNav = [[MainNavigationController alloc] initWithRootViewController:shareVC];
    
    self.viewControllers = @[previewNav, basicNav, exampleNav, moreNav, shareNav];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
