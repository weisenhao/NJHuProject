//
//  PreviewViewController.m
//  NJHuProject
//
//  Created by chrisbin on 08/03/2018.
//  Copyright © 2018 chrisbin. All rights reserved.
//

#import "PreviewViewController.h"
#import "CellDataItem.h"
#import <MOFSPickerManager/MOFSPickerManager.h>
#import "NoNavBarViewController.h"
#import "AdaptFontViewController.h"
#import "BlankPageViewController.h"
#import "AnimationNavBarViewController.h"
#import "ListExpandHideViewController.h"
#import "ElementsCollectionViewController.h"
#import "VerticalLayoutViewController.h"
#import "HorizontalLayoutViewController.h"
#import "KeyboardHandleViewController.h"
#import "DownLoadFileViewController.h"

@interface PreviewViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<CellDataItem *> *items;

@end

@implementation PreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.tabBarItem setBadgeColor:[UIColor orangeColor]];
    [self.navigationController.tabBarItem setBadgeValue:@"2"];
    self.items = [NSMutableArray array];
    
    CellDataItem *pickerManager = [[CellDataItem alloc] initWithTitle:@"省市区三级联动" subTitle:nil type:UITableViewCellAccessoryNone];
    pickerManager.itemOperation = ^(NSIndexPath *indexPath) {
        [[MOFSPickerManager shareManger] showMOFSAddressPickerWithTitle:@"选择地址" cancelTitle:@"取消" commitTitle:@"确定" commitBlock:^(NSString * _Nullable address, NSString * _Nullable zipcode) {
            NSLog(@"address: %@", address);
        } cancelBlock:^{
            
        }];
    };
    [self.items addObject:pickerManager];
    
    CellDataItem *noNavBar = [[CellDataItem alloc] initWithTitle:@"没有导航栏全局返回" subTitle:@"滑动返回" type:UITableViewCellAccessoryDisclosureIndicator];
    noNavBar.destVC = [NoNavBarViewController class];
    [self.items addObject:noNavBar];
    
    CellDataItem *adaptFont = [[CellDataItem alloc] initWithTitle:@"字体适配屏幕" subTitle:@"FontSize适配" type:UITableViewCellAccessoryDisclosureIndicator];
    adaptFont.destVC = [AdaptFontViewController class];
    [self.items addObject:adaptFont];
    
    CellDataItem *blankPage = [[CellDataItem alloc] initWithTitle:@"空白页展示" subTitle:@"Error Blank" type:UITableViewCellAccessoryDisclosureIndicator];
    blankPage.destVC = [BlankPageViewController class];
    [self.items addObject:blankPage];
    
    CellDataItem *animationNavBar = [[CellDataItem alloc] initWithTitle:@"导航条颜色或者高度渐变" subTitle:nil type:UITableViewCellAccessoryDisclosureIndicator];
    animationNavBar.destVC = [AnimationNavBarViewController class];
    [self.items addObject:animationNavBar];
    
    CellDataItem *yyText = [[CellDataItem alloc] initWithTitle:@"关于 YYText 使用" subTitle:@"未实现" type:UITableViewCellAccessoryNone];
    [self.items addObject:yyText];
    
    CellDataItem *listExpandHide = [[CellDataItem alloc] initWithTitle:@"列表的展开和收起" subTitle:nil type:UITableViewCellAccessoryDisclosureIndicator];
    listExpandHide.destVC = [ListExpandHideViewController class];
    [self.items addObject:listExpandHide];
    
    CellDataItem *elementsCollection = [[CellDataItem alloc] initWithTitle:@"App首页 CollectionView 布局" subTitle:@"未实现" type:UITableViewCellAccessoryDisclosureIndicator];
    elementsCollection.destVC = [ElementsCollectionViewController class];
    [self.items addObject:elementsCollection];
    
    CellDataItem *verticalLayout = [[CellDataItem alloc] initWithTitle:@"垂直流水布局" subTitle:nil type:UITableViewCellAccessoryDisclosureIndicator];
    verticalLayout.destVC = [VerticalLayoutViewController class];
    [self.items addObject:verticalLayout];
    
    CellDataItem *horizontalLayout = [[CellDataItem alloc] initWithTitle:@"水平流水布局" subTitle:@"未实现" type:UITableViewCellAccessoryDisclosureIndicator];
    horizontalLayout.destVC = [HorizontalLayoutViewController class];
    [self.items addObject:horizontalLayout];
    
    CellDataItem *keyboardHandle = [[CellDataItem alloc] initWithTitle:@"键盘处理" subTitle:nil type:UITableViewCellAccessoryDisclosureIndicator];
    keyboardHandle.destVC = [KeyboardHandleViewController class];
    [self.items addObject:keyboardHandle];
    
    CellDataItem *downLoadFile = [[CellDataItem alloc] initWithTitle:@"文件下载" subTitle:@"不重复下载服务器未更新文件" type:UITableViewCellAccessoryDisclosureIndicator];
    downLoadFile.destVC = [DownLoadFileViewController class];
    [self.items addObject:downLoadFile];
    
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"PreviewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    CellDataItem *item = [self.items objectAtIndex:indexPath.row];
    cell.accessoryType = item.accessoryType;
    cell.textLabel.text = item.title;
    cell.detailTextLabel.text = item.subTitle;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"静态单元格的头部标题";
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return @"静态单元格的尾部标题";
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CellDataItem *item = [self.items objectAtIndex:indexPath.row];
    if (item.itemOperation) {
        item.itemOperation(indexPath);
    } else if (item.destVC) {
        UIViewController *viewController = [[item.destVC alloc] init];
        viewController.navigationItem.title = item.title;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

#pragma mark - Property
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
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
