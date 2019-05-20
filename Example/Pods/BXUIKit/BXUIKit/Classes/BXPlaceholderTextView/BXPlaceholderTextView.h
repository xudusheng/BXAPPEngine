//
//  BXPlaceholderTextView.h
//  BXUIKit
//
//  Created by Hmily on 2019/3/26.
//  Copyright © 2019 Document. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BXPlaceholderTextView : UITextView

@property (nonatomic, retain) UILabel *placeHolderLabel;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;

@end

