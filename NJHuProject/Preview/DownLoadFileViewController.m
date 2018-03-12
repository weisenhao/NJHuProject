//
//  DownLoadFileViewController.m
//  NJHuProject
//
//  Created by chrisbin on 12/03/2018.
//  Copyright © 2018 chrisbin. All rights reserved.
//

#import "DownLoadFileViewController.h"
#import "MBProgressHUD+Custom.h"
#import "RequestManager.h"
#import <Toast/Toast.h>

@interface DownLoadFileViewController ()

@property (nonatomic, strong) UIButton *downButton;

@end

@implementation DownLoadFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    CGSize size = self.view.bounds.size;
    self.downButton = [[UIButton alloc] initWithFrame:CGRectMake(10.f, 70.f, size.width - 20.f, 30.f)];
    [self.downButton setTitle:@"点击下载 - 不会重复下载" forState:UIControlStateNormal];
    [self.downButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.downButton addTarget:self action:@selector(downloadFile) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.downButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)downloadFile {
    /*
     1.NSURLRequestUseProtocolCachePolicy NSURLRequest   默认的cache policy，使用Protocol协议定义。
     2.NSURLRequestReloadIgnoringCacheData               忽略缓存直接从原始地址下载。
     3.NSURLRequestReturnCacheDataDontLoad               只使用cache数据，如果不存在cache，请求失败；用于没有建立网络连接离线模式
     4.NSURLRequestReturnCacheDataElseLoad               只有在cache中不存在data时才从原始地址下载。
     5.NSURLRequestReloadIgnoringLocalAndRemoteCacheData   忽略本地和远程的缓存数据，直接从原始地址下载，与NSURLRequestReloadIgnoringCacheData类似。
     6.NSURLRequestReloadRevalidatingCacheData             验证本地数据与远程数据是否相同，如果不同则下载远程数据，否则使用本地数据
     */
    NSString *fileDownLoadPath = @"https://s3.cn-north-1.amazonaws.com.cn/zplantest.s3.seed.meme2c.com/area/area.json";
    NSString *lastModified = [[NSUserDefaults standardUserDefaults] stringForKey:@"Last-Modified"] ?: @"";
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:fileDownLoadPath]];
//    服务器做对比, 不用重复下载
    [request setValue:lastModified forHTTPHeaderField:@"If-Modified-Since"];
    [request setValue:@"no-cache" forHTTPHeaderField:@"Cache-Control"];
    
    NSLog(@"request: %@", request);
    MBProgressHUD *hud = [MBProgressHUD showProgressToView:self.view Text:@"下载中..."];
    NSURLSessionDownloadTask *task = [[RequestManager sharedManager] downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        hud.progress = downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
        NSLog(@"progress: %f", hud.progress);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        return [NSURL fileURLWithPath:[path stringByAppendingPathComponent:[fileDownLoadPath lastPathComponent]]];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSString *codeExplain = [NSString stringWithFormat:@"statuscode: %zd, \n200是下载成功, 304是不用下载", httpResponse.statusCode];
        [self.view makeToast:codeExplain];
        
        NSString *lastModified = [httpResponse allHeaderFields][@"Last-Modified"];
        if (lastModified && !error) {
            [NSUserDefaults.standardUserDefaults setObject:lastModified forKey:@"Last-Modified"];
        }
        NSLog(@"lastModified: %@", lastModified);
    }];
    [task resume];
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
