//
//  UIAlertView+BlockSupport.m
//  Pandora
//
//  Created by zhuxiaohu on 3/20/14.
//  Copyright (c) 2014 zhuxiaohu. All rights reserved.
//

#import "UIAlertView+BlockSupport.h"
#import <objc/runtime.h>
static char DISMISS_IDENTIFER;
static char CANCEL_IDENTIFER;

@implementation UIAlertView (BlockSupport)

@dynamic cancelBlock;
@dynamic dismissBlock;

- (void)setDismissBlock:(DismissHandler)dismissBlock
{
    objc_setAssociatedObject(self, &DISMISS_IDENTIFER, dismissBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (DismissHandler)dismissBlock
{
    return objc_getAssociatedObject(self, &DISMISS_IDENTIFER);
}

- (void)setCancelBlock:(CancelHandler)cancelBlock
{
    objc_setAssociatedObject(self, &CANCEL_IDENTIFER, cancelBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CancelHandler)cancelBlock
{
    return objc_getAssociatedObject(self, &CANCEL_IDENTIFER);
}


+ (UIAlertView*) alertViewWithTitle:(NSString*) title
                            message:(NSString*) message
                  cancelButtonTitle:(NSString*) cancelButtonTitle
                  otherButtonTitles:(NSArray*) otherButtons
                          onDismiss:(DismissHandler) dismissed
                           onCancel:(CancelHandler) cancelled {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:[self class]
                                          cancelButtonTitle:cancelButtonTitle
                                          otherButtonTitles:nil];
    
    [alert setDismissBlock:dismissed];
    [alert setCancelBlock:cancelled];
    
    for(NSString *buttonTitle in otherButtons)
        [alert addButtonWithTitle:buttonTitle];
    
    [alert show];
    return alert;
}

+ (UIAlertView*) alertViewWithTitle:(NSString*) title
                            message:(NSString*) message {
    
    return [UIAlertView alertViewWithTitle:title
                                   message:message
                         cancelButtonTitle:NSLocalizedString(@"取消", @"")];
}

+ (UIAlertView*) alertViewWithTitle:(NSString*) title
                            message:(NSString*) message
                  cancelButtonTitle:(NSString*) cancelButtonTitle {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:cancelButtonTitle
                                          otherButtonTitles: nil];
    [alert show];
    return alert;
}

+ (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == [alertView cancelButtonIndex])
	{
		if (alertView.cancelBlock) {
            alertView.cancelBlock();
        }
	}
    else
    {
        if (alertView.dismissBlock) {
            alertView.dismissBlock(buttonIndex - 1); // cancel button is button 0
        }
    }
}

@end
