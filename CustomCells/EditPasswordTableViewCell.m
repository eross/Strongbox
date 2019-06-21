//
//  EditPasswordTableViewCell.m
//  test-new-ui
//
//  Created by Mark on 22/04/2019.
//  Copyright © 2019 Mark McGuill. All rights reserved.
//

#import "EditPasswordTableViewCell.h"
#import "ItemDetailsViewController.h"
#import "MBAutoGrowingTextView.h"
#import "PasswordGenerator.h"
#import "FontManager.h"
#import "Settings.h"

@interface EditPasswordTableViewCell () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet MBAutoGrowingTextView *valueTextView;

@end

@implementation EditPasswordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.valueTextView.delegate = self;
    self.valueTextView.font = FontManager.sharedInstance.easyReadFont;
    self.valueTextView.adjustsFontForContentSizeCategory = YES;
}

- (IBAction)onGenerate:(id)sender {
    PasswordGenerationParameters *params = [[Settings sharedInstance] passwordGenerationParameters];
    [self setPassword:[PasswordGenerator generatePassword:params]];
}

- (IBAction)onSettings:(id)sender {
    if(self.onPasswordSettings) {
        self.onPasswordSettings();
    }
}

- (NSString *)password {
    return [NSString stringWithString:self.valueTextView.textStorage.string];
}

- (void)setPassword:(NSString *)password {
    self.valueTextView.text = password;

    if(self.onPasswordEdited) {
        self.onPasswordEdited(self.password);
    }

    [self.valueTextView layoutSubviews];
    [[NSNotificationCenter defaultCenter] postNotificationName:CellHeightsChangedNotification object:self];
}

- (void)textViewDidChange:(UITextView *)textView {
    if(self.onPasswordEdited) {
        self.onPasswordEdited(self.password);
    }
    
    [self.valueTextView layoutSubviews];
    [[NSNotificationCenter defaultCenter] postNotificationName:CellHeightsChangedNotification object:self];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    // Filter new lines and tabs
    
    NSMutableCharacterSet *set = [[NSCharacterSet newlineCharacterSet] mutableCopy];
    [set formUnionWithCharacterSet:[NSCharacterSet characterSetWithCharactersInString:@"\t"]];

    if( [text rangeOfCharacterFromSet:set].location == NSNotFound ) {
        return YES;
    }
    
    return NO;
}

@end