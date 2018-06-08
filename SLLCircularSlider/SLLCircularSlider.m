//
//  SLLCircularSlider.m
//  Awake
//
//  This is based on the SLLCircularSlider from Eliot Fowler
//  https://github.com/eliotfowler/SLLCircularSlider
//  Created by Eliot Fowler on 12/3/13.
//  Copyright (c) 2013 Eliot Fowler. All rights reserved.
//

#import "SLLCircularSlider.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreImage/CoreImage.h>

#define kDefaultFontSize 14.0f;
#define ToRad(deg) 		( (M_PI * (deg)) / 180.0 )
#define ToDeg(rad)		( (180.0 * (rad)) / M_PI )
#define SQR(x)			( (x) * (x) )

@interface SLLCircularSlider ()

@property (nonatomic, readonly, assign) CGFloat radius;
@property (nonatomic, readwrite, nullable, strong) NSMutableDictionary *labelsWithPercents;
@property (nonatomic, readwrite, nullable, copy) NSArray<NSString *> *labelsEvenSpacing;
@property (nonatomic, readwrite, assign) int fixedAngle;
@property (nonatomic, readwrite, assign) int angle;

@end

@implementation SLLCircularSlider

- (void)defaults {
    // Defaults
    _maximumValue = 100.0f;
    _minimumValue = 0.0f;
    self.currentValue = 0.0f;
    self.lineWidth = 5;
    self.lineRadiusDisplacement = 0;
    self.unfilledColor = [UIColor blackColor];
    self.filledColor = [UIColor redColor];
    self.handleColor = self.filledColor;
    self.labelFont = [UIFont systemFontOfSize:10.0f];
    self.snapToLabels = NO;
    self.handleSize = -1;
    self.handleType = SLLSemiTransparentWhiteCircle;
    self.labelColor = [UIColor redColor];
    self.labelDisplacement = 2;
    
    self.backgroundColor = [UIColor clearColor];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self defaults];
        [self setFrame:frame];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self=[super initWithCoder:aDecoder])){
        [self defaults];
    }
    
    return self;
}


#pragma mark - Setter/Getter

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.angle = [self angleFromValue];
}

- (CGFloat)radius {
    //radius = self.frame.size.height/2 - [self circleDiameter]/2;
    return self.frame.size.height / 2 - self.lineWidth / 2 -
            ([self circleDiameter] - self.lineWidth) - self.lineRadiusDisplacement;
}

- (void)setCurrentValue:(float)currentValue {
    _currentValue = currentValue;
    
    if (self.currentValue > self.maximumValue) {
        _currentValue = self.maximumValue;
    } else if (self.currentValue < self.minimumValue) {
        _currentValue = self.minimumValue;
    }
    
    self.angle = [self angleFromValue];
    [self setNeedsLayout];
    [self setNeedsDisplay];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)setMaximumValue:(float)maximumValue {
    _maximumValue = maximumValue;
    
    if (self.maximumValue < self.minimumValue) {
        _maximumValue = self.minimumValue;
    }
    if (self.currentValue > self.maximumValue) {
        self.currentValue = self.maximumValue;
    }
    [self setNeedsLayout];
    [self setNeedsDisplay];
}

- (void)setMinimumValue:(float)minimumValue {
    _minimumValue = minimumValue;
    
    if (self.minimumValue > self.maximumValue) {
        _minimumValue = self.maximumValue;
    }
    if (self.currentValue < self.minimumValue) {
        self.currentValue = self.minimumValue;
    }
    [self setNeedsLayout];
    [self setNeedsDisplay];
}

