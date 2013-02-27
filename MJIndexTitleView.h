//
//  MJIndexTitleView.h
//  DolphinSharing
//
//  Created by Dany on 13-2-26.
//  Copyright (c) 2013年 mojo-tech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^MJIndexTitleViewSelectedHandler)(NSString *title, NSUInteger index);

@interface MJIndexTitleView : UIView

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, copy) MJIndexTitleViewSelectedHandler selectedHandler;

@end
