// For License please refer to LICENSE file in the root of YALAnimatingTabBarController project

#import <UIKit/UIKit.h>

@class YALFoldingTabBar;

@protocol YALTabBarViewDataSource <NSObject>

@required
- (NSArray *)leftTabBarItemsInTabBarView:(YALFoldingTabBar *)tabBarView;
- (NSArray *)rightTabBarItemsInTabBarView:(YALFoldingTabBar *)tabBarView;
- (UIImage *)centerImageInTabBarView:(YALFoldingTabBar *)tabBarView;

@end

@protocol YALTabBarViewDelegate <NSObject>

@optional
/**
 *  对 TabBarController 中的 VC 进行切换
 */
- (void)itemInTabBarViewPressed:(YALFoldingTabBar *)tabBarView atIndex:(NSUInteger)index;

/**
 *  对 TabBar 将要收缩，扩展
 */
- (void)tabBarViewWillCollapse:(YALFoldingTabBar *)tabBarView;
- (void)tabBarViewWillExpand:(YALFoldingTabBar *)tabBarView;

/**
 *  对 TabBar 完成收缩，扩展
 */
- (void)tabBarViewDidCollapsed:(YALFoldingTabBar *)tabBarView;
- (void)tabBarViewDidExpanded:(YALFoldingTabBar *)tabBarView;

/**
 *  对 TabBar 左右两侧附加按键点击事件回调
 */
- (void)extraLeftItemDidPressedInTabBarView:(YALFoldingTabBar *)tabBarView;
- (void)extraRightItemDidPressedInTabBarView:(YALFoldingTabBar *)tabBarView;

@end

typedef NS_ENUM(NSUInteger, YALTabBarState ) {
    YALStateCollapsed,
    YALStateExpanded
};

@interface YALFoldingTabBar : UIView

- (instancetype)initWithFrame:(CGRect)frame state:(YALTabBarState)state;

@property (nonatomic, weak) IBOutlet id<YALTabBarViewDataSource> dataSource;
@property (nonatomic, weak) IBOutlet id<YALTabBarViewDelegate> delegate;

@property (nonatomic, assign, readonly) YALTabBarState state;
@property (nonatomic, assign) NSUInteger selectedTabBarItemIndex;

@property (nonatomic, copy) UIColor *tabBarColor;
@property (nonatomic, assign) UIEdgeInsets tabBarViewEdgeInsets;
@property (nonatomic, assign) UIEdgeInsets tabBarItemsEdgeInsets;
@property (nonatomic, assign) CGFloat extraTabBarItemHeight;
@property (nonatomic, assign) CGFloat offsetForExtraTabBarItems;

//extra buttons 'tabBarItems' for each 'tabBarItem'
@property (nonatomic, strong) UIButton *extraLeftButton;
@property (nonatomic, strong) UIButton *extraRightButton;

@end
