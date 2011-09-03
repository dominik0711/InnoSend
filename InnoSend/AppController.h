//
//  AppController.h
//  InnoSend
//
//  Created by Dominik Kroutvar on 22.08.11.
//  Copyright 2011 Die Cubus Unit GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
extern NSString *const UserNameKey;
extern NSString *const PasswordKey;
extern NSString *const SenderKey;

@interface AppController : NSObject
{
    IBOutlet NSWindow *mainWindow;

    IBOutlet NSTextField *addressField;
    IBOutlet NSTextField *messageField;
    IBOutlet NSTextField *textCounter;
    IBOutlet NSTextField *accountLabel;
    IBOutlet NSButton *sendButton;
    //Preference sheet
    IBOutlet NSWindow *preferenceSheet;
    IBOutlet NSTextField *userField;
    IBOutlet NSTextField *pwField;
    IBOutlet NSTextField *senderField;
	IBOutlet NSProgressIndicator *progressIndicator;
    // Sheet to display errors on parse, connect, or XQuery
    NSAlert *alertSheet;

}
@property (nonatomic, retain) NSProgressIndicator *progressIndicator;

-(IBAction)sendMessage:(id)sender;
-(IBAction)closeApplication:(id)sender;
-(IBAction)showPreferenceSheet:(id)sender;
-(IBAction)hidePreferenceSheet:(id)sender;
-(void)setAccountCredit;
-(NSString *)accountCredit;
-(NSString *)userName;
-(NSString *)password;
-(NSString *)sender;

@end
