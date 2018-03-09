//
//  Paragraph.h
//  NJHuProject
//
//  Created by chrisbin on 09/03/2018.
//  Copyright © 2018 chrisbin. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN const CGFloat KTopSpace;
UIKIT_EXTERN const CGFloat KLeftSpace;
UIKIT_EXTERN const CGFloat KRightSpace;
UIKIT_EXTERN const CGFloat kBottomSpace;
UIKIT_EXTERN const CGFloat KDateMarginToText;
UIKIT_EXTERN const CGFloat KDateLabelFontSize;
UIKIT_EXTERN const CGFloat KTextLabelFontSize;

@interface Paragraph : NSObject

@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *words;
@property (nonatomic, strong, readonly) NSAttributedString *attrWords;

@end
