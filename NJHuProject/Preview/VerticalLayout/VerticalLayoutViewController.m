//
//  VerticalLayoutViewController.m
//  NJHuProject
//
//  Created by chrisbin on 09/03/2018.
//  Copyright © 2018 chrisbin. All rights reserved.
//

#import "VerticalLayoutViewController.h"
#import "VerticalFlowLayout.h"
#import "SingleLabelCell.h"

@interface VerticalLayoutViewController ()<VerticalFlowLayoutDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation VerticalLayoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - VerticalFlowLayoutDelegate
- (CGFloat)verticalFlowLayout:(VerticalFlowLayout *)flowLayout collectionView:(UICollectionView *)collectionView heightForItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)width {
    return width * (arc4random() % 4 + 1);
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 50;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SingleLabelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SingleLabelCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor yellowColor];
    cell.label.text = [NSString stringWithFormat:@"%zd", indexPath.item];
    [cell.label sizeToFit];
    return cell;
}

#pragma mark - Property
- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        VerticalFlowLayout *flowLayout = [[VerticalFlowLayout alloc] init];
        flowLayout.delegate = self; 
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        [_collectionView registerClass:[SingleLabelCell class] forCellWithReuseIdentifier:@"SingleLabelCell"];
        _collectionView.dataSource = self;
    }
    return _collectionView;
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
