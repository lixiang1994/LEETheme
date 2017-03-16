//
//  CommunityPostImageView.h
//  MierMilitaryNews
//
//  Created by 李响 on 2016/10/31.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommunityPostImageView : UIImageView

@property (nonatomic , copy ) void (^deleteBlock)(id);

@end
