//
//  SLLDoubleCircleViewController.m
//  SLLCircularSlider
//
//  This is based on the SLLCircularSlider from Eliot Fowler
//  https://github.com/eliotfowler/SLLCircularSlider
//  Created by Eliot Fowler on 12/5/13.
//  Copyright (c) 2013 Eliot Fowler. All rights reserved.
//

#import "SLLDoubleCircleViewController.h"
#import "SLLCircularSlider.h"

@interface SLLDoubleCircleViewController ()

@end

@implementation SLLDoubleCircleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect sliderFrame = CGRectMake(60, 150, 200, 200);
    SLLCircularSlider* circularSlider = [[SLLCircularSlider alloc] initWithFrame:sliderFrame];
    circularSlider.handleType = SLLDoubleCircleWithOpenCenter;
    [self.view addSubview:circularSlider];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
