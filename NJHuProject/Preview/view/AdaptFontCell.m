//
//  AdaptFontCell.m
//  NJHuProject
//
//  Created by chrisbin on 09/03/2018.
//  Copyright © 2018 chrisbin. All rights reserved.
//

#import "AdaptFontCell.h"
#import <Masonry/Masonry.h>

@interface AdaptFontCell ()

@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *wordLabel;

@end

@implementation AdaptFontCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.dateLabel];
        [self.contentView addSubview:self.wordLabel];
        [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(KTopSpace);
            make.left.mas_equalTo(KLeftSpace);
            make.right.mas_equalTo(-KRightSpace);
        }];
        [self.wordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.dateLabel.mas_bottom).offset(KDateMarginToText);
            make.left.mas_equalTo(KLeftSpace);
            make.right.mas_equalTo(-KRightSpace);
            make.bottom.mas_equalTo(-kBottomSpace);
        }];
    }
    return self;
}

- (void)setParagraph:(Paragraph *)paragraph {
    self.dateLabel.text = paragraph.date;
//    self.wordLabel.text = paragraph.words;
    self.wordLabel.attributedText = paragraph.attrWords;
}

- (UILabel *)dateLabel {
    if (_dateLabel == nil) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.textColor = [UIColor blackColor];
        _dateLabel.font = [UIFont systemFontOfSize:KDateLabelFontSize];
    }
    return _dateLabel;
}

- (UILabel *)wordLabel {
    if (_wordLabel == nil) {
        _wordLabel = [[UILabel alloc] init];
        _wordLabel.textColor = [UIColor grayColor];
        _wordLabel.font = [UIFont systemFontOfSize:KTextLabelFontSize];
        _wordLabel.numberOfLines = 0;
    }
    return _wordLabel;
}

@end
