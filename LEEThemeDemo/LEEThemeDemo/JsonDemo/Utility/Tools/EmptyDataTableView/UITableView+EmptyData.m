//
//  UITableView+EmptyData.m
//  MierMilitaryNews
//
//  Created by 李响 on 2017/2/13.
//  Copyright © 2017年 miercn. All rights reserved.
//

#import "UITableView+EmptyData.h"

#import "SDAutoLayout.h"

@implementation UITableView (EmptyData)

- (void)configDelegate{
    
    self.emptyDataSetSource = self;
    
    self.emptyDataSetDelegate = self;
}

#pragma mark - property

- (NSString *)emptyDataPrompt{
    
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setEmptyDataPrompt:(NSString *)emptyDataPrompt{
    
    [self configDelegate];
    
    objc_setAssociatedObject(self, @selector(emptyDataPrompt), emptyDataPrompt , OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (UIImage *)emptyDataImage{
    
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setEmptyDataImage:(UIImage *)emptyDataImage{
    
    [self configDelegate];
    
    objc_setAssociatedObject(self, @selector(emptyDataImage), emptyDataImage , OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - DZNEmptyDataSetSource , DZNEmptyDataSetDelegate

//- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
//    
//    return self.emptyDataImage;
//}
//
//- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
//    
//    NSString *text = self.emptyDataPrompt;
//    
//    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:16.0f],
//                                 NSForegroundColorAttributeName: [[UIColor grayColor] colorWithAlphaComponent:0.5f]};
//    
//    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
//}

- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width - 30, 150)];
    
    UIImageView *imageView = nil;
    
    UILabel *label = nil;
    
    if (self.emptyDataImage) {
     
        imageView = [[UIImageView alloc] init];
        
        imageView.image = self.emptyDataImage;
        
        [view addSubview:imageView];
        
        imageView.lee_theme
        .LeeAddCustomConfig(DAY , ^(UIImageView *item){
            
            item.alpha = 1.0f;
        })
        .LeeAddCustomConfig(NIGHT , ^(UIImageView *item){
            
            item.alpha = 0.5f;
        });
    }
    
    if (self.emptyDataPrompt) {
        
        label = [[UILabel alloc]init];
        
        label.font = [UIFont systemFontOfSize:16.0f];
        
        label.textAlignment = NSTextAlignmentCenter;
        
        label.text = self.emptyDataPrompt;
        
        [view addSubview:label];
        
        label.lee_theme.LeeConfigTextColor(common_font_color_4);
    }
    
    if (imageView) {
        
        imageView.sd_layout
        .centerXEqualToView(view)
        .centerYEqualToView(view)
        .widthIs(100.0f)
        .heightIs(100.0f);
    }
    
    if (label) {
        
        if (imageView) {
        
            label.sd_layout
            .topSpaceToView(imageView , 10.0f)
            .centerXEqualToView(view)
            .widthIs(150.0f)
            .heightIs(20.0f);
            
        } else {
         
            label.sd_layout
            .centerXEqualToView(view)
            .centerYEqualToView(view)
            .widthIs(150.0f)
            .heightIs(20.0f);
        }
        
    }
    
    return view;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
    
    if (self.emptyDataImage) {
        
        return (- self.emptyDataImage.size.height * 0.5f) + scrollView.contentInset.top;
    }
    
    return - 20.0f + scrollView.contentInset.top;
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView{
    
    return 11.0f;
}

@end
