//
//  YYLabel+Extend.m
//  MierMilitaryNews
//
//  Created by 李响 on 2016/12/7.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import "YYLabel+Extend.h"

@implementation YYLabel (Extend)

#pragma mark - 表情字典

+ (NSDictionary *)faceMapper{
    
    //使用单例 只初始化一次
    
    static NSMutableDictionary *faceMapper;
    
    if (!faceMapper) {
        
        faceMapper = [NSMutableDictionary dictionary];
        
        NSMutableArray *faceNameArray = [NSMutableArray arrayWithArray:faceGreenNameArray];
        
        [faceNameArray addObjectsFromArray:faceWhiteNameArray];
        
        NSMutableArray *faceImageArray = [NSMutableArray arrayWithArray:faceGreenImageArray];
        
        [faceImageArray addObjectsFromArray:faceWhiteImageArray];
        
        NSInteger index = 0;
        
        for (NSString *faceName in faceNameArray) {
            
            UIImage *image = [UIImage imageNamed:faceImageArray[index]];
            
            [faceMapper setObject:image forKey:faceName];
            
            index ++;
        }
        
    }
    
    return faceMapper;
}

#pragma mark - 设置文本布局 (YYLabel)

+ (void)configTextLayoutWithLabel:(YYLabel *)label MaxRows:(NSInteger)maxRows MaxSize:(CGSize)maxSize{
    
    // 创建文本容器
    
    YYTextContainer *container = [YYTextContainer new];
    
    container.size = CGSizeMake(maxSize.width, maxSize.height);
    
    container.maximumNumberOfRows = maxRows;
    
    // 生成排版结果
    
    YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:label.attributedText];
    
    label.textLayout = layout;
}

@end
