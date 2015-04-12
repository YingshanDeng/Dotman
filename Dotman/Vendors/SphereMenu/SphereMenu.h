//
//  SphereMenu.h
//  SphereMenu
//
//  Created by Tu You on 14-8-24.
//  Copyright (c) 2014年 TU YOU. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SphereMenu;
@protocol SphereMenuDelegate <NSObject>


// menu 打开
- (void)sphereMenuDidExpand:(SphereMenu *)sphereMenu;

/**
 *  选中menu中某一个选项，在menu关闭后回调
 */
- (void)sphereMenuDidCollapse:(SphereMenu *)sphereMenu withSelected:(int)index;

@end

@interface SphereMenu : UIView


- (id)initWithSize:(CGSize)size
   withCenterPoint:(CGPoint)centerPoint
 withStartBtnColor:(UIColor *)color
 withStartBtnTitle:(NSString *)title
 withSubMenuImages:(NSArray *)images
withSubMenuLabelTexts:(NSArray *)labelTextArray;


@property (nonatomic, weak) id<SphereMenuDelegate> delegate;

@property (nonatomic, assign) CGFloat angle;
@property (nonatomic, assign) CGFloat sphereDamping;
@property (nonatomic, assign) CGFloat sphereLength;



// 打开
- (void)expandSphereMenu;
// 关闭
- (void)collapseSphereMenu;

@end
