//
//  NewsCell.m
//  Rimi
//
//  Created by 王志龙 on 15/8/19.
//  Copyright (c) 2015年 wangzhilong. All rights reserved.
//

#import "NewsCell.h"

@implementation NewsCell

- (void)awakeFromNib {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] <= 8) {
        self.newsTitle.preferredMaxLayoutWidth = self.newsTitle.bounds.size.width;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
