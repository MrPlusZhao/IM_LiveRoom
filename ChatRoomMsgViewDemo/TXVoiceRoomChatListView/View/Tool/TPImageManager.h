//
//  TPImageManager.h
//  ChatRoomMsgViewDemo
//
//  Created by ztp on 2021/10/15.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define RGBA_OF(rgbValue)   [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define RGBAOF(rgbValue, alphas)   [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphas]


@interface TPImageManager : NSObject


+ (instancetype)sharedInstance;

/** 初始化（APP生命周期只需要执行一次） */
- (void)setup;
- (void)destrory;

- (UIImage *)imageForLevel:(NSInteger)Level;

//===测试方法===
- (void)testData;
- (void)startCreateData;
- (void)stopCreate;
- (void)clearData;
//===测试方法===

@end

@interface LeveBgView : UIImageView

@property (nonatomic, assign) NSInteger level;

// 文字是否显示高亮
@property (nonatomic, assign) BOOL isShadeLv;

@end


NS_ASSUME_NONNULL_END
