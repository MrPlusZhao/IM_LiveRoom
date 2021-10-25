//
//  TXVoiceRoomChatListView.m
//  ChatRoomMsgViewDemo
//
//  Created by ztp on 2021/10/14.
//

#import "TXVoiceRoomChatListView.h"
#import "TXVoiceRoomMsgBaseCell.h"

#import <Masonry/Masonry.h>
#import <pthread/pthread.h>
#import "UIView+Frame.h"
#import "TPImageManager.h"

#define MsgTableViewTop       300
#define MsgTableViewWidth     288
#define MsgTableViewHeight    300
#define ToolBarHeight         95
#define smallSpace            10

#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define RoomMsgScroViewTag      1009

/// 最小刷新时间间隔
#define reloadTimeSpan 1.0
@interface TXVoiceRoomChatListView ()<UITableViewDelegate,UITableViewDataSource,VoiceRoomMsgBaseCellGesDelegate,TIMKeyboardToolBarViewDelegate>
{
    CGFloat _AllHeight;
    pthread_mutex_t _mutex; // 互斥锁
}
/// 消息数组(数据源)
@property (nonatomic, strong) NSMutableArray<VoiceRoomChatMsgModel *> *msgArray;
/// 用于存储消息还未刷新到tableView的时候接收到的消息
@property (nonatomic, strong) NSMutableArray<VoiceRoomChatMsgModel *> *tempMsgArray;
/// 底部更多未读按钮
@property (nonatomic, strong) UIButton *moreButton;
/// 刷新定时器
@property (nonatomic, strong) NSTimer *refreshTimer;
/// 是否处于爬楼状态
@property (nonatomic, assign) BOOL inPending;
@end

@implementation TXVoiceRoomChatListView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self registerNotifications];//注册通知
        [self UI];
        [self config];// 起始配置
    }
    return self;
}
- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newMessage:) name:@"TIM_NEW_MESSAGE" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearMessage) name:@"TIM_CLEAR_MESSAGE" object:nil];
}
/// 起始配置
- (void)config{
    [[TPImageManager sharedInstance] setup];  // 初始化等级
    pthread_mutex_init(&_mutex, NULL);
    _AllHeight = 15;
    [self startTimer];
}
- (void)UI{
    self.backgroundColor = UIColor.clearColor;
    [self addSubview:self.tableView];
    [self addSubview:self.moreButton];
    [self.tableView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(25);
    }];
    NDViewRadius(self.moreButton, 25/2);
}

