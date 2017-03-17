//
//  YYLabel+Extend.h
//  MierMilitaryNews
//
//  Created by 李响 on 2016/12/7.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import "YYKit.h"

#define faceGreenNameArray @[@"[微笑]",@"[抠鼻]",@"[大笑]",@"[调皮]",@"[阴险]",@"[鼓掌]",@"[抓狂]",@"[大哭]",@"[傲慢]",@"[鄙视]",@"[奋斗]",@"[发怒]"]
#define faceWhiteNameArray @[@"[吐]",@"[得意]",@"[晕]",@"[咒骂]",@"[闭嘴]",@"[睡觉]",@"[疑问]",@"[流汗]",@"[委屈]",@"[龇牙]",@"[恭喜]",@"[撇嘴]"]

#define faceGreenImageArray @[@"cmbq_green_1",@"cmbq_green_2",@"cmbq_green_3",@"cmbq_green_4",@"cmbq_green_5",@"cmbq_green_6",@"cmbq_green_7",@"cmbq_green_8",@"cmbq_green_9",@"cmbq_green_10",@"cmbq_green_11",@"cmbq_green_12"]
#define faceWhiteImageArray @[@"cmbq_white_1",@"cmbq_white_2",@"cmbq_white_3",@"cmbq_white_4",@"cmbq_white_5",@"cmbq_white_6",@"cmbq_white_7",@"cmbq_white_8",@"cmbq_white_9",@"cmbq_white_10",@"cmbq_white_11",@"cmbq_white_12"]

@interface YYLabel (Extend)

/**
 表情字典
 
 @return 字典
 */
+ (NSDictionary *)faceMapper;

/**
 设置文本布局 (YYLabel)
 
 @param label YYLabel
 @param maxRows 最大行数
 @param maxSize 最大范围
 */
+ (void)configTextLayoutWithLabel:(YYLabel *)label MaxRows:(NSInteger)maxRows MaxSize:(CGSize)maxSize;

@end
