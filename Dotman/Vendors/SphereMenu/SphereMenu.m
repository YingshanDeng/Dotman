//
//  SphereMenu.m
//  SphereMenu
//
//  Created by Tu You on 14-8-24.
//  Copyright (c) 2014年 TU YOU. All rights reserved.
//

#import "SphereMenu.h"
#import "UIImage+Additions.h"

static const int kItemInitTag = 1001;
static const CGFloat kAngleOffset = M_PI_2 / 2;
static const CGFloat kSphereLength = 80;
static const float kSphereDamping = 0.3;

// 委托延时调用时间
#define SphereMenu_Delegate_Call_Delay      0.4

// subMenu 显示的延时时间
#define SphereMenu_SubMenu_Label_Show_Delay 0.2



@interface SphereMenu () <UICollisionBehaviorDelegate>

// 主按键
@property (nonatomic, strong) UIButton *startBtn;

// sub Menu Label Text String
@property (nonatomic, strong) NSArray *subMenuLabelTextArray;

// sub Menu Label
@property (nonatomic, strong) NSMutableArray *subMenuLabelArray;



@property (nonatomic, assign) NSUInteger count;

@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) NSMutableArray *positions;


// animator and behaviors
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UICollisionBehavior *collision;
@property (nonatomic, strong) UIDynamicItemBehavior *itemBehavior;
@property (nonatomic, strong) NSMutableArray *snaps;

@property (nonatomic, strong) UITapGestureRecognizer *tapOnStart;

@property (nonatomic, strong) id<UIDynamicItem> bumper;
@property (nonatomic, assign) BOOL expanded;

@end


@implementation SphereMenu


- (id)initWithSize:(CGSize)size
   withCenterPoint:(CGPoint)centerPoint
 withStartBtnColor:(UIColor *)color
 withStartBtnTitle:(NSString *)title
 withSubMenuImages:(NSArray *)images
withSubMenuLabelTexts:(NSArray *)labelTextArray
{
    if (self = [super init])
    {
        self.bounds = CGRectMake(0, 0, size.width, size.height);
        self.center = centerPoint;
        self.subMenuLabelTextArray = labelTextArray;
        
        _angle = kAngleOffset;
        _sphereLength = kSphereLength;
        _sphereDamping = kSphereDamping;
        _images = images;
        _count = self.images.count;
        
        self.startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.startBtn setFrame:self.bounds];
        [self.startBtn.layer setMasksToBounds:YES];
        self.startBtn.layer.cornerRadius = CGRectGetWidth(self.bounds) / 2;
        
        NSMutableAttributedString *mtbAttributedString = [[NSMutableAttributedString alloc] initWithString:title];
        [mtbAttributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:DMFont_Detail_Type size:20.0] range:NSMakeRange(0, title.length)];
        [mtbAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, title.length)];
    
        [self.startBtn setAttributedTitle:mtbAttributedString forState:UIControlStateNormal];
        [self.startBtn setBackgroundImage:[UIImage imageWithColor:color] forState:UIControlStateNormal];
        [self.startBtn addTarget:self action:@selector(startBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.startBtn];
        
    }
    return self;
}

- (void)startBtnPressed:(UIButton *)btn
{
    [self.animator removeBehavior:self.collision];
    [self.animator removeBehavior:self.itemBehavior];
    [self removeSnapBehaviors];
    
    if (self.expanded) {
        [self shrinkSubmenu];
    } else {
        [self expandSubmenu];
    }
}


- (void)expandSphereMenu
{
    if (!self.expanded)
    {
        [self expandSubmenu];
    }
}

- (void)collapseSphereMenu
{
    if (self.expanded)
    {
        [self shrinkSubmenu];
    }
}


- (void)commonSetup
{
    self.items = [NSMutableArray array];
    self.positions = [NSMutableArray array];
    self.snaps = [NSMutableArray array];
    self.subMenuLabelArray = [NSMutableArray array];
    
    // setup the items
    for (int i = 0; i < self.count; i++) {
        UIImageView *item = [[UIImageView alloc] initWithImage:self.images[i]];
        item.tag = kItemInitTag + i;
        item.userInteractionEnabled = YES;
        [self.superview addSubview:item];
        
        
        // sub menu label
        CGRect itemFrame = item.frame;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(itemFrame.origin.x, CGRectGetMaxY(itemFrame) + 5, CGRectGetWidth(itemFrame), 20)];
        label.text = self.subMenuLabelTextArray[i];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont fontWithName:DMFont_Detail_Type size:15.0f];
        label.adjustsFontSizeToFitWidth = YES;
        label.textAlignment = NSTextAlignmentCenter;
        label.alpha = 0.0f;
        [item addSubview:label];
        [self.subMenuLabelArray addObject:label];
        

        CGPoint position = [self centerForSphereAtIndex:i];
        item.center = self.center;
        [self.positions addObject:[NSValue valueWithCGPoint:position]];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        [item addGestureRecognizer:tap];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panned:)];
        [item addGestureRecognizer:pan];
        
        [self.items addObject:item];
    }
    
    [self.superview bringSubviewToFront:self];
    
    // setup animator and behavior
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.superview];
    
    self.collision = [[UICollisionBehavior alloc] initWithItems:self.items];
    self.collision.translatesReferenceBoundsIntoBoundary = YES;
    self.collision.collisionDelegate = self;
    
    for (int i = 0; i < self.count; i++) {
        UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:self.items[i] snapToPoint:self.center];
        snap.damping = self.sphereDamping;
        [self.snaps addObject:snap];
    }
    
    self.itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:self.items];
    self.itemBehavior.allowsRotation = NO;
    self.itemBehavior.elasticity = 1.2;
    self.itemBehavior.density = 0.5;
    self.itemBehavior.angularResistance = 5;
    self.itemBehavior.resistance = 10;
    self.itemBehavior.elasticity = 0.8;
    self.itemBehavior.friction = 0.5;
}

