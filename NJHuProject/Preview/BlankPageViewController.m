//
//  BlankPageViewController.m
//  NJHuProject
//
//  Created by chrisbin on 09/03/2018.
//  Copyright © 2018 chrisbin. All rights reserved.
//

#import "BlankPageViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "EasyBlankPageView.h"
#import "MBProgressHUD+Custom.h"

@interface BlankPageViewController ()<UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *dateArray;

@end

@implementation BlankPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"出错效果" style:UIBarButtonItemStylePlain target:self action:@selector(changeError)];
    [self.view addSubview:self.tableView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Targer Action
- (void)refreshData {
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
        BOOL hasData = (self.dateArray.count > 0);
        [self.tableView configBlankPage:EasyBlankTypeNoData hasData:hasData hasError:hasData reloadButtonBlock:^(UIButton *sender) {
            [MBProgressHUD showAutoMessage:@"重新加载数据"];
            [weakSelf.tableView.mj_header beginRefreshing];
        }];
    });
}

- (void)loadMore {
    [self.tableView.mj_footer endRefreshing];
}

- (void)changeError {
    BOOL hasData = (self.dateArray.count > 0);
    __weak typeof(self) weakSelf = self;
    [self.tableView configBlankPage:EasyBlankTypeNoData hasData:hasData hasError:YES reloadButtonBlock:^(UIButton *sender) {
        [weakSelf.tableView.mj_header beginRefreshing];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dateArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BlankPageCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BlankPageCell"];
    }
    return cell;
}

#pragma mark - Property
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
        _tableView.mj_header.automaticallyChangeAlpha = YES;
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
        _tableView.mj_footer.automaticallyChangeAlpha = YES;
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
