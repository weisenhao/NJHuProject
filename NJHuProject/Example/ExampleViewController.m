//
//  ExampleViewController.m
//  NJHuProject
//
//  Created by chrisbin on 08/03/2018.
//  Copyright © 2018 chrisbin. All rights reserved.
//

#import "ExampleViewController.h"
#import "CellDataItem.h"
#import "BSJTabBarController.h"

@interface ExampleViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray<CellDataItem *> *items;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ExampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.items = [NSMutableArray array];
    
    CellDataItem *bsj = [[CellDataItem alloc] initWithTitle:@"百思不得姐" subTitle:@"BSJ" type:UITableViewCellAccessoryNone];
    bsj.destVC = [BSJTabBarController class];
    [self.items addObject:bsj];
    
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

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CellDataItem *item = [self.items objectAtIndex:indexPath.row];
    if (item.itemOperation) {
        item.itemOperation(indexPath);
    } else if (item.destVC) {
        UIViewController *viewController = [[item.destVC alloc] init];
        [self presentViewController:viewController animated:YES completion:nil];
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
