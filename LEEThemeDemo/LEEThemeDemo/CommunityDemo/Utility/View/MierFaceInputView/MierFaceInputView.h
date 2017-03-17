//
//  MierFaceInputView.h
//  MierMilitaryNews
//
//  Created by 李响 on 16/8/31.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MierFaceInputView : UIView

@property (nonatomic , copy ) void (^selectedFaceBlock)(NSString *);

@property (nonatomic , copy ) void (^deleteBlock)();

/**
 *  初始化表情输入视图
 *
 *  @param frame          frame
 *  @param infoArray      信息数组
 *  @param maxLineNumber  最大行数
 *  @param maxSingleCount 单行最大个数
 *
 *  @return 视图对象
 */
- (instancetype)initWithFrame:(CGRect)frame
                      InfoDic:(NSDictionary *)infoDic
                MaxLineNumber:(NSInteger)maxLineNumber
               MaxSingleCount:(NSInteger)maxSingleCount;

/**
 *  删除按钮启用
 *
 *  @param enable YES or NO
 */
- (void)deleteButtonEnable:(BOOL)enable;

@end
