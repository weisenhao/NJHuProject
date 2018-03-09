//
//  Paragraph.m
//  NJHuProject
//
//  Created by chrisbin on 09/03/2018.
//  Copyright © 2018 chrisbin. All rights reserved.
//

#import "Paragraph.h"

const CGFloat KTopSpace = 10;
const CGFloat KLeftSpace = 15;
const CGFloat KRightSpace = 15;
const CGFloat kBottomSpace = 10;
const CGFloat KDateMarginToText = 10;
const CGFloat KDateLabelFontSize = 17;
const CGFloat KTextLabelFontSize = 15;

@implementation Paragraph

@synthesize attrWords = _attrWords;

- (NSAttributedString *)attrWords {
    if (_attrWords == nil) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 4;
        _attrWords = [[NSAttributedString alloc] initWithString:self.words attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:KTextLabelFontSize], NSParagraphStyleAttributeName: paragraphStyle}];
    }
    return _attrWords;
}

@end
