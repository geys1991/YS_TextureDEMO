//
//  UIActionSheet+BlockSupport.m
//  Pandora
//
//  Created by zhuxiaohu on 3/20/14.
//  Copyright (c) 2014 zhuxiaohu. All rights reserved.
//

#import "UIActionSheet+BlockSupport.h"

static DismissHandler dismissHandler;
static CancelHandler cancelHandler;

@implementation UIActionSheet (BlockSupport)

- (id)initWithTitle:(NSString *)title
  cancelButtonTitle:(NSString *)cancelButtonTitle
destructiveButtonTitle:(NSString *)destructiveButtonTitle
  otherButtonTitles:(NSArray *)otherButtonTitles
     dismissHandler:(DismissHandler)dismiss
      cancelHandler:(CancelHandler)cancel
{
    UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:title
                                                       delegate:(id)[self class]
                                              cancelButtonTitle:cancelButtonTitle
                                         destructiveButtonTitle:destructiveButtonTitle
                                              otherButtonTitles:nil, nil];
    dismissHandler = [dismiss copy];
    cancelHandler = [cancel copy];
    
    for(NSString *buttonTitle in otherButtonTitles){
        [sheet addButtonWithTitle:buttonTitle];
    }
    if (! cancelButtonTitle) {
        sheet.cancelButtonIndex = [otherButtonTitles count] - 1;
    }
    
    return sheet;
}


+(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == [actionSheet cancelButtonIndex])
	{
		cancelHandler();
	}
    else
    {
        dismissHandler(buttonIndex);
    }
}




@end
