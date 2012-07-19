//
//  MTAlphabetIndexView.h
//  TestTransform
//
//  Created by jesse on 12-7-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MTAlphabetIndexViewDelegate;

@interface MTAlphabetIndexView : UIView

@property (nonatomic, assign) id<MTAlphabetIndexViewDelegate> delegate;

- (NSString *)alphabetAtIndex:(NSInteger)index;
- (void)setIndex:(NSInteger)index enabled:(BOOL)enabled;
- (void)setEnabledIndexes:(NSArray *)indexes;
- (void)show;

@end


@protocol MTAlphabetIndexViewDelegate <NSObject>

@optional
- (void)alphabetIndexView:(MTAlphabetIndexView *)indexView alphabetDidSelect:(NSInteger)index;

@end