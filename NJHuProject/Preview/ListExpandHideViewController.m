//
//  ListExpandHideViewController.m
//  NJHuProject
//
//  Created by chrisbin on 09/03/2018.
//  Copyright © 2018 chrisbin. All rights reserved.
//

#import "ListExpandHideViewController.h"
#import "Group.h"
#import "ListExpendHeader.h"

@interface ListExpandHideViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<Group *> *groups;

@end

@implementation ListExpandHideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    Group *group = [self.groups objectAtIndex:section];
    return group.isOpened ? group.teams.count : 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.groups[section].name;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *const ID = @"ListExpandHideCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    Group *group = [self.groups objectAtIndex:indexPath.section];
    Team *team = [group.teams objectAtIndex:indexPath.row];
    cell.textLabel.text = team.sortNumber;
    cell.detailTextLabel.text = team.name;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ListExpendHeader *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ListExpendHeader"];
    headerView.group = [self.groups objectAtIndex:section];
    __weak typeof(self) weakSelf = self;
    headerView.selectGroup = ^BOOL{
        Group *group = [weakSelf.groups objectAtIndex:section];
        group.isOpened = !group.isOpened;
        [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
        return group.isOpened;
    };
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Property
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [_tableView registerClass:[ListExpendHeader class] forHeaderFooterViewReuseIdentifier:@"ListExpendHeader"];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

- (NSMutableArray<Group *> *)groups {
    if (_groups == nil) {
        _groups = [NSMutableArray array];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"team_dictionary" ofType:@"plist"];
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
        [dict enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSArray<NSString *> *obj, BOOL * _Nonnull stop) {
            Group *group = [[Group alloc] init];
            group.isOpened = YES;
            group.name = [key copy];
            [obj enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                Team *team = [[Team alloc] init];
                team.sortNumber = [NSString stringWithFormat:@"%zd", idx];
                team.name = [obj copy];
                [group.teams addObject:team];
            }];
            [_groups addObject:group];
        }];
        [_groups sortUsingComparator:^NSComparisonResult(Team * _Nonnull obj1, Team * _Nonnull obj2) {
            return [obj1.name compare:obj2.name] == NSOrderedAscending ? NSOrderedAscending : NSOrderedDescending;
        }];
    }
    return _groups;
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
