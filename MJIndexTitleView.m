//
//  MJIndexTitleView.m
//  DolphinSharing
//
//  Created by Dany on 13-2-26.
//  Copyright (c) 2013年 mojo-tech. All rights reserved.
//

#import "MJIndexTitleView.h"

#define HEIGHT_PER_TITLE    10

@implementation MJIndexTitleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initialize];
    }
    return self;
}

- (void)dealloc {
    [self unregisterFromKVO];
}

#pragma mark - init
- (void)initialize {
    self.layer.cornerRadius = 8.0;
    self.layer.masksToBounds = YES;
    [self setHighlight:NO];
    
    [self registerForKVO];
    [self layoutTitles];
}

#pragma mark - Layout
- (void)layoutTitles {
    [self removeAllSubviews];
    
    __block NSUInteger total = self.titles.count;
    [self.titles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self layoutTitle:obj index:idx total:total];
    }];
}

#pragma mark - KVO

- (void)registerForKVO {
	for (NSString *keyPath in [self observableKeypaths]) {
		[self addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:NULL];
	}
}

- (void)unregisterFromKVO {
	for (NSString *keyPath in [self observableKeypaths]) {
		[self removeObserver:self forKeyPath:keyPath];
	}
}

- (NSArray *)observableKeypaths {
	return @[@"titles"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if (![NSThread isMainThread]) {
		[self performSelectorOnMainThread:@selector(updateUIForKeypath:) withObject:keyPath waitUntilDone:NO];
	} else {
		[self updateUIForKeypath:keyPath];
	}
}

- (void)updateUIForKeypath:(NSString *)keyPath {
	if ([keyPath isEqualToString:@"titles"]) {
		[self layoutTitles];
	}
}

#pragma mark - Private
- (void)layoutTitle:(NSString *)title index:(NSUInteger)index total:(NSUInteger)total {
    UILabel *view = [self viewForTitle:title index:index total:total];
    
    [self addSubview:view];
}

- (UILabel *)viewForTitle:(NSString *)title index:(NSUInteger)index total:(NSUInteger)total {
    UILabel *view = [[UILabel alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor clearColor];
    view.textAlignment = UITextAlignmentCenter;
    view.textColor = [UIColor darkGrayColor];
    view.font = [UIFont boldSystemFontOfSize:10.0];
    view.text = title;
    
    view.frame = [self frameForIndex:index total:total];
    
    return view;
}

- (CGRect)frameForIndex:(NSUInteger)index total:(NSUInteger)total {
    CGRect frame = CGRectZero;
    CGRect superFrame = self.frame;
    
    frame.size.width = superFrame.size.width;
    frame.size.height = MAX((superFrame.size.height/(CGFloat)total), HEIGHT_PER_TITLE);
    frame.origin.x = 0;
    frame.origin.y = (superFrame.size.height/(CGFloat)total)*index;
    
    return frame;
}

#pragma mark - Highlight
- (void)setHighlight:(BOOL)isHighlight {
    self.backgroundColor = isHighlight ? [UIColor lightGrayColor] : [UIColor colorWithWhite:0.0 alpha:0.1];
}

#pragma mark - Touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self setHighlight:YES];
    
    CGPoint point = [[touches anyObject] locationInView:self];
    [self selectTitleWithPoint:point];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self setHighlight:YES];
    
    CGPoint point = [[touches anyObject] locationInView:self];
    [self selectTitleWithPoint:point];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self setHighlight:NO];

}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self setHighlight:NO];

}

#pragma mark - Select handle
- (void)selectTitleWithPoint:(CGPoint)point {
    __block NSUInteger total = self.titles.count;

    [self.titles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CGRect frame = [self frameForIndex:idx total:total];
        if (CGRectContainsPoint(frame, point)) {
            
            [self handleSelectWithIndex:idx];
            *stop = YES;
            
        }else {
            // continue;
        }
    }];
    
}

- (void)handleSelectWithIndex:(NSUInteger)index {
    if (self.selectedHandler) {
        self.selectedHandler(self.titles[index], index);
    }
}

@end
