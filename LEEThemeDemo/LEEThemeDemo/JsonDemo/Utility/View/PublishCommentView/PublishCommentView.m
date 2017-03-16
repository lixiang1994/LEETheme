//
//  PublishCommentView.m
//  MierMilitaryNews
//
//  Created by 李响 on 16/7/28.
//  Copyright © 2016年 miercn. All rights reserved.
//

#import "PublishCommentView.h"

#import "SDAutoLayout.h"

#import "MierFaceInputView.h"

#import "AppDelegate.h"

#import "YYLabel+Extend.h"

#import "MierProgressHUD.h"

@interface PublishCommentView ()<YYTextViewDelegate>

@property (nonatomic , strong ) UIView *editBackgroundView; //编辑背景视图

@property (nonatomic , strong ) UIView *editBarView; //编辑栏视图

@property (nonatomic , strong ) YYTextView *editView; //编辑视图

@property (nonatomic , strong ) UIButton *faceButton; //表情按钮

@property (nonatomic , strong ) UIButton *sendButton; //发送按钮

@property (nonatomic , strong ) MierFaceInputView *faceView;//米尔表情输入视图

@property (nonatomic , strong ) id context; //上下文

@end

@implementation PublishCommentView
{

    double keyboardDuration; //键盘弹出时长
    
    CGRect keyboardRect; //键盘尺寸
    
}

- (void)dealloc {
    
    //移除键盘通知
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    _editView.inputView = nil;
    
    _editBackgroundView = nil;
    
    _editBarView = nil;
    
    _editView = nil;
    
    _faceButton = nil;
    
    _sendButton = nil;
    
    _faceView = nil;
    
    _context = nil;
}

#pragma mark - 初始化

- (instancetype)init{
    
    self = [super init];
    
    if (self) {
        
        //添加通知
        
        [self addNotification];
        
        //初始化数据
        
        [self initData];
        
        //初始化子视图
        
        [self initSubview];
        
        //设置自动布局
        
        [self configAutoLayout];
        
        //设置主题
        
        [self configTheme];
        
    }
    
    return self;
}

#pragma mark - 添加通知

- (void)addNotification{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShown:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardDidHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    
}

#pragma mark ---键盘即将显示

