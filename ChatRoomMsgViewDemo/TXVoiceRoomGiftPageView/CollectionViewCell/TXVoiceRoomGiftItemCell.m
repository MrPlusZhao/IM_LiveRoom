//
//  TXVoiceRoomGiftItemCell.m
//  ChatRoomMsgViewDemo
//
//  Created by ztp on 2021/10/29.
//

#import "TXVoiceRoomGiftItemCell.h"
#define RGBA_OF(rgbValue)   [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation TXVoiceRoomGiftItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.quanBgView.layer.cornerRadius = 3;
    self.quanBgView.layer.borderColor = RGBA_OF(0xFFE403).CGColor;
    self.quanBgView.layer.borderWidth = 1;
    
    self.quanBgToTop.constant = 2;
    self.guoBgToTop.constant = 2;
    self.nomarlBgToTop.constant = 2;
    
    self.quanBgView.hidden = YES;
    self.guoBgView.hidden = YES;
    self.nomarlBgView.hidden = YES;

    self.type = [self randomData];
    
    switch (self.type) {
        case 0:
            self.nomarlBgView.hidden = NO;
            break;
        case 1:
            self.quanBgView.hidden = NO;
            break;
        case 2:
            self.guoBgView.hidden = NO;
            break;
        default:
            break;
    }
}
- (NSInteger)randomData{
    NSInteger randomNumber = arc4random()%3;
    return randomNumber;
}
@end
