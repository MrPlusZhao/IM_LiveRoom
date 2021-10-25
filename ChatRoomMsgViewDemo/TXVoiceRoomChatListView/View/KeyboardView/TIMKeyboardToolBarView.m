//
//  TIMKeyboardToolBarView.m
//  ChatRoomMsgViewDemo
//
//  Created by ztp on 2021/10/22.
//

#import "TIMKeyboardToolBarView.h"
#import "UIView+Frame.h"
#import "TipCollectionItemCell.h"

#define MsgTableViewTop       300
#define MsgTableViewWidth     288
#define MsgTableViewHeight    300
#define ToolBarHeight         95
#define smallSpace            10

#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width

@interface TIMKeyboardToolBarView ()<UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

/// 键盘上层遮罩
@property (nonatomic, strong) UIView *coverView;

@end

@implementation TIMKeyboardToolBarView

- (void)awakeFromNib{
    [super awakeFromNib];
    // 监听键盘改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [self configTextField];
    [self configCollection];
}

- (void)configTextField{
    self.textField.delegate = self;
    self.textField.enablesReturnKeyAutomatically = YES; //这里设置为无文字就灰色不可点
    [self.topView addRoundedCorners:UIRectCornerTopLeft |UIRectCornerTopRight withRadii:CGSizeMake(20, 10) viewRect:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 80)];
}
- (void)configCollection{
    self.tipCollectionView.delegate = self;
    self.tipCollectionView.dataSource = self;
    self.tipCollectionLayout.minimumInteritemSpacing = 10;
    [self.tipCollectionView registerNib:[UINib nibWithNibName:@"TipCollectionItemCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"TipCollectionItemCell"];

}
#pragma mark -- UICollectionViewDelegateFlowLayout
/** 每个cell的尺寸*/
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(40, 20);
}
/** section的margin*/
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击了第几%ld项目",indexPath.item);
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 9;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TipCollectionItemCell *cellItem = [collectionView dequeueReusableCellWithReuseIdentifier:@"TipCollectionItemCell" forIndexPath:indexPath];
    if (!cellItem) {
        cellItem = [[NSBundle mainBundle] loadNibNamed:@"TipCollectionItemCell" owner:self options:nil].lastObject;
    }
    return cellItem;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField.text length]) {
        if (self.sendMessageBlock) {
            self.sendMessageBlock(textField.text);
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"sendMessageBlock" object:textField.text];
        [self.textField endEditing:YES];
        return YES;
    }
    return NO;
}

#pragma mark ================== 键盘事件相关
- (void)show
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
        for (UIWindow *window in frontToBackWindows)
        {
            BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
            BOOL windowIsVisible = !window.hidden && window.alpha > 0;
            BOOL windowLevelNormal = window.windowLevel == UIWindowLevelNormal;
            if(windowOnMainScreen && windowIsVisible && windowLevelNormal)
            {
                if (![window.subviews containsObject:self]) {
                    [window addSubview:self];
                }
                if (![window.subviews containsObject:self.coverView]) {
                    [window addSubview:self.coverView];
                }
                self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, ToolBarHeight);
                [self.textField becomeFirstResponder];
                break;
            }
        }
    }];
}

- (UIView *)coverView{
    if (!_coverView) {
        _coverView = [[UIView alloc] init];
        _coverView.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction)];
        [_coverView addGestureRecognizer:singleTap];
    }
    return _coverView;
}
- (void)singleTapAction{
    [self hide];
}
- (void)hide{
    if ([self.textField isFirstResponder]) {
        [self.textField endEditing:YES];
    }
}
- (void)keyboardWillChangeFrame:(NSNotification *)notification{
    
    NSDictionary *info = [notification userInfo];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect beginKeyboardRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endKeyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat yOffset = endKeyboardRect.origin.y - beginKeyboardRect.origin.y;
    if (yOffset < 0) {
        [UIView animateWithDuration:duration animations:^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(keyboardShow:)]) {
                [self.delegate keyboardShow:yOffset];
            }
            [self bringSubviewToFront:self];
            self.bottom = [UIScreen mainScreen].bounds.size.height + yOffset;
            self.coverView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - self.top);
        }];
    }
    else{
        [UIView animateWithDuration:0.25 animations:^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(keyboardHidden)]) {
                [self.delegate keyboardHidden];
            }
            self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, ToolBarHeight);
            if ([self.textField isFirstResponder]) {
                self.textField.text = @"";
                [self.textField endEditing:YES];
            }
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
            [self.coverView removeFromSuperview];
        }];
    }
}


@end
