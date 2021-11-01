//
//  ViewController.m
//  ChatRoomMsgViewDemo
//
//  Created by ztp on 2021/10/14.
//

#import "ViewController.h"
#import "TXVoiceRoomChatListView.h"
#import "UIView+Frame.h"
#import "TPImageManager.h"
#import "TXVoiceRoomGiftPageView.h"

#define MsgTableViewTop       300
#define MsgTableViewWidth     288
#define MsgTableViewHeight    300
#define ToolBarHeight         95
//#define BOM_HEIGHT 340 ((SCREEN_WIDTH/5)+30)*2

#define UserListViewHeight 50
#define PageMenu_Height 40
#define giftListHeight (((SCREEN_WIDTH/5)+30)*2)
#define ProgressHeight 25
//#define BOM_HEIGHT 340
#define BOM_HEIGHT ((UserListViewHeight+PageMenu_Height+giftListHeight+ProgressHeight)+100)

//#define BOM_HEIGHT 340 ((SCREEN_WIDTH/5)+30)*2

#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width

@interface ViewController ()

@property (nonatomic, strong) TXVoiceRoomChatListView *chatListView;
@property (nonatomic, strong) TXVoiceRoomGiftPageView *giftPageView;

@end

#define RGBA_OF(rgbValue)   [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBAOF(0x461979, 1.0);
    [self.view addSubview:self.chatListView];
    [self.view addSubview:self.giftPageView];
    [self.giftPageView show];
}

- (TXVoiceRoomChatListView *)chatListView{
    if (!_chatListView) {
        _chatListView = [[TXVoiceRoomChatListView alloc] init];
        _chatListView.frame = CGRectMake(0, MsgTableViewTop, MsgTableViewWidth, MsgTableViewHeight);
    }
    return _chatListView;
}
- (TXVoiceRoomGiftPageView *)giftPageView{
    if (!_giftPageView) {
        _giftPageView = [[TXVoiceRoomGiftPageView alloc] init];
        _giftPageView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, BOM_HEIGHT);
    }
    return _giftPageView;
}
/// 开始输入消息
- (IBAction)inputAction:(id)sender {
    [self.chatListView.toolBar show];
}
- (IBAction)giftAction:(id)sender {
    [self.giftPageView show];
}

/// 清除消息
- (IBAction)clear:(id)sender {
    [[TPImageManager sharedInstance] clearData];
}

/// 开始模拟发送消息
- (IBAction)start:(id)sender {
    [[TPImageManager sharedInstance] startCreateData];
}

/// 停止发送消息
- (IBAction)stop:(id)sender {
    [[TPImageManager sharedInstance] stopCreate];
}

@end
