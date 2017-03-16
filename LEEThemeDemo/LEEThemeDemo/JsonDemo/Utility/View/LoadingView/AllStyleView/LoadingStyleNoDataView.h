//
//  LoadingStyleNoDataView.h
//  MierMilitaryNews
//
//  Created by 李响 on 15/9/11.
//  Copyright (c) 2015年 miercn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingStyleNoDataView : UIView

@property (nonatomic , assign ) id target;

@property (nonatomic , assign ) SEL action;

@property (nonatomic , copy ) NSString *title;//标题文字

@end
