//
//  UIActionSheet+BlockSupport.h
//  Pandora
//
//  Created by zhuxiaohu on 3/20/14.
//  Copyright (c) 2014 zhuxiaohu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^DismissHandler)(NSInteger index);
typedef void(^CancelHandler)();
@interface UIActionSheet (BlockSupport)

- (id)initWithTitle:(NSString *)title
  cancelButtonTitle:(NSString *)cancelButtonTitle
destructiveButtonTitle:(NSString *)destructiveButtonTitle
  otherButtonTitles:(NSArray *)otherButtonTitles
     dismissHandler:(DismissHandler)dismiss
      cancelHandler:(CancelHandler)cancel;
@end
