//
//  MierPhotoBrowser.h
//  MierMilitaryNews
//
//  Created by 李响 on 2016/10/18.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MierPhotoBrowser : UIView

/**
    图片Url数组
 */
@property (nonatomic , strong ) NSArray *imageUrlArray;

/**
    当前下标
 */
@property (nonatomic , assign ) NSInteger index;

/**
    图片所属视图 (可选)
 */
@property (nonatomic , weak ) UIView *imageView;

+ (MierPhotoBrowser *)browser;

- (void)show;

@end

@interface MierPhotoBrowserCell : UICollectionViewCell

@property (nonatomic , strong ) NSURL *url;

@property (nonatomic , copy ) void (^loadFinishBlock)(NSURL *url , UIImage *image);

@property (nonatomic , copy ) void (^hideBlock)();

@end