- (void)keyboardWillShown:(NSNotification *)notify{
    
    keyboardRect = [[[notify userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    //取得键盘的动画时间，这样可以在视图上移的时候更连贯
    
    double duration = [[[notify userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    self.editBackgroundView.sd_layout.heightIs(self.editBarView.height + keyboardRect.size.height);
    
    //添加动画
    
    [UIView beginAnimations:@"Animation_Shown" context:nil];
    
    [UIView setAnimationDuration:duration ? duration : 0.25f];
    
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    
    //设置编辑背景视图位置
    
    self.editBackgroundView.sd_layout.yIs(keyboardRect.origin.y - self.editBarView.height).heightIs(self.editBarView.height + keyboardRect.size.height);
    
    [UIView commitAnimations];

}

#pragma mark ---键盘显示

- (void)keyboardWasShown:(NSNotification *)notif{
    
}

#pragma mark ---键盘即将隐藏

- (void)keyboardWillHidden:(NSNotification *)notif{
    
    //取得键盘的动画时间，这样可以在视图上移的时候更连贯
    
    double duration = [[notif.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //添加动画
    
    [UIView beginAnimations:@"Animation_Hidden" context:nil];
    
    [UIView setAnimationDuration:duration ? duration : 0.25f];
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    //设置编辑背景视图位置
    
    self.editBackgroundView.sd_layout.yIs(self.height).heightIs(50.0f);
    
    [UIView commitAnimations];
    
}

#pragma mark ---键盘隐藏

- (void)keyboardWasHidden:(NSNotification *)notif{
    
}


#pragma mark - 初始化数据

- (void)initData{
    
    self.frame = [UIScreen mainScreen].bounds;
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0f];
}

#pragma mark - 初始化子视图

- (void)initSubview{
    
    //初始化编辑背景视图
    
    _editBackgroundView = [[UIView alloc] init];
    
    [self addSubview:_editBackgroundView];
    
    //初始化编辑栏视图
    
    _editBarView = [[UIView alloc] init];
    
    [_editBackgroundView addSubview:_editBarView];
    
    //初始化表情按钮
    
    _faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [_faceButton setImage:[UIImage imageNamed:@"infor_pop_comment_expression"] forState:UIControlStateNormal];
    
    [_faceButton addTarget:self action:@selector(faceButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [_editBarView addSubview:_faceButton];
    
    //初始化发送按钮
    
    _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [_sendButton setTitle:@"发表" forState:UIControlStateNormal];
    
    [_sendButton setBackgroundColor:[[UIColor grayColor] colorWithAlphaComponent:0.5f]];
    
    [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_sendButton.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    
    [_sendButton.layer setCornerRadius:5.0f];
    
    [_sendButton setClipsToBounds:YES];
    
    [_sendButton addTarget:self action:@selector(sendButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [_editBarView addSubview:_sendButton];
    
    //初始化编辑视图
    
    YYTextSimpleEmoticonParser *parser = [YYTextSimpleEmoticonParser new];
    
    parser.emoticonMapper = [YYLabel faceMapper];
    
    YYTextLinePositionSimpleModifier *mod = [YYTextLinePositionSimpleModifier new];

    mod.fixedLineHeight = 16.0f + 5;

    _editView  = [YYTextView new];
    
    _editView.textParser = parser;
    
    _editView.linePositionModifier = mod;
    
    _editView.delegate = self;
    
    _editView.layer.borderWidth = 0.5f;
    
    _editView.layer.borderColor = [[UIColor grayColor] colorWithAlphaComponent:0.3f].CGColor;
    
    _editView.layer.cornerRadius = 5.0f;
    
    _editView.clipsToBounds = YES;
    
    _editView.font = [UIFont systemFontOfSize:16.0f];
    
    _editView.placeholderFont = [UIFont systemFontOfSize:16.0f];
    
    _editView.placeholderText = @"我来说两句";
    
    _editView.placeholderTextColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5f];
    
    _editView.textContainerInset = UIEdgeInsetsMake(5, 10, 10, 10);
    
    [_editBarView addSubview:_editView];
    
}

#pragma mark - 设置自动布局

- (void)configAutoLayout{
    
    _editBackgroundView.sd_layout
    .xIs(0)
    .yIs(self.height)
    .widthIs(self.width)
    .heightIs(50.f);
    
    _editBarView.sd_layout
    .topEqualToView(_editBackgroundView)
    .leftEqualToView(_editBackgroundView)
    .widthIs(_editBackgroundView.width)
    .heightIs(50.f);
    
    _faceButton.sd_layout
    .leftSpaceToView(_editBarView , 10)
    .bottomSpaceToView(_editBarView , 7)
    .widthIs(36)
    .heightIs(36);
    
    _sendButton.sd_layout
    .rightSpaceToView(_editBarView , 10)
    .bottomSpaceToView(_editBarView , 7)
    .widthIs(60)
    .heightIs(36);
    
    _editView.sd_layout
    .leftSpaceToView(_faceButton , 10)
    .rightSpaceToView(_sendButton , 10)
    .bottomSpaceToView(_editBarView , 7)
    .heightIs(36);
    
}

#pragma mark - 设置主题

- (void)configTheme{
    
    self.editBackgroundView.lee_theme.LeeConfigBackgroundColor(common_bg_color_8);
    
    self.editView.lee_theme
    .LeeConfigBackgroundColor(common_bg_color_8)
    .LeeConfigTextColor(common_font_color_1)
    .LeeAddCustomConfig(DAY , ^(YYTextView *item){
        
        item.keyboardAppearance = UIKeyboardAppearanceDefault;
    })
    .LeeAddCustomConfig(NIGHT , ^(YYTextView *item){
        
        item.keyboardAppearance = UIKeyboardAppearanceDark;
    });
    
}

#pragma mark - 表情按钮点击事件

- (void)faceButtonAction:(UIButton *)sender{
    
    if (self.editView.inputView) {
        
        self.editView.inputView = nil;
        
    } else {
        
        self.editView.inputView = self.faceView;
    }
    
    //更新输入视图
    
    [self.editView reloadInputViews];
    
}

#pragma mark - 发送按钮点击事件

- (void)sendButtonAction:(UIButton *)sender{
    
    //判断文本视图内容是否不为空
    
    if (self.editView.text.length > 0) {
        
        [self hide];
        
        if (self.publishCommentBlock) {
            
            self.publishCommentBlock(self.editView.text);
        }
        
        if (self.publishCommentAndContextBlock) {
            
            self.publishCommentAndContextBlock(self.editView.text , self.context);
        }
        
    } else {
        
        [MierProgressHUD showMessage:@"写点什么吧"];
    }
    
}

#pragma mark - 设置占位字符串

- (void)configPlaceHolderWithText:(NSString *)text{
    
    self.editView.placeholderText = text;
    
}

#pragma mark - 设置上下文

- (void)configContext:(id)context{
    
    self.context = context;
}

#pragma mark - 清空内容

- (void)clear{
    
    self.editView.text = @"";
    
    self.context = nil;
}

#pragma mark - 显示

- (void)show{
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [appDelegate.window addSubview:self];
    
    [self.editView becomeFirstResponder];
    
    [UIView animateWithDuration:0.25f animations:^{
       
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
        
    } completion:^(BOOL finished) { }];
    
}

#pragma mark - 隐藏

- (void)hide{
    
    //释放第一响应者
    
    [self.editView resignFirstResponder];
    
    [UIView animateWithDuration:0.25f animations:^{
       
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0f];
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [super touchesBegan:touches withEvent:event];
    
    //点击隐藏
    
    [self hide];
}

#pragma mark - YYTextViewDelegate

- (BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    //限制输入字数
    
    return YES;
}

- (void)textViewDidChange:(YYTextView *)textView{
    
    //判断是否超过指定行数
    
    if (textView.textLayout.rowCount < 5) {
        
        //添加动画
        
        [UIView beginAnimations:@"" context:nil];
        
        [UIView setAnimationDuration:0.25f];
        
        //如果内容高度大于默认高度 则改变高度
        
        if (textView.textLayout.rowCount > 1) {
            
            textView.sd_layout.heightIs(textView.contentSize.height);
            
        } else {
            
            textView.sd_layout.heightIs(36);
        }
        
        //更新相关视图
        
        self.editBarView.sd_layout.heightIs(textView.height + 14);
        
        self.editBackgroundView.sd_layout.yIs(keyboardRect.origin.y - self.editBarView.height).heightIs(self.editBarView.height + keyboardRect.size.height);
        
        [self.faceButton updateLayout];
        
        [self.sendButton updateLayout];
        
        [UIView commitAnimations];
        
        textView.scrollEnabled = NO;
        
    } else {
        
        textView.scrollEnabled = YES;
    }
    
    //判断文本视图内容是否不为空
    
    if (self.editView.text.length > 0) {
        
        self.sendButton.backgroundColor = [UIColor leeTheme_ColorFromJsonWithTag:[LEETheme currentThemeTag] WithIdentifier:common_bg_blue_4];
        
        [self.faceView deleteButtonEnable:YES];
        
    } else {
        
        self.sendButton.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5f];
        
        [self.faceView deleteButtonEnable:NO];
    }
    
}

#pragma mark - LazyLoading

- (MierFaceInputView *)faceView{
    
    if (!_faceView) {
        
        _faceView = [[MierFaceInputView alloc] initWithFrame:CGRectMake(0 , self.height , self.width , 220) InfoDic:nil MaxLineNumber:3 MaxSingleCount:5];
        
        [_faceView deleteButtonEnable:NO]; //默认不启用
        
        _faceView.lee_theme.LeeConfigBackgroundColor(common_bg_color_8);
        
        __weak typeof(self) weakSelf = self;
        
        _faceView.selectedFaceBlock = ^(NSString *faceName){
            
            if (weakSelf) {
                
                //插入表情字符
                
                [weakSelf.editView insertText:faceName];
            }
            
        };
        
        _faceView.deleteBlock = ^(){
          
            if (weakSelf) {
                
                //删除
                
                [weakSelf.editView deleteBackward];
            }
            
        };
        
    }
    
    return _faceView;
}

@end
