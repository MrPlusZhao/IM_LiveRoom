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

#define MsgTableViewTop       300
#define MsgTableViewWidth     288
#define MsgTableViewHeight    300
#define ToolBarHeight         95

#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width

@interface ViewController ()

@property (nonatomic, strong) TXVoiceRoomChatListView *chatListView;

@end

#define RGBA_OF(rgbValue)   [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBAOF(0x461979, 1.0);
    [self.view addSubview:self.chatListView];
}

- (TXVoiceRoomChatListView *)chatListView{
    if (!_chatListView) {
        _chatListView = [[TXVoiceRoomChatListView alloc] init];
        _chatListView.frame = CGRectMake(0, MsgTableViewTop, MsgTableViewWidth, MsgTableViewHeight);
    }
    return _chatListView;
}

/// 开始输入消息
- (IBAction)inputAction:(id)sender {
    [self.chatListView.toolBar show];
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
