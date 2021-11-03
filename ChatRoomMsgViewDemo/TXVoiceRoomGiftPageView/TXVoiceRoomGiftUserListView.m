//
//  TXVoiceRoomGiftUserListView.m
//  ChatRoomMsgViewDemo
//
//  Created by ztp on 2021/10/29.
//

#import "TXVoiceRoomGiftUserListView.h"
#import "TXVoiceRoomGiftUserHeadCell.h"
#import <Masonry/Masonry.h>

#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define RGBAOF(rgbValue, alphas)   [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphas]


@interface UserModel : NSObject

@property (nonatomic, assign) BOOL isSelect;

@end

@implementation UserModel


@end

@interface TXVoiceRoomGiftUserListView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *collectionLayout;
@property (nonatomic, assign) NSInteger lineNum;
@property (nonatomic, strong) UIButton *allBtn;
@property (nonatomic, strong) NSMutableArray *userModelArr;
@property (nonatomic, strong) NSMutableArray *selectedDataArr;

@end

@implementation TXVoiceRoomGiftUserListView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:1/255.0 green:4/255.0 blue:28/255.0 alpha:0.2];
        [self configData];
        [self createUI];
    }
    return self;
}
- (NSMutableArray *)selectedDataArr{
    if (!_selectedDataArr) {
        _selectedDataArr = [NSMutableArray array];
    }
    return _selectedDataArr;
}
- (NSMutableArray *)userModelArr{
    if (!_userModelArr) {
        _userModelArr = [NSMutableArray array];
    }
    return _userModelArr;
}
- (void)configData{
    for (NSInteger i=0; i<10; i++) {
        UserModel *model = [UserModel new];
        [self.userModelArr addObject:model];
    }
}
- (void)createUI{
    
    self.collectionLayout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionLayout.minimumLineSpacing = 10;
    self.collectionLayout.itemSize = CGSizeMake(30, 30);
    self.collectionLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH-75, 32) collectionViewLayout:self.collectionLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsHorizontalScrollIndicator = YES;
    [self.collectionView registerNib:[UINib nibWithNibName:@"TXVoiceRoomGiftUserHeadCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"TXVoiceRoomGiftUserHeadCell"];
    self.collectionView.backgroundColor = UIColor.clearColor;
    [self addSubview:self.collectionView];
    [self.collectionView setCollectionViewLayout:self.collectionLayout];
    
    [self addSubview:self.allBtn];
    
    [self.allBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-10);
        make.height.equalTo(@22);
        make.width.equalTo(@40);
        make.centerY.equalTo(self.mas_centerY);
    }];
}
- (UIColor*)RandomColor{
    NSInteger r = arc4random() %255;
    NSInteger g = arc4random() %255;
    NSInteger b = arc4random() %255;
    UIColor *color = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
    return color;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UserModel *model = self.userModelArr[indexPath.row];
    if (model.isSelect) {//选中的 若存在, 则移出
        if ([self.selectedDataArr containsObject:model]) {
            [self.selectedDataArr removeObject:model];
        }
    }
    model.isSelect = !model.isSelect;
    if (model.isSelect) {
        [self.selectedDataArr addObject:model];
    }
    if (self.selectedDataArr.count == self.userModelArr.count) {
        // 全麦
        [self selectAllUser];
    }
    else{
        if (self.allBtn.selected) {
            self.allBtn.selected = NO;
            [self changeLineSpace:10];
        }
        else{
            [self.collectionView reloadData];
        }
    }
    
    NSLog(@"点击了第几%ld项目",indexPath.item);
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.userModelArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TXVoiceRoomGiftUserHeadCell *cellItem = [collectionView dequeueReusableCellWithReuseIdentifier:@"TXVoiceRoomGiftUserHeadCell" forIndexPath:indexPath];
    if (!cellItem) {
        cellItem = [[NSBundle mainBundle] loadNibNamed:@"TXVoiceRoomGiftUserHeadCell" owner:self options:nil].lastObject;
    }
//    cellItem.headImgView.backgroundColor = [self RandomColor];
    
    UserModel *model = self.userModelArr[indexPath.row];
    cellItem.numberlab.text =[NSString stringWithFormat:@"%ld",indexPath.row];
    if (model.isSelect) {
        
        cellItem.headImgView.backgroundColor = UIColor.cyanColor;
    }
    else{
        cellItem.headImgView.backgroundColor = UIColor.whiteColor;
    }
    return cellItem;
}

- (UIButton *)allBtn{
    if (!_allBtn) {
        _allBtn = [[UIButton alloc] init];
        _allBtn.layer.cornerRadius = 11;
        _allBtn.titleLabel.font = [UIFont boldSystemFontOfSize:10];
        _allBtn.layer.borderColor = RGBAOF(0xFFE403, 1.0).CGColor;
        _allBtn.layer.borderWidth = 0.5;
        [_allBtn addTarget:self action:@selector(selectAllUser) forControlEvents:UIControlEventTouchUpInside];
        [_allBtn setTitle:@"全麦" forState:UIControlStateNormal];
        [_allBtn setTitleColor:RGBAOF(0xFFE403, 1.0) forState:UIControlStateNormal];
    }
    return _allBtn;
}
- (void)selectAllUser{
    _allBtn.selected = !_allBtn.selected;
    if (_allBtn.selected) { //全麦
        [self selectAllData:YES];
        [self changeLineSpace:-10];
    }
    else{ // 取消全麦
        [self selectAllData:NO];
        [self changeLineSpace:10];
    }
}
- (void)selectAllData:(BOOL)select{
    for (UserModel *model in self.userModelArr) {
        model.isSelect = select;
    }
}
- (void)changeLineSpace:(NSInteger)space{
    if (space > 0) {
        [_allBtn setTitleColor:RGBAOF(0xFFE403, 1.0) forState:UIControlStateNormal];
        _allBtn.backgroundColor = [UIColor colorWithRed:1/255.0 green:4/255.0 blue:28/255.0 alpha:0.2];
    }
    else{
        _allBtn.backgroundColor = RGBAOF(0xFFE403, 1.0);
        [_allBtn setTitleColor:RGBAOF(0x6A451A, 1.0) forState:UIControlStateNormal];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView scrollRectToVisible:CGRectMake(15, 10, SCREEN_WIDTH-75, 32) animated:NO];
        self.collectionView.scrollEnabled = space < 0 ? NO : YES;
        self.collectionLayout.minimumLineSpacing = space;
        [self.collectionView reloadData];
        [self.collectionView setCollectionViewLayout:self.collectionLayout];
    });
    
}
@end
