//
//  OfflineDownloadViewController.m
//  NJHuProject
//
//  Created by chrisbin on 13/03/2018.
//  Copyright © 2018 chrisbin. All rights reserved.
//

#import "OfflineDownloadViewController.h"
#import "DownloadManager.h"

@interface OfflineDownloadViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray<DownloadInfo *> *infos;
@property (nonatomic, strong) UIButton *startButton;
@property (nonatomic, strong) UIButton *pauseButton;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation OfflineDownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.navigationItem.title = @"点击Cell开始/暂停下载";
    NSArray<NSString *> *urls = @[
                                  @"http://120.25.226.186:32812/resources/videos/minion_01.mp4",
                                  @"http://120.25.226.186:32812/resources/videos/minion_02.mp4",
                                  @"http://120.25.226.186:32812/resources/videos/minion_03.mp4",
                                  @"http://120.25.226.186:32812/resources/videos/minion_04.mp4",
                                  @"http://120.25.226.186:32812/resources/videos/minion_05.mp4",
                                  @"http://120.25.226.186:32812/resources/videos/minion_06.mp4",
                                  @"http://120.25.226.186:32812/resources/videos/minion_07.mp4",
                                  @"http://120.25.226.186:32812/resources/videos/minion_08.mp4",
                                  @"http://120.25.226.186:32812/resources/videos/minion_09.mp4",
                                  @"http://120.25.226.186:32812/resources/videos/minion_10.mp4"
                                  ];
    self.infos = [NSMutableArray array];
    [urls enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        DownloadInfo *info = [[DownloadManager defaultManager] downloadInfoForURL:obj];
        [self.infos addObject:info];
    }];
    
    CGSize size = self.view.bounds.size;
    self.startButton.frame = CGRectMake(0, 64.f, size.width / 2.f, 30.f);
    self.pauseButton.frame = CGRectMake(size.width / 2.f, 64.f, size.width / 2.f, 30.f);
    [self.view addSubview:self.startButton];
    [self.view addSubview:self.pauseButton];
    
    self.tableView.frame = CGRectMake(0, 94.f, size.width, size.height - 94.f);
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Target Action
- (void)buttonClicked:(UIButton *)button {
    if (button == self.startButton) {
        NSLog(@"全部开始");
    } else if (button == self.pauseButton) {
        NSLog(@"全部暂停");
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.infos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OfflineDownCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"OfflineDownCell"];
    }
    DownloadInfo *info = [self.infos objectAtIndex:indexPath.row];
    cell.textLabel.text = info.url.lastPathComponent;
    cell.detailTextLabel.text = (info.state == DownloadStateCompleted) ? @"播放" : @"进度: 0.0%";
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DownloadInfo *info = [self.infos objectAtIndex:indexPath.row];
    if (info.state == DownloadStateResumed || info.state == DownloadStateWillResume) {
        [[DownloadManager defaultManager] suspend:info.url];
    } else if (info.state == DownloadStateSuspened || info.state == DownloadStateNone) {
        
    } else if (info.state == DownloadStateCompleted) {
        
    }
}

#pragma mark - Property
- (UIButton *)startButton {
    if (_startButton == nil) {
        _startButton = [[UIButton alloc] init];
        [_startButton setTitle:@"全部开始" forState:UIControlStateNormal];
        [_startButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_startButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startButton;
}

- (UIButton *)pauseButton {
    if (_pauseButton == nil) {
        _pauseButton = [[UIButton alloc] init];
        [_pauseButton setTitle:@"全部暂停" forState:UIControlStateNormal];
        [_pauseButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_pauseButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pauseButton;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
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
