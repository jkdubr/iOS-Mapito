//
//  MOBFormTagsCollectionCell.m
//  Mapito simple
//
//  Created by Jakub Dubrovsky on 05/04/14.
//  Copyright (c) 2014 Mobera. All rights reserved.
//

#import "MOBFormTagsCollectionCell.h"



@implementation MOBFormTagsCollectionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.labelTitle = [UILabel new];
        [self.labelTitle setFont:[UIFont systemFontOfSize:13]];
        [self.labelTitle setTextAlignment:NSTextAlignmentCenter];
        [self.labelTitle setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:self.labelTitle];
        
        NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_labelTitle);
        [self addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"|-5-[_labelTitle]-5-|"
                                                                      options:0 metrics:0 views:viewsDictionary]];
        [self addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-3-[_labelTitle]-3-|"
                                                                      options:0 metrics:0 views:viewsDictionary]];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
