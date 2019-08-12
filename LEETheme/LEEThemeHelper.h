
/*!
 *  @header LEEThemeHelper.h
 *
 *  ┌─┐      ┌───────┐ ┌───────┐ 帅™
 *  │ │      │ ┌─────┘ │ ┌─────┘
 *  │ │      │ └─────┐ │ └─────┐
 *  │ │      │ ┌─────┘ │ ┌─────┘
 *  │ └─────┐│ └─────┐ │ └─────┐
 *  └───────┘└───────┘ └───────┘
 *
 *  @brief  LEE主题管理
 *
 *  @author LEE
 *  @copyright    Copyright © 2016 - 2019年 lee. All rights reserved.
 *  @version    V1.1.9
 */

FOUNDATION_EXPORT double LEEThemeVersionNumber;
FOUNDATION_EXPORT const unsigned char LEEThemeVersionString[];

#ifndef LEEThemeHelper_h
#define LEEThemeHelper_h

@class LEEThemeConfigModel;

#pragma mark - 宏

#define LEEColorRGBA(R , G , B , A) [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:A]

#define LEEColorRGB(R , G , B) LEEColorRGBA(R , G , B , 1.0f)

#define LEEColorHex(hex) [UIColor leeTheme_ColorWithHexString:hex]

#define LEEColorFromIdentifier(tag, identifier) ({((UIColor *)([LEETheme getValueWithTag:tag Identifier:identifier]));})

#define LEEImageFromIdentifier(tag, identifier) ({((UIImage *)([LEETheme getValueWithTag:tag Identifier:identifier]));})

#define LEEValueFromIdentifier(tag, identifier) ({([LEETheme getValueWithTag:tag Identifier:identifier]);})

#pragma mark - typedef

NS_ASSUME_NONNULL_BEGIN

typedef void(^LEEThemeConfigBlock)(id item);
typedef void(^LEEThemeConfigBlockToValue)(id item , id value);
typedef void(^LEEThemeChangingBlock)(NSString *tag , id item);
typedef LEEThemeConfigModel * _Nonnull (^LEEConfigTheme)(void);
typedef LEEThemeConfigModel * _Nonnull (^LEEConfigThemeToFloat)(CGFloat number);
typedef LEEThemeConfigModel * _Nonnull (^LEEConfigThemeToTag)(NSString *tag);
typedef LEEThemeConfigModel * _Nonnull (^LEEConfigThemeToKeyPath)(NSString *keyPath);
typedef LEEThemeConfigModel * _Nonnull (^LEEConfigThemeToSelector)(SEL selector);
typedef LEEThemeConfigModel * _Nonnull (^LEEConfigThemeToIdentifier)(NSString *identifier);
typedef LEEThemeConfigModel * _Nonnull (^LEEConfigThemeToChangingBlock)(LEEThemeChangingBlock);
typedef LEEThemeConfigModel * _Nonnull (^LEEConfigThemeToT_KeyPath)(NSString *tag , NSString *keyPath);
typedef LEEThemeConfigModel * _Nonnull (^LEEConfigThemeToT_Selector)(NSString *tag , SEL selector);
typedef LEEThemeConfigModel * _Nonnull (^LEEConfigThemeToT_Color)(NSString *tag , id color);
typedef LEEThemeConfigModel * _Nonnull (^LEEConfigThemeToT_Image)(NSString *tag , id image);
typedef LEEThemeConfigModel * _Nonnull (^LEEConfigThemeToT_Block)(NSString *tag , LEEThemeConfigBlock);
typedef LEEThemeConfigModel * _Nonnull (^LEEConfigThemeToTs_Block)(NSArray *tags , LEEThemeConfigBlock);
typedef LEEThemeConfigModel * _Nonnull (^LEEConfigThemeToKeyPathAndIdentifier)(NSString *keyPath , NSString *identifier);
typedef LEEThemeConfigModel * _Nonnull (^LEEConfigThemeToSelectorAndIdentifier)(SEL sel , NSString *identifier);
typedef LEEThemeConfigModel * _Nonnull (^LEEConfigThemeToSelectorAndIdentifierAndValueIndexAndValueArray)(SEL sel , NSString *identifier , NSInteger valueIndex , NSArray *otherValues);
typedef LEEThemeConfigModel * _Nonnull (^LEEConfigThemeToSelectorAndValues)(SEL sel , NSArray *values);
typedef LEEThemeConfigModel * _Nonnull (^LEEConfigThemeToIdentifierAndState)(NSString *identifier , UIControlState state);
typedef LEEThemeConfigModel * _Nonnull (^LEEConfigThemeToT_ColorAndState)(NSString *tag , UIColor *color , UIControlState state);
typedef LEEThemeConfigModel * _Nonnull (^LEEConfigThemeToT_ImageAndState)(NSString *tag , UIImage *image , UIControlState state);
typedef LEEThemeConfigModel * _Nonnull (^LEEConfigThemeToT_KeyPathAndValue)(NSString *tag , NSString *keyPath , id value);
typedef LEEThemeConfigModel * _Nonnull (^LEEConfigThemeToT_SelectorAndColor)(NSString *tag , SEL sel , id color);
typedef LEEThemeConfigModel * _Nonnull (^LEEConfigThemeToT_SelectorAndImage)(NSString *tag , SEL sel , id image);
typedef LEEThemeConfigModel * _Nonnull (^LEEConfigThemeToT_SelectorAndValues)(NSString *tag , SEL sel , ...);
typedef LEEThemeConfigModel * _Nonnull (^LEEConfigThemeToT_SelectorAndValueArray)(NSString *tag , SEL sel , NSArray *values);
typedef LEEThemeConfigModel * _Nonnull (^LEEConfigThemeToIdentifierAndBlock)(NSString *identifier , LEEThemeConfigBlockToValue);

NS_ASSUME_NONNULL_END

#endif /* LEEThemeHelper_h */
