//
//  TIMKeyboardToolBarView.h
//  ChatRoomMsgViewDemo
//
//  Created by ztp on 2021/10/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TIMKeyboardToolBarViewDelegate <NSObject>

- (void)keyboardShow:(CGFloat)yOffset;
- (void)keyboardHidden;

@end

@interface TIMKeyboardToolBarView : UIView

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UICollectionView *tipCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *tipCollectionLayout;

@property (nonatomic, weak) id<TIMKeyboardToolBarViewDelegate> delegate;

@property (nonatomic, copy) void(^sendMessageBlock)(NSString *);

- (void)show;

@end

NS_ASSUME_NONNULL_END
