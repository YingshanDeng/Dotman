// For License please refer to LICENSE file in the root of YALAnimatingTabBarController project

#import "YALFirstTestViewController.h"

#define debug 1

@implementation YALFirstTestViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = DMTabBarViewController_TabBarView_TabBarColor;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 200, 300, 60)];
    
    UIFont *font = [UIFont fontWithName:@"Code Pro LC" size:18.0];
    label.font = font;
    label.textColor = [UIColor colorWithRed:129/255.0 green:216/255.0 blue:246/255.0 alpha:1.0];
    label.text = @"Dotman";
    [self.view addSubview:label];
 
}

#pragma mark - YALTabBarInteracting

- (void)tabBarViewWillCollapse {
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
}

- (void)tabBarViewWillExpand {
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
}

- (void)tabBarViewDidCollapsed {
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
}

- (void)tabBarViewDidExpanded {
    if (debug == 1) {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
    }
}

@end
