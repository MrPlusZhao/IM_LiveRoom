//
//  TXVoiceRoomGiftBaseListView.m
//  ChatRoomMsgViewDemo
//
//  Created by ztp on 2021/10/29.
//

#import "TXVoiceRoomGiftBaseListView.h"
#import "TipCollectionItemCell.h"
#import "TXVoiceRoomGiftItemCell.h"
#import "TXVoiceRoomGiftFlowLayout.h"
#import "XHPageControl.h"

#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width

//#define giftListHeight 168
#define giftListHeight ((SCREEN_WIDTH/5)+30)*2
#define pageControHeight 25

@interface TXVoiceRoomGiftBaseListView ()<UICollectionViewDelegate,UICollectionViewDataSource,XHPageControlDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) TXVoiceRoomGiftFlowLayout *collectionLayout;
@property (nonatomic, strong) XHPageControl *pageControl;

@end

@implementation TXVoiceRoomGiftBaseListView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        [self UI];
    }
    return self;
}
- (void)UI{
    [self addSubview:self.collectionView];
    [self addSubview:self.pageControl];
    [self.collectionView registerNib:[UINib nibWithNibName:@"TXVoiceRoomGiftItemCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"TXVoiceRoomGiftItemCell"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.pageControl setNumberOfPages:(NSInteger)(self.collectionView.contentSize.width/SCREEN_WIDTH)];
    });
}
#pragma mark -- UICollectionViewDelegateFlowLayout
/** section的margin*/
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击了第几%ld项目",indexPath.item);
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TXVoiceRoomGiftItemCell *cellItem = [collectionView dequeueReusableCellWithReuseIdentifier:@"TXVoiceRoomGiftItemCell" forIndexPath:indexPath];
    if (!cellItem) {
        cellItem = [[NSBundle mainBundle] loadNibNamed:@"TXVoiceRoomGiftItemCell" owner:self options:nil].lastObject;
    }
    NSString *rr = self.dataArr[indexPath.row];
    cellItem.giftNameLab.text = rr;
    return cellItem;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    NSInteger currentPage = targetContentOffset->x / [UIScreen mainScreen].bounds.size.width;
    if([self.delegate respondsToSelector:@selector(pageControlChangeIndex:)]) {
        [self.delegate pageControlChangeIndex:currentPage];
    }
    self.pageControl.currentPage = currentPage;
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if ([self.delegate respondsToSelector:@selector(fatherViewCanScroll:)]) {
        [self.delegate fatherViewCanScroll:!decelerate];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([self.delegate respondsToSelector:@selector(fatherViewCanScroll:)]) {
        [self.delegate fatherViewCanScroll:YES];
    }
}
- (UIImage*)randomImg{
    NSInteger r = arc4random() % 3;
    NSString *imageName = [NSString stringWithFormat:@"gift_00%ld_icon",r];
    UIImage *img = [UIImage imageNamed:imageName];
    return img;
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, giftListHeight) collectionViewLayout:self.collectionLayout];
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionView.pagingEnabled = YES;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.bounces = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.backgroundColor = [UIColor clearColor];
    }
    return _collectionView;
}
- (UICollectionViewFlowLayout *)collectionLayout{
    if (!_collectionLayout) {
        _collectionLayout =[[TXVoiceRoomGiftFlowLayout alloc]init];
        CGFloat WW = SCREEN_WIDTH/5;
        CGFloat HH = WW + 30;
        _collectionLayout.itemSize = CGSizeMake(WW, HH);
        _collectionLayout.minimumInteritemSpacing = 0;
        _collectionLayout.minimumLineSpacing = 0;
        _collectionLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _collectionLayout;
}
- (XHPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[XHPageControl alloc] init];
        _pageControl.frame = CGRectMake(0, giftListHeight, SCREEN_WIDTH, pageControHeight);
        _pageControl.numberOfPages = 1;
        _pageControl.delegate = self;
        _pageControl.currentColor = UIColor.whiteColor;
    }
    return _pageControl;
}
- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
@end
