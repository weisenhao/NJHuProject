//
//  UpLoadImageCell.h
//  NJHuProject
//
//  Created by chrisbin on 19/03/2018.
//  Copyright © 2018 chrisbin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpLoadImageCell : UICollectionViewCell

@property (nonatomic, copy) void(^addPhotoClick)(UpLoadImageCell *cell);
@property (nonatomic, copy) void(^deletePhotoClick)(UIImage *photoImage);
@property (nonatomic, strong) UIImage *photoImage;

@end
