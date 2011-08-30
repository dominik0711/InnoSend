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
    // Sheet to display errors on parse, connect, or XQuery
    NSAlert *alertSheet;

}
-(IBAction)sendMessage:(id)sender;
-(IBAction)closeApplication:(id)sender;
-(IBAction)fetchAccount:(id)sender;
-(IBAction)showPreferenceSheet:(id)sender;
-(IBAction)hidePreferenceSheet:(id)sender;
-(NSString *)userName;
-(NSString *)password;

@end