#pragma mark - drawing methods

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //Draw the unfilled circle
    CGContextAddArc(ctx,
                    self.frame.size.width / 2,
                    self.frame.size.height / 2,
                    self.radius,
                    0,
                    M_PI * 2,
                    0);
    [self.unfilledColor setStroke];
    CGContextSetLineWidth(ctx, self.lineWidth);
    CGContextSetLineCap(ctx, kCGLineCapButt);
    CGContextDrawPath(ctx, kCGPathStroke);
    
    
    //Draw the filled circle
    if ((self.handleType == SLLDoubleCircleWithClosedCenter || self.handleType == SLLDoubleCircleWithOpenCenter) &&
        self.fixedAngle > 5) {
        CGContextAddArc(ctx,
                        self.frame.size.width / 2,
                        self.frame.size.height / 2,
                        self.radius,
                        3 * M_PI / 2,
                        3 * M_PI / 2 - ToRad(self.angle + 3),
                        0);
    } else {
        CGContextAddArc(ctx,
                        self.frame.size.width / 2,
                        self.frame.size.height / 2,
                        self.radius,
                        3 * M_PI / 2,
                        3 * M_PI / 2 - ToRad(self.angle),
                        0);
    }
    [self.filledColor setStroke];
    CGContextSetLineWidth(ctx, self.lineWidth);
    CGContextSetLineCap(ctx, kCGLineCapButt);
    CGContextDrawPath(ctx, kCGPathStroke);
    
    //Add the labels (if necessary)
    if(self.labelsEvenSpacing) {
        [self drawLabels:ctx];
    }
    
    //The draggable part
    [self drawHandle:ctx];
}

-(void) drawHandle:(CGContextRef)ctx {
    CGContextSaveGState(ctx);
    CGPoint handleCenter =  [self pointFromAngle:self.angle];
    if (self.handleType == SLLSemiTransparentWhiteCircle) {
        [[UIColor colorWithWhite:1.0 alpha:0.7] set];
        CGContextFillEllipseInRect(ctx,
                                   CGRectMake(handleCenter.x,
                                              handleCenter.y,
                                              self.lineWidth,
                                              self.lineWidth));
    } else if (self.handleType == SLLSemiTransparentBlackCircle) {
        [[UIColor colorWithWhite:0.0 alpha:0.7] set];
        CGContextFillEllipseInRect(ctx,
                                   CGRectMake(handleCenter.x,
                                              handleCenter.y,
                                              self.lineWidth,
                                              self.lineWidth));
    } else if (self.handleType == SLLDoubleCircleWithClosedCenter) {
        [self.handleColor set];
        CGContextAddArc(ctx,
                        handleCenter.x + (self.lineWidth) / 2,
                        handleCenter.y + (self.lineWidth) / 2,
                        self.lineWidth,
                        0,
                        M_PI * 2,
                        0);
        CGContextSetLineWidth(ctx, 7);
        CGContextSetLineCap(ctx, kCGLineCapButt);
        CGContextDrawPath(ctx, kCGPathStroke);
        
        CGContextFillEllipseInRect(ctx,
                                   CGRectMake(handleCenter.x,
                                              handleCenter.y,
                                              self.lineWidth - 1,
                                              self.lineWidth - 1));
    } else if (self.handleType == SLLDoubleCircleWithOpenCenter) {
        [self.handleColor set];
        CGContextAddArc(ctx,
                        handleCenter.x + (self.lineWidth / 2),
                        handleCenter.y + (self.lineWidth / 2),
                        (self.lineWidth / 2) + 5,
                        0,
                        M_PI * 2,
                        0);
        CGContextSetLineWidth(ctx, 4);
        CGContextSetLineCap(ctx, kCGLineCapButt);
        CGContextDrawPath(ctx, kCGPathStroke);
        
        CGContextAddArc(ctx,
                        handleCenter.x + (self.lineWidth / 2),
                        handleCenter.y + (self.lineWidth / 2),
                        self.lineWidth / 2,
                        0,
                        M_PI * 2,
                        0);
        CGContextSetLineWidth(ctx, 2);
        CGContextSetLineCap(ctx, kCGLineCapButt);
        CGContextDrawPath(ctx, kCGPathStroke);
    } else if (self.handleType == SLLBigCircle) {
        [self.handleColor set];
        CGContextFillEllipseInRect(ctx,
                                   CGRectMake(handleCenter.x - 2.5,
                                              handleCenter.y - 2.5,
                                              self.lineWidth + 5,
                                              self.lineWidth + 5));
    }
    
    CGContextRestoreGState(ctx);
}

