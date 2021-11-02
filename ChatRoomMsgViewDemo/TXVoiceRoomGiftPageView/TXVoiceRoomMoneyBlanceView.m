//
//  TXVoiceRoomMoneyBlanceView.m
//  ChatRoomMsgViewDemo
//
//  Created by ztp on 2021/11/1.
//

#import "TXVoiceRoomMoneyBlanceView.h"
#import <Masonry/Masonry.h>


#define RGBAOF(rgbValue, alphas)   [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphas]

#define IPHONE_X \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})

#define Height_TabBar ((IPHONE_X == YES) ? 83.0 : 49.0)

#define Height_bottomSafeArea (IPHONE_X == YES ? 34.0 : 0.0)

#define bottomHeight (IPHONE_X == YES ? 34.0 : 0.0)


@interface TXVoiceRoomMoneyBlanceView ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *bgView;
@end

@implementation TXVoiceRoomMoneyBlanceView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.moneyBgView.layer.borderColor = RGBAOF(0xffffff, 0.3).CGColor;
    self.moneyBgView.layer.borderWidth = 0.5;
    
    self.numberBgView.layer.borderColor = RGBAOF(0xffffff, 0.3).CGColor;
    self.numberBgView.layer.borderWidth = 0.5;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction)];
    [self.numberBgView addGestureRecognizer:singleTap];
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.scrollEnabled = NO;
        _tableView.backgroundColor = RGBAOF(0x01041C, 0.9);
        _tableView.layer.cornerRadius = 10;
    }
    return _tableView;
}
- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = UIColor.clearColor;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissView)];
        singleTap.delegate = self;
        [_bgView addGestureRecognizer:singleTap];
    }
    return _bgView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *Cell = [[UITableViewCell alloc] init];
    Cell.selectionStyle = UITableViewCellSelectionStyleNone;
    Cell.backgroundColor = UIColor.clearColor;
    Cell.textLabel.textColor = UIColor.whiteColor;
    Cell.textLabel.font = [UIFont systemFontOfSize:10];
    Cell.textLabel.text = @"x888";
    return Cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"选择了数量");
    [self dismissView];
}
- (void)singleTapAction{
    [self selectNumberAction];
}
- (void)selectNumberAction{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self.bgView];
    [self.bgView addSubview:self.tableView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(keyWindow);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(keyWindow.mas_right).offset(-10);
        make.width.equalTo(@80);
        make.height.equalTo(@400);
        make.bottom.equalTo(self.mas_bottom).offset(-25-20);
    }];
    
}
- (void)dismissView{
    [self.tableView removeFromSuperview];
    [self.bgView removeFromSuperview];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
     // 若为UITableViewCellContentView（即点击了tableViewCell），
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
    // cell 不需要响应 父视图的手势，保证didselect 可以正常
        return NO;
    }
    //默认都需要响应
    return  YES;
}
@end
