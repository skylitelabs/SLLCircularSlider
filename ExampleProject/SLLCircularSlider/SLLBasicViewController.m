//
//  SLLBasicViewController.m
//  SLLCircularSlider
//
//  This is based on the SLLCircularSlider from Eliot Fowler
//  https://github.com/eliotfowler/SLLCircularSlider
//  Created by Eliot Fowler on 12/4/13.
//  Copyright (c) 2013 Eliot Fowler. All rights reserved.
//

#import "SLLBasicViewController.h"
#import "SLLCircularSlider.h"

@interface SLLBasicViewController ()

@end

@implementation SLLBasicViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect sliderFrame = CGRectMake(60, 150, 200, 200);
    SLLCircularSlider* circularSlider = [[SLLCircularSlider alloc] initWithFrame:sliderFrame];
    [circularSlider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:circularSlider];
    [circularSlider setCurrentValue:10.0f];
}

-(void)valueChanged:(SLLCircularSlider*)slider {
    _valueLabel.text = [NSString stringWithFormat:@"%.02f", slider.currentValue ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