- (BOOL)pointInside:(CGPoint)point
          withEvent:(UIEvent *)event {
    CGPoint p1 = [self centerPoint];
    CGPoint p2 = point;
    CGFloat xDist = (p2.x - p1.x);
    CGFloat yDist = (p2.y - p1.y);
    double distance = sqrt((xDist * xDist) + (yDist * yDist));
    return distance < (self.radius + 11);
}

-(void) drawLabels:(CGContextRef)ctx {
    if (!self.labelsEvenSpacing || [self.labelsEvenSpacing count] == 0) {
        return;
    } else {
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_7_0
        NSDictionary *attributes = @{NSFontAttributeName: self.labelFont,
                                     NSForegroundColorAttributeName: self.labelColor
                                    };
#endif
        
        CGFloat fontSize = ceilf(self.labelFont.pointSize);
        
        NSInteger distanceToMove = (-([self circleDiameter]) / 2) - (fontSize / 2) - self.labelDisplacement;
        
        for (int i=0; i < [self.labelsEvenSpacing count]; i++)
        {
            NSString *label = self.labelsEvenSpacing[[self.labelsEvenSpacing count] - i - 1];
            CGFloat percentageAlongCircle = i / (float)[self.labelsEvenSpacing count];
            CGFloat degreesForLabel = percentageAlongCircle * 360;
            
            CGSize labelSize = CGSizeMake([self widthOfString:label
                                                     withFont:self.labelFont],
                                          [self heightOfString:label
                                                      withFont:self.labelFont]);
            CGPoint closestPointOnCircleToLabel = [self pointFromAngle:degreesForLabel
                                                        withObjectSize:labelSize];

            CGRect labelLocation = CGRectMake(closestPointOnCircleToLabel.x,
                                              closestPointOnCircleToLabel.y,
                                              labelSize.width,
                                              labelSize.height);
            
            CGPoint centerPoint = CGPointMake(self.frame.size.width / 2,
                                              self.frame.size.height / 2);
            float radiansTowardsCenter = ToRad(AngleFromNorth(centerPoint,
                                                              closestPointOnCircleToLabel,
                                                              NO));
            
            labelLocation.origin.x = (labelLocation.origin.x + distanceToMove * cos(radiansTowardsCenter));
            labelLocation.origin.y = (labelLocation.origin.y + distanceToMove * sin(radiansTowardsCenter));
            
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_7_0
            [label drawInRect:labelLocation
               withAttributes:attributes];
#else
            [_labelColor setFill];
            [label drawInRect:labelLocation
                     withFont:_labelFont];
#endif
        }
    }
}

#pragma mark - UIControl functions

-(BOOL) beginTrackingWithTouch:(UITouch *)touch
                     withEvent:(UIEvent *)event {
    [super beginTrackingWithTouch:touch
                        withEvent:event];
    
    return YES;
}

-(BOOL) continueTrackingWithTouch:(UITouch *)touch
                        withEvent:(UIEvent *)event {
    [super continueTrackingWithTouch:touch withEvent:event];
    
    CGPoint lastPoint = [touch locationInView:self];
    [self moveHandle:lastPoint];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    return YES;
}

-(void)endTrackingWithTouch:(UITouch *)touch
                  withEvent:(UIEvent *)event{
    [super endTrackingWithTouch:touch
                      withEvent:event];
    if (self.snapToLabels && self.labelsEvenSpacing) {
        CGFloat newAngle = 0;
        float minDist = 360;
        for (int i = 0; i < [self.labelsEvenSpacing count]; ++i) {
            CGFloat percentageAlongCircle = i / (float)[self.labelsEvenSpacing count];
            CGFloat degreesForLabel = percentageAlongCircle * 360;
            if (fabs(self.fixedAngle - degreesForLabel) < minDist) {
                newAngle = degreesForLabel ? 360 - degreesForLabel : 0;
                minDist = fabs(self.fixedAngle - degreesForLabel);
            }
        }
        self.angle = newAngle;
        _currentValue = [self valueFromAngle];
        [self setNeedsDisplay];
    }
}