- (void)didMoveToSuperview
{
    [self commonSetup];
}

- (void)removeFromSuperview
{
    for (int i = 0; i < self.count; i++) {
        [self.items[i] removeFromSuperview];
    }
    
    [super removeFromSuperview];
}

- (CGPoint)centerForSphereAtIndex:(int)index
{
    CGFloat firstAngle = M_PI + (M_PI_2 - self.angle) + index * self.angle;
    CGPoint startPoint = self.center;
    CGFloat x = startPoint.x + cos(firstAngle) * self.sphereLength;
    CGFloat y = startPoint.y + sin(firstAngle) * self.sphereLength;
    CGPoint position = CGPointMake(x, y);
    return position;
}

- (void)tapped:(UITapGestureRecognizer *)gesture
{
    int tag = (int)gesture.view.tag;
    tag -= kItemInitTag;
    [self shrinkSubmenu];
    
    // delegate
    if (self.delegate && [self.delegate respondsToSelector:@selector(sphereMenuDidCollapse:withSelected:)])
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(SphereMenu_Delegate_Call_Delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.delegate sphereMenuDidCollapse:self withSelected:tag];
        });
    }
}

- (void)startTapped:(UITapGestureRecognizer *)gesture
{
    [self.animator removeBehavior:self.collision];
    [self.animator removeBehavior:self.itemBehavior];
    [self removeSnapBehaviors];
    
    if (self.expanded) {
        [self shrinkSubmenu];
    } else {
        [self expandSubmenu];
    }
}

// 打开 subMenu
- (void)expandSubmenu
{
    for (int i = 0; i < self.count; i++) {
        [self snapToPostionsWithIndex:i];
    }
    
    self.expanded = YES;
    
    // show sub Mneu Label after 0.2s delay
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(SphereMenu_SubMenu_Label_Show_Delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (UILabel *label in self.subMenuLabelArray)
        {
            NSInteger index = [self.subMenuLabelArray indexOfObject:label];
            [UIView animateWithDuration:0.2 delay:(index * 0.1) options:UIViewAnimationOptionCurveLinear animations:^{
                label.alpha = 1.0f;
            } completion:^(BOOL finished) {
                
            }];
        }
    });
}



// 收缩 subMenu
- (void)shrinkSubmenu
{
    [self.animator removeBehavior:self.collision];
    
    for (int i = 0; i < self.count; i++)
    {
        [self snapToStartWithIndex:i];
    }
    self.expanded = NO;
    
    // hide sub Mneu Label
    for (UILabel *label in self.subMenuLabelArray)
    {
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            label.alpha = 0.0f;
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)panned:(UIPanGestureRecognizer *)gesture
{
    UIView *touchedView = gesture.view;
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [self.animator removeBehavior:self.itemBehavior];
        [self.animator removeBehavior:self.collision];
        [self removeSnapBehaviors];
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        touchedView.center = [gesture locationInView:self.superview];
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        self.bumper = touchedView;
        [self.animator addBehavior:self.collision];
        NSUInteger index = [self.items indexOfObject:touchedView];
        
        if (index != NSNotFound) {
            [self snapToPostionsWithIndex:index];
        }
    }
}

- (void)collisionBehavior:(UICollisionBehavior *)behavior endedContactForItem:(id<UIDynamicItem>)item1 withItem:(id<UIDynamicItem>)item2
{
    [self.animator addBehavior:self.itemBehavior];
    
    if (item1 != self.bumper) {
        NSUInteger index = (int)[self.items indexOfObject:item1];
        if (index != NSNotFound) {
            [self snapToPostionsWithIndex:index];
        }
    }
    
    if (item2 != self.bumper) {
        NSUInteger index = (int)[self.items indexOfObject:item2];
        if (index != NSNotFound) {
            [self snapToPostionsWithIndex:index];
        }
    }
}

- (void)snapToStartWithIndex:(NSUInteger)index
{
    UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:self.items[index] snapToPoint:self.center];
    snap.damping = self.sphereDamping;
    UISnapBehavior *snapToRemove = self.snaps[index];
    self.snaps[index] = snap;
    [self.animator removeBehavior:snapToRemove];
    [self.animator addBehavior:snap];
}

- (void)snapToPostionsWithIndex:(NSUInteger)index
{
    id positionValue = self.positions[index];
    CGPoint position = [positionValue CGPointValue];
    UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:self.items[index] snapToPoint:position];
    snap.damping = self.sphereDamping;
    UISnapBehavior *snapToRemove = self.snaps[index];
    self.snaps[index] = snap;
    [self.animator removeBehavior:snapToRemove];
    [self.animator addBehavior:snap];
}

- (void)removeSnapBehaviors
{
    [self.snaps enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self.animator removeBehavior:obj];
    }];
}

@end
