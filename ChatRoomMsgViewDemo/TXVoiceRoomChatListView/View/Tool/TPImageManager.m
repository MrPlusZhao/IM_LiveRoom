//
//  TPImageManager.m
//  ChatRoomMsgViewDemo
//
//  Created by ztp on 2021/10/15.
//

#import "TPImageManager.h"
#import "VoiceRoomChatMsgModel.h"
//=====

// 每一秒发送多少条消息
#define MAXCOUNT  5
//=====
@interface TPImageManager ()
{
    NSArray<NSString *> *_conmentAry;
    NSArray<NSString *> *_nameAry;
}
/** 数据源 */
@property (nonatomic, strong) NSMutableDictionary<NSString *, UIImage *> *data;
@property (nonatomic) dispatch_source_t timer;

@end

static TPImageManager *_instance = nil;
static dispatch_once_t _onceToken;

@implementation TPImageManager

+ (instancetype)sharedInstance {
    dispatch_once(&_onceToken, ^{
        _instance = [[TPImageManager alloc] init];
        _instance.data = [NSMutableDictionary dictionary];
    });
    return _instance;
}

- (void)setup {
    [self.data removeAllObjects];
    for (NSInteger i = 0; i <= 100; i++) {
        // 启动app我们调用一次这个方法，然后内存就有生成0-100等级图片
        LeveBgView *view = [[LeveBgView alloc] init];
        view.frame = CGRectMake(0, 0, 30.0, 14.0);
        view.layer.cornerRadius = 7;
        view.layer.masksToBounds = YES;
        view.isShadeLv = YES;
        view.level = i;
        
        [self.data setObject:[self convertCreateImageWithUIView:view] forKey:[NSString stringWithFormat:@"%li", (long)i]];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newMessageSend:) name:@"sendMessageBlock" object:nil];
    [[TPImageManager sharedInstance] testData];

}
- (void)destrory{
    _onceToken = 0;
    _instance = nil;
    NSLog(@"单例销毁");
}
- (void)newMessageSend:(NSNotification*)noti{
    [self creatTestIMMsg:noti.object];
}
- (UIImage *)imageForLevel:(NSInteger)Level {
    return [self.data objectForKey:[NSString stringWithFormat:@"%li", (long)Level]];
}


/** 将 UIView 转换成 UIImage */
- (UIImage *)convertCreateImageWithUIView:(UIView *)view {
    
    //UIGraphicsBeginImageContext(view.bounds.size);
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [UIScreen mainScreen].scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:ctx];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark 数据测试 随机生成不同类型消息


// 随机生成不同类型消息
- (void)creatTestIMMsg:(NSString*)message {
    NSInteger subType = [message integerValue];
    VoiceRoomChatMsgModel *msgModel = [VoiceRoomChatMsgModel new];
    if (subType == -1) {
        msgModel.subType = arc4random() % 7;
    } else {
        msgModel.subType = subType;
    }
    msgModel.msgID = [NSString stringWithFormat:@"msgID_%u", arc4random() % 1000000];
    
    VoiceRoomChatUserModel *user = [VoiceRoomChatUserModel new];
    user.nickName = _nameAry[arc4random() % _nameAry.count];
    user.userID = [NSString stringWithFormat:@"userID_%ld", msgModel.subType];
    user.level = arc4random() % 100;
    user.gender = arc4random() % 1;
    if (subType == VoiceRoomMsgType_MemberSpecialEnter) {
        user.mount = @"小毛驴";
    }
    msgModel.user = user;
    
    switch (msgModel.subType) {
        case VoiceRoomMsgType_Member_Comment:
        {
            msgModel.content = _conmentAry[arc4random() % _conmentAry.count];
        }
            break;
        case VoiceRoomMsgType_MemberEnter:
        {
            msgModel.content = @"进入了直播间";
        }
            break;
        case VoiceRoomMsgType_System_msg:
            msgModel.content = @"欢迎各位来到直播间，直播内容包括任何低俗和暴露的内容将会被封禁账号，安全部门会24小时巡查噢~欢迎各位来到直播间，直播内容包括任何低俗和暴露的内容将会被封禁账号，安全部门会24小时巡查噢~\n";
            break;
        case VoiceRoomMsgType_Gift_Text:
        {
            msgModel.quantity = @"1";
            msgModel.giftModel = [VoiceRoomChatGiftModel new];
            msgModel.giftModel.giftID = [NSString stringWithFormat:@"giftID_%u", arc4random() % 10];
            msgModel.giftModel.thumbnailUrl = @"https://showme-livecdn.9yiwums.com/gift/gift/20190225/b9a2dc3f1bef436598dfa470eada6a60.png";
            msgModel.giftModel.name = @"烟花";
        }
            break;
        case VoiceRoomMsgType_Guard:
        {
            VoiceRoomChatUserModel *user = [VoiceRoomChatUserModel new];
            user.nickName = _nameAry[arc4random() % _nameAry.count];
            user.userID = [NSString stringWithFormat:@"userID_%ld", msgModel.subType];
            user.level = arc4random() % 100;
            user.gender = arc4random() % 1;
            msgModel.receivedUser = user;
            msgModel.GuardName = @"国王";
        }
            break;
        case VoiceRoomMsgType_KickOut:
        {
            VoiceRoomChatUserModel *user = [VoiceRoomChatUserModel new];
            user.nickName = _nameAry[arc4random() % _nameAry.count];
            user.userID = [NSString stringWithFormat:@"userID_%ld", msgModel.subType];
            user.level = arc4random() % 100;
            user.gender = arc4random() % 1;
            msgModel.KickOutUser = user;
        }
            break;
        case VoiceRoomMsgType_Forbidden:
        {
            VoiceRoomChatUserModel *user = [VoiceRoomChatUserModel new];
            user.nickName = _nameAry[arc4random() % _nameAry.count];
            user.userID = [NSString stringWithFormat:@"userID_%ld", msgModel.subType];
            user.level = arc4random() % 100;
            user.gender = arc4random() % 1;
            msgModel.KickOutUser = user;
        }
            break;
        default:
            msgModel.content = message;
            break;
    }
    // 生成富文本模型
    [msgModel initMsgAttribute];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TIM_NEW_MESSAGE" object:msgModel];
}
- (void)testData{
    _conmentAry = @[@"如果我是DJ你会爱我吗🏷💋❤️💘💇 哟哟哟~~~",
                    @"好喜欢主播，主播唱歌太好听了🎤🎤🎤🎤",  @"تیتینینینی这是阿拉伯文，阿拉伯文从右到左排版，我们强制把它从按照正常排版显示~~",
                    @"哟哟~~切克闹！煎饼果子来一套~~😻✊❤️🙇",
                    @"哟哟！！你看那面又大又宽，你看那碗又大又圆！哟哟~~~😁😁😁😁😁😁",
                    @"蔡徐坤是NBA打球最帅的woman~~😏😏😏😏😏😏，不服来辩~~",
                    @"吴亦凡是rap界最有内涵的woman😏😏😏😏😏😏，不服来辩~~~"];
    _nameAry = @[@"蔡徐坤", @"吴亦凡", @"吴京", @"成龙", @"郭敬明"];
    [self creatTestIMMsg:@"117"];
}

