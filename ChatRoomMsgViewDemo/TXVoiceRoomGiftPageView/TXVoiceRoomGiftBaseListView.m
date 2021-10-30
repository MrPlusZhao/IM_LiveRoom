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

#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width

//#define giftListHeight 168
#define giftListHeight ((SCREEN_WIDTH/5)+30)*2

@interface TXVoiceRoomGiftBaseListView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) TXVoiceRoomGiftFlowLayout *collectionLayout;
@property (nonatomic, assign) int selectedItemIndex;
@property (nonatomic, assign) CGFloat oldY;

@end

@implementation TXVoiceRoomGiftBaseListView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = UIColor.redColor;
        [self UI];
    }
    return self;
}
- (void)UI{
    self.selectedItemIndex = 0;
    [self addSubview:self.collectionView];
    [self.collectionView registerNib:[UINib nibWithNibName:@"TXVoiceRoomGiftItemCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"TXVoiceRoomGiftItemCell"];

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
#pragma mark -- UICollectionViewDelegateFlowLayout
/** section的margin*/
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击了第几%ld项目",indexPath.item);
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger count = self.dataArr.count;
//    NSInteger addCount = self.dataArr.count%10;
//    if (addCount < 10) {
//        return addCount + count;
//    }
    return count;
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
        _collectionView.backgroundColor = [UIColor blackColor];
    }
    return _collectionView;
}
- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
@end
