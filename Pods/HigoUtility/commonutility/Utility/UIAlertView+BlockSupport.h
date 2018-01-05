//
//  UIAlertView+BlockSupport.h
//  Pandora
//
//  Created by zhuxiaohu on 3/20/14.
//  Copyright (c) 2014 zhuxiaohu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^DismissHandler)(NSInteger index);
typedef void(^CancelHandler)();
@interface UIAlertView (BlockSupport)
+ (UIAlertView*) alertViewWithTitle:(NSString*) title
                            message:(NSString*) message;

+ (UIAlertView*) alertViewWithTitle:(NSString*) title
                            message:(NSString*) message
                  cancelButtonTitle:(NSString*) cancelButtonTitle;

+ (UIAlertView*) alertViewWithTitle:(NSString*) title
                            message:(NSString*) message
                  cancelButtonTitle:(NSString*) cancelButtonTitle
                  otherButtonTitles:(NSArray*) otherButtons
                          onDismiss:(DismissHandler) dismissed
                           onCancel:(CancelHandler) cancelled;

@property (nonatomic, copy) DismissHandler dismissBlock;
@property (nonatomic, copy) CancelHandler cancelBlock;
@end
