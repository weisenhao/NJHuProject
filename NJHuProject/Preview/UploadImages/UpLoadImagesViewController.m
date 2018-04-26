//
//  UpLoadImagesViewController.m
//  NJHuProject
//
//  Created by chrisbin on 19/03/2018.
//  Copyright © 2018 chrisbin. All rights reserved.
//

#import "UpLoadImagesViewController.h"
#import "UpLoadImageCell.h"
#import <TZImagePickerController/TZImagePickerController.h>

static const NSInteger maxPhotoCount = 1;

@interface UpLoadImagesViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, TZImagePickerControllerDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray<UIImage *> *selectedImages;
@property (nonatomic, strong) TZImagePickerController *imagePickerCont;
@property (nonatomic, strong) NSMutableArray<PHAsset *> *selectedAccest;

@end

@implementation UpLoadImagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.selectedImages = [NSMutableArray array];
    self.selectedAccest = [NSMutableArray array];
    [self.view addSubview:self.collectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.selectedImages.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UpLoadImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UpLoadImageCell" forIndexPath:indexPath];
    if (indexPath.item == self.selectedImages.count) {
        cell.photoImage = nil;
        cell.deletePhotoClick = nil;
        cell.addPhotoClick = ^(UpLoadImageCell *cell) {
            [self choosePhoto];
        };
    } else {
        cell.photoImage = [self.selectedImages objectAtIndex:indexPath.item];
        cell.addPhotoClick = nil;
        cell.deletePhotoClick = ^(UIImage *photoImage) {
            [self.selectedAccest removeObjectAtIndex:indexPath.item];
            [self.selectedImages removeObjectAtIndex:indexPath.item];
            [self.collectionView reloadData];
        };
    }
    return cell;
}

#pragma mark - TZImagePickerControllerDelegate


#pragma mark - Private Method
- (void)choosePhoto {
    // 设置目前已经选中的图片数组
    self.imagePickerCont.selectedAssets = self.selectedAccest;
    
    __weak typeof(self) weakSelf = self;
    [self.imagePickerCont setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        weakSelf.selectedImages = [NSMutableArray arrayWithArray:photos];
        weakSelf.selectedAccest = [NSMutableArray arrayWithArray:assets];
        [weakSelf.collectionView reloadData];
    }];
    [self presentViewController:self.imagePickerCont animated:YES completion:nil];
}

#pragma mark - Property
- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        CGSize size = self.view.bounds.size;
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.sectionInset = UIEdgeInsetsMake(2, 2, 2, 2);
        flowLayout.minimumLineSpacing = 2.f;
        flowLayout.minimumInteritemSpacing = 2.f;
        CGFloat itemWH = (size.width - 10.f) / 4.f;
        flowLayout.itemSize = CGSizeMake(itemWH, itemWH);
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        [_collectionView registerClass:[UpLoadImageCell class] forCellWithReuseIdentifier:@"UpLoadImageCell"];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
    }
    return _collectionView;
}

- (TZImagePickerController *)imagePickerCont {
    if (_imagePickerCont == nil) {
        _imagePickerCont = [[TZImagePickerController alloc] initWithMaxImagesCount:maxPhotoCount delegate:self];
//        _imagePickerCont.allowTakePicture = YES;        // 默认为YES，如果设置为NO,拍照按钮将隐藏,用户将不能选择照片
        // 设置是否可以选择视频/图片/原图
//        _imagePickerCont.allowPickingVideo = NO;
//        _imagePickerCont.allowPickingImage = YES;
        _imagePickerCont.allowPickingOriginalPhoto = NO;
        
//        _imagePickerCont.allowPickingGif = NO;
//        _imagePickerCont.allowPickingMultipleVideo = NO; // 是否可以多选视频
        // 照片排列按修改时间升序
//        _imagePickerCont.sortAscendingByModificationDate = YES;
//        _imagePickerCont.showSelectBtn = NO;
//        _imagePickerCont.allowCrop = YES;
//        _imagePickerCont.needCircleCrop = NO;
    }
    return _imagePickerCont;
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
