//
//  IntroductoryPagesView.m
//  NJHuProject
//
//  Created by chrisbin on 09/03/2018.
//  Copyright © 2018 chrisbin. All rights reserved.
//

#import "IntroductoryPagesView.h"
#import <YYCategories/YYCGUtilities.h>
#import <YYImage/YYImage.h>

@interface IntroductoryPagesView ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSArray<NSString *> *images;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation IntroductoryPagesView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.scrollView];
        [self addSubview:self.pageControl];
        // 添加手势
        UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapFrom)];
        singleRecognizer.numberOfTapsRequired = 1;
        [self.scrollView addGestureRecognizer:singleRecognizer];
    }
    return self;
}

+ (instancetype)pagesViewWithFrame:(CGRect)frame images:(NSArray<NSString *> *)images {
    IntroductoryPagesView *view = [[IntroductoryPagesView alloc] initWithFrame:frame];
    view.images = images;
    return view;
}

#pragma mark - Target Action
- (void)handleSingleTapFrom {
    if (_pageControl.currentPage == self.images.count - 1) {
        [self removeFromSuperview];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger page = (scrollView.contentOffset.x / self.bounds.size.width + 0.5);
    self.pageControl.currentPage = page;
    self.pageControl.hidden = (page > self.images.count - 1);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x >= self.images.count * self.bounds.size.width) {
        [self removeFromSuperview];
    }
}

#pragma mark - Private Method
- (void)loadPageView {
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CGSize size = self.bounds.size;
    self.scrollView.contentSize = CGSizeMake((self.images.count + 1) * size.width, size.height);
    self.pageControl.numberOfPages = self.images.count;
    
    [self.images enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        YYAnimatedImageView *imageView = [[YYAnimatedImageView alloc] init];
        imageView.frame = CGRectMake(idx * size.width, 0, size.width, size.height);
        YYImage *image = [YYImage imageNamed:obj];
        [imageView setImage:image];
        [self.scrollView addSubview:imageView];
    }];
}

#pragma mark - Property
- (void)setImages:(NSArray<NSString *> *)images {
    _images = images;
    [self loadPageView];
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UIPageControl *)pageControl {
    if (_pageControl == nil) {
        CGSize size = self.bounds.size;
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(size.width / 2.f, size.height - 60.f, 0, 40.f)];
        _pageControl.backgroundColor = [UIColor yellowColor];
        _pageControl.pageIndicatorTintColor = [UIColor brownColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    }
    return _pageControl;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