- (void)startCreateData{
    
    if (_timer == nil) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC/MAXCOUNT, 0);
        dispatch_source_set_event_handler(_timer, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"sendMessageBlock" object:@((101+arc4random() % 17)).stringValue];
            });
        });
        dispatch_resume(_timer);
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self stopCreate];
    });
}
- (void)stopCreate{
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
}
- (void)clearData{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TIM_CLEAR_MESSAGE" object:nil];
}
@end


@interface LeveBgView()
@property (nonatomic, strong) UIImageView *leveImage;
@property (nonatomic, strong) UILabel *leveLabel;
@end

@implementation LeveBgView

- (instancetype)init {
    if (self = [super init]) {
        [self addSubview:self.leveImage];
        [self addSubview:self.leveLabel];
        
        self.leveImage.frame = CGRectMake(2, 2, 10, 10);
        self.leveLabel.frame = CGRectMake(12, 0, 16, 14);
    }
    return self;
}


- (void)setLevel:(NSInteger)level {
    _level = level;
    UIColor *color;
    NSString *imageName;
    self.image = nil;
    self.leveLabel.font = [UIFont boldSystemFontOfSize:10];
    
    if (level <= 7) {
        color = RGBA_OF(0xA6D259);
        imageName = @"icon_rank_1_7";
    }else if (level > 7 && level <= 16) {
        color = RGBA_OF(0x40BFF9);
        imageName = @"icon_rank_8_16";
    }else if (level > 16 && level <= 30) {
        color = RGBA_OF(0xFFBE0F);
        imageName = @"icon_rank_17_30";
    }else if (level > 30 && level <= 63) {
        color = RGBA_OF(0x8D28F1);
        imageName = @"icon_rank_31_63";
    }else {
        color = [UIColor clearColor];
        imageName = @"icon_rank_64_99";
        self.image = [UIImage imageNamed:@"icon_rank_bg_64"];
        if ([NSString stringWithFormat:@"%ld", level].length >= 3) {
            self.leveLabel.font = [UIFont boldSystemFontOfSize:7.8];
        }
    }
    
    self.backgroundColor = color;
    // 渐变色
    //[self.leveBgImage.layer addSublayer:[YWUtils setGradualChangingColor:self.leveBgImage fromColor:MLHexColor(@"8E45EC") toColor:MLHexColor(@"FD085E")]];//color;
    self.leveImage.image = [UIImage imageNamed:imageName];
    if (level <= 0) level = 0;
    
    if (self.isShadeLv) {
        NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld", level] attributes:@{NSShadowAttributeName:[self getTextShadow]}];
        
        self.leveLabel.attributedText = str1;
    } else {
        self.leveLabel.text = [NSString stringWithFormat:@"%ld", level];
    }
}

// 文字阴影效果
- (NSShadow *)getTextShadow {
    NSShadow *shadow = [[NSShadow alloc] init];
    //shadow.shadowBlurRadius = 1;
    shadow.shadowOffset = CGSizeMake(0, 0.5);
    shadow.shadowColor = RGBAOF(0x000000, 0.5);
    
    return shadow;
}

- (UILabel *)leveLabel {
    if (!_leveLabel) {
        _leveLabel = [UILabel new];
        _leveLabel.textColor = RGBA_OF(0xffffff);
        _leveLabel.font = [UIFont boldSystemFontOfSize:10];
        _leveLabel.textAlignment = NSTextAlignmentCenter;
//        _leveLabel.shadowOffset = CGSizeMake(0, 0.5);
//        _leveLabel.shadowColor = RGBAOF(0x000000, 0.5);
    }
    return _leveLabel;
}

- (UIImageView *)leveImage {
    if (!_leveImage) {
        _leveImage = [UIImageView new];
    }
    return _leveImage;
}

@end

