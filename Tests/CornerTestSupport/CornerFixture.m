#import "LNPopupCornerTestSupport.h"
#import <LNPopupController/LNPopupBar.h>

@interface LNPopupBar (CornerFixture)
@property (nonatomic, readonly) UIView *contentView;
@end

@interface LNCornerFixtureEffectView : UIVisualEffectView
@property (nonatomic) BOOL radiusAvailable;
@property (nonatomic) NSUInteger radiusCalls;
@property (nonatomic) CGFloat fixtureRadius;
@end

@implementation LNCornerFixtureEffectView
- (BOOL)respondsToSelector:(SEL)selector
{
    if (selector == @selector(effectiveRadiusForCorner:)) {
        return self.radiusAvailable;
    }
    return [super respondsToSelector:selector];
}
- (CGFloat)effectiveRadiusForCorner:(UIRectCorner)corner API_AVAILABLE(ios(26.0))
{
    self.radiusCalls += 1;
    return self.fixtureRadius;
}
@end

@interface LNCornerFixtureProgressView : UIProgressView
@property (nonatomic) BOOL configurationAvailable;
@property (nonatomic) NSUInteger configurationCalls;
@end

@implementation LNCornerFixtureProgressView
- (BOOL)respondsToSelector:(SEL)selector
{
    if (selector == @selector(setCornerConfiguration:)) {
        return self.configurationAvailable;
    }
    return [super respondsToSelector:selector];
}
- (void)setCornerConfiguration:(UICornerConfiguration *)configuration API_AVAILABLE(ios(26.0))
{
    self.configurationCalls += 1;
    [super setCornerConfiguration:configuration];
}
@end

NSDictionary<NSString *, NSNumber *> *LNPopupRunCornerFixture(
    BOOL radiusAvailable, BOOL configurationAvailable, double legacyRadius, double effectiveRadius)
{
    NSCAssert(NSThread.isMainThread, @"UIKit fixture must run on the main thread");
    LNPopupBar *bar = [[LNPopupBar alloc] initWithFrame:CGRectMake(0, 0, 390, 40)];
    bar.progressViewStyle = LNPopupBarProgressViewStyleBottom;
    [bar layoutSubviews];
    [bar setValue:@NO forKey:@"_resolvedIsFloating"];
    [bar setValue:@YES forKey:@"_resolvedIsCompact"];
    [bar setValue:@1 forKey:@"_resolvedStyle"];

    id background = [bar valueForKey:@"_contentView"];
    [background setValue:@(legacyRadius) forKey:@"cornerRadius"];
    [background setFrame:bar.bounds];
    bar.contentView.frame = bar.bounds;

    LNCornerFixtureEffectView *effect = [[LNCornerFixtureEffectView alloc] initWithEffect:nil];
    effect.radiusAvailable = radiusAvailable;
    effect.fixtureRadius = effectiveRadius;
    [background setValue:effect forKey:@"effectView"];

    LNCornerFixtureProgressView *progress = [[LNCornerFixtureProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    progress.configurationAvailable = configurationAvailable;
    [bar setValue:progress forKey:@"_progressView"];
    [bar layoutSubviews];

    return @{
        @"radiusCalls": @(effect.radiusCalls),
        @"configurationCalls": @(progress.configurationCalls),
        @"x": @(CGRectGetMinX(progress.frame)),
        @"width": @(CGRectGetWidth(progress.frame)),
        @"bottom": @(CGRectGetMaxY(progress.frame)),
        @"layerRadius": @(progress.layer.cornerRadius)
    };
}
