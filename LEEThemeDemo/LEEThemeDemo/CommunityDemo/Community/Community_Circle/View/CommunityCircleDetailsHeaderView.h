//
//  CommunityCircleDetailsHeaderView.h
//  MierMilitaryNews
//
//  Created by 李响 on 2016/10/26.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommunityCircleDetailsHeaderView : UIView

@property (nonatomic , copy ) void (^backBlock)(); //返回Block

@property (nonatomic , copy ) void (^openPostBlock)(); //打开发帖

- (void)configPicImageUrl:(NSString *)picImageUrl
             IconImageUrl:(NSString *)iconImageUrl
                    Title:(NSString *)title
                 Describe:(NSString *)describe;

@end
