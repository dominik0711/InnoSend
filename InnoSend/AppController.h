//
//  AppController.h
//  InnoSend
//
//  Created by Dominik Kroutvar on 22.08.11.
//  Copyright 2011 Die Cubus Unit GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

extern NSString *const ServiceKey;
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
    IBOutlet NSTextField *priceLabel;
    IBOutlet NSButton *sendButton;
    //Preference sheet
    IBOutlet NSWindow *preferenceSheet;
    IBOutlet NSWindow *abPickerSheet;
    IBOutlet NSTextField *serviceField;
    IBOutlet NSTextField *userField;
    IBOutlet NSTextField *pwField;
    IBOutlet NSTextField *senderField;
    IBOutlet NSProgressIndicator *progressIndicator;
    IBOutlet NSButton *linkButton;
    IBOutlet NSComboBox *serviceCB;
}
@property (nonatomic, retain) NSProgressIndicator *progressIndicator;
//@property (retain) NSSound *sound;

#pragma mark -
#pragma mark Action Methods
-(IBAction)sendMessage:(id)sender;
-(IBAction)closeApplication:(id)sender;
-(IBAction)showPreferenceSheet:(id)sender;
-(IBAction)hidePreferenceSheet:(id)sender;
-(IBAction)showABPickerSheet:(id)sender;
-(IBAction)hideABPickerSheet:(id)sender;
-(IBAction)openAccountPage:(id)sender;
#pragma mark -
#pragma mark Setter Methods
-(void)setAccountCredit;
-(void)setMessagePrice;
#pragma mark -
#pragma mark Getter Methods
-(NSString *)accountCredit;
-(NSString *)messagePrice;
-(NSString *)userName;
-(NSString *)password;
-(NSString *)senderAddress;
-(NSString *)serviceSenderURL;
-(NSString *)serviceLoginURL;
-(NSString *)serviceAccountURL;

@end
