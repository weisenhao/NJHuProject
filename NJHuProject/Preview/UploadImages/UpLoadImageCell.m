//
//  UpLoadImageCell.m
//  NJHuProject
//
//  Created by chrisbin on 19/03/2018.
//  Copyright © 2018 chrisbin. All rights reserved.
//

#import "UpLoadImageCell.h"
#import <Masonry/Masonry.h>

@interface UpLoadImageCell ()

@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation UpLoadImageCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.addBtn];
        [self.contentView addSubview:self.imgView];
        [self.contentView addSubview:self.deleteBtn];
        [self layoutViews];
    }
    return self;
}

#pragma mark - Target Action
- (void)addClick:(UIButton *)btn {
    __weak typeof(self) weakSelf = self;
    if (self.addPhotoClick) {
        self.addPhotoClick(weakSelf);
    }
}

- (void)deleteClick:(UIButton *)btn {
    __weak typeof(self) weakSelf = self;
    if (self.deletePhotoClick) {
        self.deletePhotoClick(weakSelf.photoImage);
    }
}

#pragma mark - Public Method
- (void)setPhotoImage:(UIImage *)photoImage {
    _photoImage = photoImage;
    if (_photoImage) {
        self.addBtn.hidden = YES;
        self.deleteBtn.hidden = NO;
        self.imgView.hidden = NO;
    } else {
        self.addBtn.hidden = NO;
        self.deleteBtn.hidden = YES;
        self.imgView.hidden = YES;
    }
    self.imgView.image = _photoImage;
}

#pragma mark - Layout Views
- (void)layoutViews {
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(4.f);
        make.right.equalTo(self.contentView).offset(-4.f);
        make.size.mas_equalTo(CGSizeMake(20.f, 20.f));
    }];
}

#pragma mark - Property
- (UIButton *)addBtn {
    if (_addBtn == nil) {
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addBtn setImage:[UIImage imageNamed:@"btn_addPicture_BgImage"] forState:UIControlStateNormal];
        [_addBtn addTarget:self action:@selector(addClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;
}

- (UIButton *)deleteBtn {
    if (_deleteBtn == nil) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteBtn.backgroundColor = [UIColor redColor];
        [_deleteBtn setImage:[UIImage imageNamed:@"btn_right_delete_image"] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}

- (UIImageView *)imgView {
    if (_imgView == nil) {
        _imgView = [[UIImageView alloc] init];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.layer.masksToBounds = YES;
    }
    return _imgView;
}

@end
