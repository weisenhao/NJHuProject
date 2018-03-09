//
//  YYFPSLabel.m
//  NJHuProject
//
//  Created by chrisbin on 09/03/2018.
//  Copyright © 2018 chrisbin. All rights reserved.
//

#import "YYFPSLabel.h"
#import <YYText/YYText.h>

#define kSize CGSizeMake(55, 20)

@implementation YYFPSLabel {
    UIFont *_font;
    UIFont *_subFont;
    CADisplayLink *_link;
    NSTimeInterval _lastTime;
    NSUInteger _count;
}

- (instancetype)initWithFrame:(CGRect)frame {
    frame.size = CGSizeEqualToSize(frame.size, CGSizeZero) ? kSize : frame.size;
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = 5.f;
        self.clipsToBounds = YES;
        self.textAlignment = NSTextAlignmentCenter;
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.7f];
        
        _font = [UIFont fontWithName:@"Menlo" size:14];
        _subFont = [UIFont fontWithName:@"Menlo" size:4];
        _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick:)];
        [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
    return self;
}

- (void)dealloc {
    [_link invalidate];
}

#pragma mark - Targer Action
- (void)tick:(CADisplayLink *)link {
    if (_lastTime == 0) {
        _lastTime = link.timestamp;
        return ;
    }
    
    _count++;
    NSTimeInterval delta = link.timestamp - _lastTime;
    if (delta < 1) {
        return ;
    }
    _lastTime = link.timestamp;
    CGFloat fps = _count / delta;
    _count = 0;
    
    CGFloat progress = fps / 60.f;
    UIColor *color = [UIColor colorWithHue:0.27 * (progress - 0.2) saturation:1 brightness:0.9 alpha:1];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d FPS", (int)round(fps)]];
    text.yy_font = _font;
    [text yy_setFont:_subFont range:NSMakeRange(text.length - 4, 1)];
    [text yy_setColor:color range:NSMakeRange(0, text.length - 3)];
    [text yy_setColor:[UIColor whiteColor] range:NSMakeRange(text.length - 3, 3)];
    self.attributedText = text;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
