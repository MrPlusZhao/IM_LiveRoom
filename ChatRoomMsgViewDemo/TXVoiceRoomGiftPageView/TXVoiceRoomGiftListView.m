//
//  TXVoiceRoomGiftListView.m
//  ChatRoomMsgViewDemo
//
//  Created by ztp on 2021/10/29.
//

#import "TXVoiceRoomGiftListView.h"
#import <SPPageMenu/SPPageMenu.h>
#import "TXVoiceRoomGiftBaseListView.h"
#import "TXVoiceRoomGiftPowerView.h"

#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width

#define PageMenu_Height 40
//#define giftListHeight 168
#define functionButtonWidth 54
#define powerProgressHeight 25
#define pageControHeight 25

#define giftListHeight (((SCREEN_WIDTH/5)+30)*2)

@interface TXVoiceRoomGiftListView ()<SPPageMenuDelegate,UIScrollViewDelegate,TXVoiceRoomGiftBaseListViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *childViewsArr;
@property (nonatomic, strong) SPPageMenu *pageMenu;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *functionBtn;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) TXVoiceRoomGiftPowerView *powerProgressView;

@end

@implementation TXVoiceRoomGiftListView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configData];
        [self addSubview:self.scrollView];
        [self addSubview:self.pageMenu];
        [self addOtherButton];
        [self addSubview:self.powerProgressView];
    }
    return self;
}
- (void)addOtherButton{
    [self addSubview:self.functionBtn];
    [self addSubview:self.lineView];
    SPPageMenuButtonItem *item1 = [SPPageMenuButtonItem itemWithTitle:@" 热门" image:[UIImage imageNamed:@"gift_tab_hot_icon"]];
    item1.imagePosition = SPItemImagePositionDefault;
    [self.pageMenu setItem:item1 forItemIndex:0];
    
}
- (UIButton *)functionBtn{
    if (!_functionBtn) {
        _functionBtn = [[UIButton alloc] init];
        _functionBtn.frame = CGRectMake(SCREEN_WIDTH-functionButtonWidth, 0, functionButtonWidth, PageMenu_Height);
        _functionBtn.backgroundColor = UIColor.clearColor;
        [_functionBtn setTitle:@"背包" forState:UIControlStateNormal];
        _functionBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _functionBtn;
}
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = UIColor.redColor;
        _lineView.frame = CGRectMake(SCREEN_WIDTH-functionButtonWidth, (PageMenu_Height-(PageMenu_Height/2))/2, 0.5, PageMenu_Height/2);
    }
    return _lineView;
}
- (TXVoiceRoomGiftPowerView *)powerProgressView{
    if (!_powerProgressView) {
        _powerProgressView = [[TXVoiceRoomGiftPowerView alloc] init];
        _powerProgressView.frame = CGRectMake(0, PageMenu_Height, SCREEN_WIDTH, powerProgressHeight);
    }
    return _powerProgressView;
}
- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
- (NSMutableArray *)childViewsArr{
    if (!_childViewsArr) {
        _childViewsArr = [NSMutableArray array];
    }
    return _childViewsArr;
}
- (void)configData{
    self.dataArr = [NSMutableArray arrayWithArray:@[@"热门",@"活动",@"特权",@"趣味",@"限定",@"玩法",@"其他"]];
    for (NSInteger i=0; i<self.dataArr.count; i++) {
        TXVoiceRoomGiftBaseListView *baseView = [[TXVoiceRoomGiftBaseListView alloc] init];
        NSMutableArray *arr = [NSMutableArray array];
        for (NSInteger i=0; i<[self randomData]; i++) {
            [arr addObject:[NSString stringWithFormat:@"哈哈%ld",i]];
        }
        baseView.delegate = self;
        baseView.dataArr = arr;
        [self.scrollView addSubview:baseView];
        baseView.frame = CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, giftListHeight+pageControHeight);
    }
    self.scrollView.contentSize = CGSizeMake(self.dataArr.count*SCREEN_WIDTH, 0);
}
- (NSInteger)randomData{
    NSInteger randomNumber = arc4random()%50+7;
    return randomNumber;
}
- (SPPageMenu *)pageMenu{
    if (!_pageMenu) {
        _pageMenu = [SPPageMenu pageMenuWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-functionButtonWidth, PageMenu_Height) trackerStyle:SPPageMenuTrackerStyleNothing];
        [_pageMenu setItems:self.dataArr selectedItemIndex:0];
        _pageMenu.delegate = self;
        _pageMenu.bridgeScrollView = self.scrollView;
        _pageMenu.dividingLine.hidden = YES;
        _pageMenu.itemTitleFont = [UIFont systemFontOfSize:12];
        _pageMenu.selectedItemTitleFont = [UIFont boldSystemFontOfSize:14];
        _pageMenu.unSelectedItemTitleColor = [UIColor whiteColor];
        _pageMenu.selectedItemTitleColor = [UIColor yellowColor];
        _pageMenu.backgroundColor = UIColor.clearColor;
    }
    return _pageMenu;
}
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,PageMenu_Height+25, SCREEN_WIDTH, giftListHeight+pageControHeight)];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
//        _scrollView.bounces = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return  _scrollView;
}
#pragma mark - SPPageMenu的代理方法

- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedAtIndex:(NSInteger)index {
    NSLog(@"%zd",index);
}

- (void)pageMenu:(SPPageMenu *)pageMenu itemSelectedFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    NSLog(@"%zd------->%zd",fromIndex,toIndex);
    if (!self.scrollView.isDragging) { // 判断用户是否在拖拽scrollView
        // 如果fromIndex与toIndex之差大于等于2,说明跨界面移动了,此时不动画.
        if (labs(toIndex - fromIndex) >= 2) {
            [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * toIndex, 0) animated:NO];
        } else {
            [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * toIndex, 0) animated:YES];
        }
    }
}

- (void)pageMenu:(SPPageMenu *)pageMenu functionButtonClicked:(UIButton *)functionButton {
    NSLog(@"functionButtonClicked");
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.scrollView.scrollEnabled = YES;
}
#pragma mark - scrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    self.scrollView.scrollEnabled = !decelerate;
}
- (void)fatherViewCanScroll:(BOOL)canScroll{
    self.scrollView.scrollEnabled = canScroll;
}
- (void)dealloc {
    NSLog(@"被销毁了");
}

@end
