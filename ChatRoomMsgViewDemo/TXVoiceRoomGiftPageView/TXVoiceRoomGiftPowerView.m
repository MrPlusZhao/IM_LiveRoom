//
//  TXVoiceRoomGiftPowerView.m
//  ChatRoomMsgViewDemo
//
//  Created by ztp on 2021/10/29.
//

#import "TXVoiceRoomGiftPowerView.h"
#import <Masonry/Masonry.h>

#define RGBA_OF(rgbValue)   [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define RGBAOF(rgbValue, alphas)   [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphas]

@interface TXVoiceRoomGiftPowerView ()

@property (nonatomic, strong) UIView *lineBgView;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *desLab;
@property (nonatomic, strong) UILabel *numberLab;

@end

@implementation TXVoiceRoomGiftPowerView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.lineBgView];
        [self addSubview:self.lineView];
        [self addSubview:self.titleLab];
        [self addSubview:self.desLab];
        [self addSubview:self.numberLab];
        
        [self congfigFrame];
    }
    return self;
}
- (void)congfigFrame{
    [self.lineBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self).inset(15);
        make.height.equalTo(@1.5);
        make.top.equalTo(self.mas_top);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lineBgView.mas_left);
        make.height.equalTo(@1.5);
        make.top.equalTo(self.mas_top);
        make.width.equalTo(@100);
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.top.equalTo(self.lineBgView.mas_bottom).offset(2);
    }];
    
    [self.numberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.top.equalTo(self.lineBgView.mas_bottom).offset(2);
    }];
    [self.desLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.numberLab.mas_left).offset(-2);
        make.top.equalTo(self.lineBgView.mas_bottom).offset(2);
    }];
}
- (UIView *)lineBgView{
    if (!_lineBgView) {
        _lineBgView = [[UIView alloc] init];
        _lineBgView.backgroundColor = RGBAOF(0xfffff, 0.2);
        _lineBgView.layer.cornerRadius = 0.75;
    }
    return _lineBgView;
}
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = RGBA_OF(0x6F3AEE);
        _lineView.layer.cornerRadius = 0.75;
    }
    return _lineView;
}
- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.text = @"距离升级还差102果";
        _titleLab.textColor = RGBAOF(0xffffff, 0.5);
        _titleLab.font = [UIFont boldSystemFontOfSize:8];
    }
    return _titleLab;
}
- (UILabel *)desLab{
    if (!_desLab) {
        _desLab = [[UILabel alloc] init];
        _desLab.text = @"经验加成";
        _desLab.textColor = RGBAOF(0xffffff, 0.5);
        _desLab.font = [UIFont boldSystemFontOfSize:8];
    }
    return _desLab;
}
- (UILabel *)numberLab{
    if (!_numberLab) {
        _numberLab = [[UILabel alloc] init];
        _numberLab.text = @"30%";
        _numberLab.textColor = RGBAOF(0xffffff, 1.0);
        _numberLab.font = [UIFont boldSystemFontOfSize:8];
    }
    return _numberLab;
}
@end
