//
//  SLLTimePickerViewController.m
//  SLLCircularSlider
//
//  This is based on the SLLCircularSlider from Eliot Fowler
//  https://github.com/eliotfowler/SLLCircularSlider
//  Created by Eliot Fowler on 12/5/13.
//  Copyright (c) 2013 Eliot Fowler. All rights reserved.
//

#import "SLLTimePickerViewController.h"
#import "SLLCircularSlider.h"

@interface SLLTimePickerViewController ()

@end

@implementation SLLTimePickerViewController {
    SLLCircularSlider* minuteSlider;
    SLLCircularSlider* hourSlider;
}

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
    self.view.backgroundColor = [UIColor colorWithRed:31/255.0f green:61/255.0f blue:91/255.0f alpha:1.0f];
    CGRect minuteSliderFrame = CGRectMake(5, 170, 310, 310);
    minuteSlider = [[SLLCircularSlider alloc] initWithFrame:minuteSliderFrame];
    minuteSlider.unfilledColor = [UIColor colorWithRed:23/255.0f green:47/255.0f blue:70/255.0f alpha:1.0f];
    minuteSlider.filledColor = [UIColor colorWithRed:155/255.0f green:211/255.0f blue:156/255.0f alpha:1.0f];
    [minuteSlider setInnerMarkingLabels:@[@"5", @"10", @"15", @"20", @"25", @"30", @"35", @"40", @"45", @"50", @"55", @"60"]];
    minuteSlider.labelFont = [UIFont systemFontOfSize:14.0f];
    minuteSlider.lineWidth = 8;
    minuteSlider.minimumValue = 0;
    minuteSlider.maximumValue = 60;
    minuteSlider.labelColor = [UIColor colorWithRed:76/255.0f green:111/255.0f blue:137/255.0f alpha:1.0f];
    minuteSlider.handleType = SLLDoubleCircleWithOpenCenter;
    minuteSlider.handleColor = minuteSlider.filledColor;
    [self.view addSubview:minuteSlider];
    [minuteSlider addTarget:self action:@selector(minuteDidChange:) forControlEvents:UIControlEventValueChanged];
    
    CGRect hourSliderFrame = CGRectMake(55, 220, 210, 210);
    hourSlider = [[SLLCircularSlider alloc] initWithFrame:hourSliderFrame];
    hourSlider.unfilledColor = [UIColor colorWithRed:23/255.0f green:47/255.0f blue:70/255.0f alpha:1.0f];
    hourSlider.filledColor = [UIColor colorWithRed:98/255.0f green:243/255.0f blue:252/255.0f alpha:1.0f];
    [hourSlider setInnerMarkingLabels:@[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", @"12"]];
    hourSlider.labelFont = [UIFont systemFontOfSize:14.0f];
    hourSlider.lineWidth = 12;
    hourSlider.snapToLabels = NO;
    hourSlider.minimumValue = 0;
    hourSlider.maximumValue = 12;
    hourSlider.labelColor = [UIColor colorWithRed:127/255.0f green:229/255.0f blue:255/255.0f alpha:1.0f];
    hourSlider.handleType = SLLBigCircle;
    hourSlider.handleColor = hourSlider.filledColor;
    [self.view addSubview:hourSlider];
    [hourSlider addTarget:self action:@selector(hourDidChange:) forControlEvents:UIControlEventValueChanged];
}

-(void)hourDidChange:(SLLCircularSlider*)slider {
    int newVal = (int)slider.currentValue ? (int)slider.currentValue : 12;
    NSString* oldTime = _timeLabel.text;
    NSRange colonRange = [oldTime rangeOfString:@":"];
    _timeLabel.text = [NSString stringWithFormat:@"%d:%@", newVal, [oldTime substringFromIndex:colonRange.location + 1]];
}

-(void)minuteDidChange:(SLLCircularSlider*)slider {
    int newVal = (int)slider.currentValue < 60 ? (int)slider.currentValue : 0;
    NSString* oldTime = _timeLabel.text;
    NSRange colonRange = [oldTime rangeOfString:@":"];
    _timeLabel.text = [NSString stringWithFormat:@"%@:%02d", [oldTime substringToIndex:colonRange.location], newVal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