- (void)clearMessage{
    [self reset];
}
#pragma mark 消息来源主要入口
- (void)newMessage:(NSNotification*)noti{
    [self addNewMsg:noti.object];
}
#pragma mark - 消息追加
/// 这个数数据来源的主要方法, 由外部触发,触发的次数可能无限多, 所以做定时器定时刷新
- (void)addNewMsg:(VoiceRoomChatMsgModel *)msgModel {
    if (!msgModel) return;
    pthread_mutex_lock(&_mutex);
    // 消息不直接加入到数据源,临时存储
    [self.tempMsgArray addObject:msgModel];
    pthread_mutex_unlock(&_mutex);
    // [self tryToappendAndScrollToBottom:YES]; // 直接刷新打开这个(性能可能不是最好, 看产品需要是否要及时刷新吧)
}
/// 添加数据并滚动到底部
- (void)tryToappendAndScrollToBottom:(BOOL)animated{
    [self updateMoreBtnHidden];// 处于爬楼状态更新更多按钮
    if (!self.inPending) {
        // 如果不处在爬楼状态，追加数据源并滚动到底部
        [self appendAndScrollToBottom:animated];
    }
}
/// 追加数据源
- (void)appendAndScrollToBottom:(BOOL)animated{
    if (self.tempMsgArray.count < 1) return;
    pthread_mutex_lock(&_mutex);
    // 执行插入
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (VoiceRoomChatMsgModel *item in self.tempMsgArray) {
        _AllHeight += item.attributeModel.msgHeight;
        [self.msgArray addObject:item];
        [indexPaths addObject:[NSIndexPath indexPathForRow:self.msgArray.count - 1 inSection:0]];
    }
    [UIView setAnimationsEnabled:NO]; //防止抖动, 这里暂时关掉动画
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    [UIView setAnimationsEnabled:YES];//恢复动画
    [self.tempMsgArray removeAllObjects];
    pthread_mutex_unlock(&_mutex);
    //滚动到最底部 可选动画
    [self scrollToBottom:animated];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.msgArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VoiceRoomChatMsgModel *msgModel = self.msgArray[indexPath.row];
    TXVoiceRoomMsgBaseCell *cell = [TXVoiceRoomMsgBaseCell tableView:tableView cellForMsg:msgModel indexPath:indexPath delegate:self];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    VoiceRoomChatMsgModel *msgModel = self.msgArray[indexPath.row];
    return msgModel.attributeModel.msgHeight + cellLineSpeing;
}
/// 执行插入动画并滚动
- (void)scrollToBottom:(BOOL)animated {
    NSInteger s = [self.tableView numberOfSections];  //有多少组
    if (s<1) return;
    NSInteger r = [self.tableView numberOfRowsInSection:s-1]; //最后一组行
    if (r<1) return;
    NSIndexPath *ip = [NSIndexPath indexPathForRow:r-1 inSection:s-1];  //取最后一行数据
    [self.tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:animated]; //滚动到最后一行
}
///开启键盘之前, 数据推到最低端
- (void)beforeShowKeyboard{
    NSInteger s = [self.tableView numberOfSections];  //有多少组
    if (s<1) return;
    NSInteger r = [self.tableView numberOfRowsInSection:s-1]; //最后一组行
    if (r<1) return;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:([self.tableView numberOfRowsInSection:0]-1) inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        self.inPending = NO;
        [self tryToappendAndScrollToBottom:NO];
    });
}
- (void)setInPending:(BOOL)inPending {
    _inPending = inPending;
    [self updateMoreBtnHidden];// 新消息按钮可见状态
}
/// 新消息按钮可见状态
- (void)updateMoreBtnHidden {
    if (self.inPending && self.tempMsgArray.count > 0) {
        self.moreButton.hidden = NO;
    } else {
        self.moreButton.hidden = YES;
    }
}
#pragma mark - Timer
- (void)startTimer {
    [self stopTimer];
    self.refreshTimer = [NSTimer scheduledTimerWithTimeInterval:reloadTimeSpan target:self selector:@selector(timerEvent) userInfo:nil repeats:YES];
}
- (void)timerEvent {
    [self tryToappendAndScrollToBottom:YES];
}
- (void)stopTimer {
    [self.refreshTimer invalidate];
    [self setRefreshTimer:nil];
}

#pragma mark - Functions
// 新消息按钮
- (void)moreClick:(UIButton *)button {
    [self appendAndScrollToBottom:NO];
    self.inPending = NO;
}

//清空消息重置
- (void)reset {
    pthread_mutex_lock(&_mutex);
    
    _AllHeight = 15;
    [self stopTimer];
    [self.msgArray removeAllObjects];
    [self.tempMsgArray removeAllObjects];
    [self.tableView reloadData];
    self.moreButton.hidden = YES;
    pthread_mutex_unlock(&_mutex);
    [self startTimer];
}

#pragma mark - =================== 手动干预tableview滚动时候处理的对应逻辑========================

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    // 手动拖拽开始
    self.inPending = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(startScroll)]) {
        [self.delegate startScroll];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    // 手动拖拽结束（decelerate：0松手时静止；1松手时还在运动,会触发DidEndDecelerating方法）
    if (!decelerate) {
        [self finishDraggingWith:scrollView];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 静止后触发（手动）
    [self finishDraggingWith:scrollView];
}

/** 手动拖拽动作彻底完成(减速到零) */
- (void)finishDraggingWith:(UIScrollView *)scrollView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(endScroll)]) {
        [self.delegate endScroll];
    }
    CGFloat contentSizeH = scrollView.contentSize.height;
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    CGFloat sizeH = scrollView.frame.size.height;
    
    self.inPending = contentSizeH - contentOffsetY - sizeH > 20.0;
    // 如果不处在爬楼状态，追加数据源并滚动到底部
    [self tryToappendAndScrollToBottom:NO];
}

