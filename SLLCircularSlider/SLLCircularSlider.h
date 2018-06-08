//
//  SLLCircularSlider.h
//  Awake
//
//  This is based on the SLLCircularSlider from Eliot Fowler
//  https://github.com/eliotfowler/SLLCircularSlider
//  Created by Eliot Fowler on 12/3/13.
//  Copyright (c) 2013 Eliot Fowler. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SLLHandleType) {
    SLLSemiTransparentWhiteCircle,
    SLLSemiTransparentBlackCircle,
    SLLDoubleCircleWithOpenCenter,
    SLLDoubleCircleWithClosedCenter,
    SLLBigCircle
};

@interface SLLCircularSlider : UIControl

@property (nonatomic, readwrite, assign) float minimumValue;
@property (nonatomic, readwrite, assign) float maximumValue;
@property (nonatomic, readwrite, assign) float currentValue;

@property (nonatomic, readwrite, assign) int lineWidth;
@property (nonatomic, readwrite, assign) int lineRadiusDisplacement;
@property (nonatomic, readwrite, null_unspecified, strong) UIColor* filledColor;
@property (nonatomic, readwrite, null_unspecified, strong) UIColor* unfilledColor;

@property (nonatomic, readwrite, assign) int handleSize;
@property (nonatomic, readwrite, null_unspecified, strong) UIColor* handleColor;
@property (nonatomic, readwrite, assign) SLLHandleType handleType;

@property (nonatomic, readwrite, null_unspecified, strong) UIFont* labelFont;
@property (nonatomic, readwrite, null_unspecified, strong) UIColor* labelColor;
@property (nonatomic, readwrite, assign) NSInteger labelDisplacement;
@property (nonatomic, readwrite, assign) BOOL snapToLabels;


/**
 * Sets the text visible on the inner side of the circular view controller with evenly-spaced string
 * @param labels The array of strings that will be displayed on the inner labels
 **/
-(void)setInnerMarkingLabels:(NSArray<NSString *> *)labels;

@end
