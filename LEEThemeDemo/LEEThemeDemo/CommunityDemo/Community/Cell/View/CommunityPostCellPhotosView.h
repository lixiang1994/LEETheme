//
//  CommunityPostCellPhotosView.h
//  MierMilitaryNews
//
//  Created by 李响 on 2016/10/26.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommunityPostCellPhotosView : UIView

/**
 设置图片Url

 @param imageUrlArray 图片Url数组
 @param imageCount    图片数量
 */
- (void)configImageUrlArray:(NSArray *)imageUrlArray ImageCount:(NSInteger)imageCount;

@end