#pragma mark - VoiceRoomMsgBaseCellGesDelegate
- (void)longPressGes:(VoiceRoomChatMsgModel *)msgModel {
    NSLog(@"长按手势触发");
}

- (void)userClick:(VoiceRoomChatUserModel *)user {
    if (user) {
//        if (self.delegate && [self.delegate respondsToSelector:@selector(didUser:)]) {
//            [self.delegate didUser:user];
//        }
    }
}

- (void)touchMsgCellView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(touchSelfView)]) {
        [self.delegate touchSelfView];
    }
}
// 提示关注 分享 送礼物点击
- (void)remindCellFollow:(VoiceRoomChatMsgModel *)msgModel {

}
- (void)remindCellShare {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didRemindShare)]) {
        [self.delegate didRemindShare];
    }
}
- (void)remindCellGifts {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didRemindGifts)]) {
        [self.delegate didRemindGifts];
    }
}

/** 消息属性文字发生变化（更新对应cell） */
- (void)msgAttrbuiteUpdated:(VoiceRoomChatMsgModel *)msgModel {
    NSInteger row = [self.msgArray indexOfObject:msgModel];
    if (row >= 0) {
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        if (row == self.msgArray.count - 1) {
            [self scrollToBottom:YES];
        }
    }
}
#pragma mark - GETTER - SETTER
- (UITableView *)tableView {
    if (!_tableView ) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.sectionFooterHeight = 0;
        _tableView.sectionHeaderHeight = 0;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tag = RoomMsgScroViewTag;
        _tableView.backgroundColor = UIColor.clearColor;
    }
    return _tableView;
}
- (UIButton *)moreButton{
    if (!_moreButton) {
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreButton setTitle:@"新消息" forState:UIControlStateNormal];
        _moreButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_moreButton setTitleColor:RGBA_OF(0xfee324) forState:normal];
        _moreButton.backgroundColor = [UIColor purpleColor];
        _moreButton.contentEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 15);
        _moreButton.hidden = YES;
        [_moreButton addTarget:self action:@selector(moreClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreButton;
}
- (NSMutableArray<VoiceRoomChatMsgModel *> *)msgArray {
    if(!_msgArray){
        _msgArray = [NSMutableArray array];
    }
    return _msgArray;
}
- (NSMutableArray<VoiceRoomChatMsgModel *> *)tempMsgArray {
    if(!_tempMsgArray){
        _tempMsgArray = [NSMutableArray array];
    }
    return _tempMsgArray;
}

#pragma mark ================== 键盘事件相关
- (TIMKeyboardToolBarView *)toolBar{
    if (!_toolBar) {
        _toolBar = [[NSBundle mainBundle] loadNibNamed:@"TIMKeyboardToolBarView" owner:self options:nil].lastObject;
        _toolBar.delegate = self;
    }
    return _toolBar;
}
- (void)keyboardShow:(CGFloat)yOffset{
    [self beforeShowKeyboard];
    [UIView animateWithDuration:0.25 animations:^{
        self.bottom = [UIScreen mainScreen].bounds.size.height + yOffset -ToolBarHeight - smallSpace;
    }];
}
- (void)keyboardHidden{
    self.frame = CGRectMake(0, MsgTableViewTop, MsgTableViewWidth, MsgTableViewHeight);
}

- (void)dealloc {
    [self stopTimer];
    [[TPImageManager sharedInstance] destrory];
    NSLog(@"dealloc-----%@", NSStringFromClass([self class]));
}

@end
