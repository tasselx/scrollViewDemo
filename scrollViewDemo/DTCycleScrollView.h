//
//  DTCycleScrollView.h
//  scrollViewDemo
//
//  Created by DT on 14-10-14.
//  Copyright (c) 2014年 DT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DTCycleScrollView;

//滚动方向枚举
enum {
    DTCycleScrollViewDirectionLeft =   0,
    DTCycleScrollViewDirectionRight   =   1,
};typedef NSUInteger DTCycleScrollViewDirection;

@protocol DTCycleScrollViewDelegate <NSObject>

@optional
/**
 *  点击scroolView当前视图的事件
 *
 *  @param scrollView 当前类
 *  @param view       当前视图View
 *  @param index      当前页码
 */
- (void)scroolView:(DTCycleScrollView *)scrollView didClickPage:(UIView *)view atIndex:(NSInteger)index;

@end

@protocol DTCycleScrollViewDatasource <NSObject>

@required
/**
 *  返回总页面数码
 *
 *  @return 总页面
 */
- (NSInteger)numberOfPages;

/**
 *  返回每一个页面的UIView
 *
 *  @param index 当前index
 *  @param size  当前页面的size
 *
 *  @return UIView
 */
- (UIView *)pageAtIndex:(NSInteger)index size:(CGSize)size;

@end

/**
 *  循环滚动ScrollView
 *  可自动滚动也可手动滚动
 */
@interface DTCycleScrollView : UIView

/** UIScrollView */
@property (nonatomic,strong) UIScrollView *scrollView;
/** UIPageControl */
@property (nonatomic,strong) UIPageControl *pageControl;
/** 自动滚动视图间隔 */
@property (nonatomic,assign) NSTimeInterval animationDuration;
/** 自动滚动方向,默认是DTCycleScrollViewDirectionRight */
@property (nonatomic,assign) DTCycleScrollViewDirection direction;

/** datasource */
@property (nonatomic,weak,setter = setDataource:) id<DTCycleScrollViewDatasource> datasource;

/** delegate */
@property (nonatomic,weak,setter = setDelegate:) id<DTCycleScrollViewDelegate> delegate;

/** 重新加载数据 */
- (void)reloadData;

@end