-(void)moveHandle:(CGPoint)point {
    CGPoint centerPoint;
    centerPoint = [self centerPoint];
    int currentAngle = floor(AngleFromNorth(centerPoint,
                                            point,
                                            NO));
    self.angle = 360 - 90 - currentAngle;
    _currentValue = [self valueFromAngle];
    [self setNeedsDisplay];
}

- (CGPoint)centerPoint {
    return CGPointMake(self.frame.size.width / 2,
                       self.frame.size.height / 2);
}

#pragma mark - helper functions

-(CGPoint)pointFromAngle:(int)angleInt{
    
    //Define the Circle center
    CGPoint centerPoint = CGPointMake(self.frame.size.width / 2 - self.lineWidth / 2,
                                      self.frame.size.height / 2 - self.lineWidth / 2);
    
    //Define The point position on the circumference
    CGPoint result;
    result.y = round(centerPoint.y + self.radius * sin(ToRad(-(angleInt) - 90))) ;
    result.x = round(centerPoint.x + self.radius * cos(ToRad(-(angleInt) - 90)));
    
    return result;
}

-(CGPoint)pointFromAngle:(int)angleInt
          withObjectSize:(CGSize)size{
    
    //Define the Circle center
    CGPoint centerPoint = CGPointMake(self.frame.size.width / 2 - size.width / 2,
                                      self.frame.size.height / 2 - size.height / 2);
    
    //Define The point position on the circumference
    CGPoint result;
    result.y = round(centerPoint.y + self.radius * sin(ToRad(-(angleInt) - 90))) ;
    result.x = round(centerPoint.x + self.radius * cos(ToRad(-(angleInt) - 90)));
    
    return result;
}

- (CGFloat)circleDiameter {
    switch (self.handleType) {
        case SLLSemiTransparentWhiteCircle:
            return self.lineWidth;
            break;
        case SLLSemiTransparentBlackCircle:
            return self.lineWidth;
            break;
        case SLLDoubleCircleWithClosedCenter:
            return self.lineWidth * 2 + 3.5;
            break;
        case SLLDoubleCircleWithOpenCenter:
            return self.lineWidth + 2.5 + 2;
            break;
        case SLLBigCircle:
            return self.lineWidth + 2.5;
            break;
        default:
            return 0;
            break;
    }
}

static inline float AngleFromNorth(CGPoint p1,
                                   CGPoint p2,
                                   BOOL flipped) {
    CGPoint v = CGPointMake(p2.x - p1.x,
                            p2.y - p1.y);
    float vmag = sqrt(SQR(v.x) + SQR(v.y));
    float result = 0;
    v.x /= vmag;
    v.y /= vmag;
    double radians = atan2(v.y,v.x);
    result = ToDeg(radians);
    return (result >= 0 ? result : (result + 360.0));
}

-(float)valueFromAngle {
    if(self.angle < 0) {
        _currentValue = -self.angle;
    } else {
        _currentValue = 270 - self.angle + 90;
    }
    self.fixedAngle = self.currentValue;
    return ((self.currentValue * (self.maximumValue - self.minimumValue)) / 360.0f) + self.minimumValue;
}

- (float)angleFromValue {
    self.angle = 360 - (360.0f * (self.currentValue - self.minimumValue) / (self.maximumValue - self.minimumValue));
    
    if (self.angle == 360) {
        self.angle = 0;
    }
    
    return self.angle;
}

- (CGFloat) widthOfString:(NSString *)string
                 withFont:(UIFont*)font {
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    return [[[NSAttributedString alloc] initWithString:string
                                            attributes:attributes] size].width;
}

- (CGFloat) heightOfString:(NSString *)string
                  withFont:(UIFont*)font {
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    return [[[NSAttributedString alloc] initWithString:string
                                            attributes:attributes] size].height;
}

#pragma mark - public methods
-(void)setInnerMarkingLabels:(NSArray*)labels{
    self.labelsEvenSpacing = labels;
    [self setNeedsDisplay];
}

@end
