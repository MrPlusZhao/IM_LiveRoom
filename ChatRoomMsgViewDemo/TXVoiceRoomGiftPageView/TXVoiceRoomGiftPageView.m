//
//  TXVoiceRoomGiftPageView.m
//  ChatRoomMsgViewDemo
//
//  Created by ztp on 2021/10/29.
//

#import "TXVoiceRoomGiftPageView.h"
#import "TXVoiceRoomGiftListView.h"
#import "UIView+Frame.h"
#import "TXVoiceRoomGiftUserListView.h"
#import "TXVoiceRoomMoneyBlanceView.h"
#import <Masonry/Masonry.h>

#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width

#define UserListViewHeight 50
#define PageMenu_Height 40
#define giftListHeight ((SCREEN_WIDTH/5)+30)*2
#define ProgressHeight 25
//#define BOM_HEIGHT 340
#define BOM_HEIGHT ((UserListViewHeight+PageMenu_Height+giftListHeight+ProgressHeight)+100)
#define pageControHeight 25

@interface TXVoiceRoomGiftPageView ()

/// 键盘上层遮罩
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) TXVoiceRoomGiftListView *giftListView;
@property (nonatomic, strong) TXVoiceRoomGiftUserListView *userListView;
@property (nonatomic, strong) TXVoiceRoomMoneyBlanceView *blanceView;
@end

@implementation TXVoiceRoomGiftPageView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:1/255.0 green:4/255.0 blue:28/255.0 alpha:0.7];
        [self addSubview:self.giftListView];
        [self addSubview:self.userListView];
        [self addSubview:self.blanceView];
        [self configFrame];
    }
    return self;
}
- (void)configFrame{
    [self.blanceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.equalTo(@28);
        make.top.equalTo(self.giftListView.mas_bottom).offset(pageControHeight);
    }];
}
- (TXVoiceRoomGiftListView *)giftListView{
    if (!_giftListView) {
        _giftListView = [[TXVoiceRoomGiftListView alloc] init];
        _giftListView.frame = CGRectMake(0, 50, SCREEN_WIDTH, PageMenu_Height+ProgressHeight+giftListHeight);
    }
    return _giftListView;
}
- (TXVoiceRoomGiftUserListView *)userListView{
    if (!_userListView) {
        _userListView = [[TXVoiceRoomGiftUserListView alloc] init];
        _userListView.frame = CGRectMake(0, 0, SCREEN_WIDTH, UserListViewHeight);
    }
    return _userListView;
}
- (TXVoiceRoomMoneyBlanceView *)blanceView{
    if (!_blanceView) {
        _blanceView = [[NSBundle mainBundle] loadNibNamed:@"TXVoiceRoomMoneyBlanceView" owner:self options:nil].lastObject;
    }
    return _blanceView;
}
- (void)show
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
        for (UIWindow *window in frontToBackWindows)
        {
            BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
            BOOL windowIsVisible = !window.hidden && window.alpha > 0;
            BOOL windowLevelNormal = window.windowLevel == UIWindowLevelNormal;
            if(windowOnMainScreen && windowIsVisible && windowLevelNormal)
            {
                if (![window.subviews containsObject:self]) {
                    [window addSubview:self];
                }
                if (![window.subviews containsObject:self.coverView]) {
                    [window addSubview:self.coverView];
                }
                self.coverView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-BOM_HEIGHT);
                [UIView animateWithDuration:0.25 animations:^{
                    self.frame = CGRectMake(0, SCREEN_HEIGHT-BOM_HEIGHT, SCREEN_WIDTH, BOM_HEIGHT);
                }];
                break;
            }
        }
    }];
}
- (UIView *)coverView{
    if (!_coverView) {
        _coverView = [[UIView alloc] init];
        _coverView.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction)];
        [_coverView addGestureRecognizer:singleTap];
    }
    return _coverView;
}
- (void)singleTapAction{
    [self hide];
}
- (void)hide{
    [UIView animateWithDuration:0.25 animations:^{
        self.top = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, BOM_HEIGHT);
        [self.coverView removeFromSuperview];
        [self removeFromSuperview];
    }];
    
}
@end
