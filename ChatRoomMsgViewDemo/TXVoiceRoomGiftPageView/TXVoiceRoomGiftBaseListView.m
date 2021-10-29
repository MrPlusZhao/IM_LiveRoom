//
//  TXVoiceRoomGiftBaseListView.m
//  ChatRoomMsgViewDemo
//
//  Created by ztp on 2021/10/29.
//

#import "TXVoiceRoomGiftBaseListView.h"
#import "TipCollectionItemCell.h"
#import "TXVoiceRoomGiftItemCell.h"

#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width

#define giftListHeight 168

@interface TXVoiceRoomGiftBaseListView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *collectionLayout;
@property (nonatomic, assign) NSInteger selectedItemIndex;

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
        _collectionLayout = [[UICollectionViewFlowLayout alloc] init];
        _collectionLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionLayout.minimumLineSpacing = 20;
        _collectionLayout.minimumInteritemSpacing = 0;
    }
    return _collectionLayout;
}
#pragma mark -- UICollectionViewDelegateFlowLayout
/** 每个cell的尺寸*/
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat WW = (SCREEN_WIDTH - 21*4 - 11*2)/5;
    CGFloat HH = WW + 30;
    return CGSizeMake(WW, HH);
}
/** section的margin*/
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 10, 0, 10);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击了第几%ld项目",indexPath.item);
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 50;
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger number =(NSInteger)scrollView.contentOffset.x/SCREEN_WIDTH;
    self.selectedItemIndex = number;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TXVoiceRoomGiftItemCell *cellItem = [collectionView dequeueReusableCellWithReuseIdentifier:@"TXVoiceRoomGiftItemCell" forIndexPath:indexPath];
    if (!cellItem) {
        cellItem = [[NSBundle mainBundle] loadNibNamed:@"TXVoiceRoomGiftItemCell" owner:self options:nil].lastObject;
    }
    if (indexPath.row <2) {
        cellItem.lucyTipImageView.hidden = YES;
    }
    cellItem.giftImageView.image = [self randomImg];
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
        CGFloat WW = (SCREEN_WIDTH - 21*4 - 11*2)/5;
        CGFloat HH = WW + 30;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 2*HH) collectionViewLayout:self.collectionLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.bounces = NO;
    }
    return _collectionView;
}
@end
