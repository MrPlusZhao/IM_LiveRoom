//
//  TXVoiceRoomGiftBaseListView.h
//  ChatRoomMsgViewDemo
//
//  Created by ztp on 2021/10/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TXVoiceRoomGiftBaseListViewDelegate <NSObject>

@optional

- (void)pageControlChangeIndex:(NSInteger)index;
- (void)fatherViewCanScroll:(BOOL)canScroll;

@end

@interface TXVoiceRoomGiftBaseListView : UIView

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, weak)  id<TXVoiceRoomGiftBaseListViewDelegate > delegate;
@end

NS_ASSUME_NONNULL_END
