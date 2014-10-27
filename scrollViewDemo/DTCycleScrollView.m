//
//  DTCycleScrollView.m
//  scrollViewDemo
//
//  Created by DT on 14-10-14.
//  Copyright (c) 2014年 DT. All rights reserved.
//

#import "DTCycleScrollView.h"
@interface DTCycleScrollView()<UIScrollViewDelegate>

//当前页码
@property (nonatomic,assign) int currentPage;
//总页码
@property (nonatomic,assign) int totalPages;
//页面View集合,固定
@property (nonatomic,strong) NSMutableArray *curViews;
//定时器
@property (nonatomic,strong) NSTimer *animationTimer;

@end

@implementation DTCycleScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.animationDuration = 0;
        self.direction = DTCycleScrollViewDirectionRight;
        [self initScrollView];
    }
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.animationDuration = 0;
        self.direction = DTCycleScrollViewDirectionRight;
        [self initScrollView];
    }
    return self;
}

/**
 *  初始化scrollView
 */
- (void)initScrollView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(self.bounds.size.width * 3, self.bounds.size.height);
    self.scrollView.contentOffset = CGPointMake(self.bounds.size.width, 0);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    [self addSubview:self.scrollView];
    
    CGRect rect = self.bounds;
    rect.origin.y = rect.size.height - 25;
    rect.size.height = 25;
    self.pageControl = [[UIPageControl alloc] initWithFrame:rect];
    self.pageControl.userInteractionEnabled = NO;
    
    [self addSubview:self.pageControl];
    
    self.currentPage = 0;
}

/**
 *  设置自动滚动间隔时间,以秒为单位,时间大于0
 *
 *  @param animationDuration 间隔时间
 */
- (void)setAnimationDuration:(NSTimeInterval)animationDuration
{
    _animationDuration = animationDuration;
    if (animationDuration > 0.0) {//时间间隔大于0创建NSTimer
        self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:animationDuration target:self selector:@selector(animationTimerDidFired:) userInfo:nil repeats:YES];
    }
}

- (void)setDataource:(id<DTCycleScrollViewDatasource>)datasource
{
    _datasource = datasource;
    [self reloadData];
}

/**
 *  刷新scrollView
 */
- (void)reloadData
{
    self.totalPages = (int)[self.datasource numberOfPages];
    if (self.totalPages == 0) {
        return;
    }
    self.pageControl.numberOfPages = self.totalPages;
    [self loadData];
}

/**
 *  创建页面View
 */
- (void)loadData
{
    self.pageControl.currentPage = self.currentPage;
    
    //从scrollView上移除所有的subview
    NSArray *subViews = [self.scrollView subviews];
    if([subViews count] != 0) {
        [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    [self getDisplayImagesWithCurpage:self.currentPage];
    
    for (int i = 0; i < 3; i++) {
        UIView *v = [self.curViews objectAtIndex:i];
        v.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [v addGestureRecognizer:singleTap];
        v.frame = CGRectOffset(v.frame, v.frame.size.width * i, 0);
        [self.scrollView addSubview:v];
    }
    if (self.totalPages == 1) {
        self.scrollView.contentSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height);
        [self.scrollView setContentOffset:CGPointMake(0, 0)];
    }else{
        self.scrollView.contentSize = CGSizeMake(self.bounds.size.width * 3, self.bounds.size.height);
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width, 0)];
    }
}

/**
 *  获取scrollView 内容
 *
 *  @param page 页码
 */
- (void)getDisplayImagesWithCurpage:(int)page {
    
    int pre = [self validPageValue:self.currentPage-1];
    int last = [self validPageValue:self.currentPage+1];
    
    if (!self.curViews) {
        self.curViews = [[NSMutableArray alloc] init];
    }
    
    [self.curViews removeAllObjects];
    CGSize size = CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    [self.curViews addObject:[self.datasource pageAtIndex:pre size:size]];
    [self.curViews addObject:[self.datasource pageAtIndex:page size:size]];
    [self.curViews addObject:[self.datasource pageAtIndex:last size:size]];
}

- (int)validPageValue:(int)value {
    
    if(value == -1){
        value = self.totalPages - 1;
    }else if(value == self.totalPages) {
        value = 0 ;
    }
    return value;
}

- (void)handleTap:(UITapGestureRecognizer *)tap {
    if ([self.delegate respondsToSelector:@selector(scroolView:didClickPage:atIndex:)]) {
        [self.delegate scroolView:self didClickPage:tap.view atIndex:self.currentPage];
    }
}

- (void)animationTimerDidFired:(NSTimer*)timer
{
    if (self.totalPages >1) {
        if (self.direction == DTCycleScrollViewDirectionLeft) {
            CGPoint offset = CGPointMake(self.scrollView.contentOffset.x - CGRectGetWidth(self.scrollView.frame), self.scrollView.contentOffset.y);
            [self.scrollView setContentOffset:offset animated:YES];
        }else{
            CGPoint offset = CGPointMake(self.scrollView.contentOffset.x + CGRectGetWidth(self.scrollView.frame), self.scrollView.contentOffset.y);
            [self.scrollView setContentOffset:offset animated:YES];
        }
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.animationTimer) {
        [self.animationTimer setFireDate:[NSDate distantFuture]];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.animationTimer) {
        [self performSelector:@selector(timerFire) withObject:nil afterDelay:self.animationDuration];
    }
}

- (void)timerFire
{
    [self.animationTimer setFireDate:[NSDate date]];
}

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    int x = aScrollView.contentOffset.x;
    //往下翻一张
    if(x >= (2*self.frame.size.width)) {
        self.currentPage = [self validPageValue:self.currentPage+1];
        [self loadData];
    }
    //往上翻
    if(x <= 0) {
        self.currentPage = [self validPageValue:self.currentPage-1];
        [self loadData];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width, 0) animated:YES];
}

@end
