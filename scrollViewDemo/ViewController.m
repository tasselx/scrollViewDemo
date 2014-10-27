//
//  ViewController.m
//  scrollViewDemo
//
//  Created by DT on 14-10-14.
//  Copyright (c) 2014年 DT. All rights reserved.
//

#import "ViewController.h"
#import "DTCycleScrollView.h"

@interface ViewController ()<DTCycleScrollViewDatasource,DTCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet DTCycleScrollView *scrollView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*
     
    DTCycleScrollView *csView = [[DTCycleScrollView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 350)];
    csView.delegate = self;
    csView.datasource = self;
    csView.backgroundColor = [UIColor greenColor];
//    csView.animationDuration = 1.0f;
    csView.pageControl.frame = CGRectMake(0, 0, 320, 20);
    [self.view addSubview:csView];
    //*/
    
    self.scrollView.delegate = self;
    self.scrollView.datasource = self;
    self.scrollView.animationDuration = 2.0f;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(NSInteger)numberOfPages
{
    return 5;
}


- (UIView *)pageAtIndex:(NSInteger)index size:(CGSize)size
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    view.backgroundColor = [UIColor clearColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, size.width-20, size.height)];
    label.backgroundColor = [UIColor brownColor];
    label.font = [UIFont systemFontOfSize:100.f];
    label.text = [NSString stringWithFormat:@"%li",(long)index];
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    view.tag = index;
    return view;
}

- (void)scroolView:(DTCycleScrollView *)scrollView didClickPage:(UIView *)view atIndex:(NSInteger)index
{
    NSLog(@"tag:%li",(long)view.tag);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:[NSString stringWithFormat:@"%li",(long)index]
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}

@end
