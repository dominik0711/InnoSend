//
//  AppController.h
//  InnoSend
//
//  Created by Dominik Kroutvar on 22.08.11.
//  Copyright 2011 Die Cubus Unit GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <Cocoa/Cocoa.h>
#import <AddressBook/ABPeoplePickerView.h>
#import "CoreDataController.h"

extern NSString *const ServiceKey;
extern NSString *const UserNameKey;
extern NSString *const PasswordKey;
extern NSString *const SenderKey;

@interface AppController : NSObject
{
    IBOutlet NSWindow *mainWindow;
    IBOutlet ABPeoplePickerView *ppView;
    IBOutlet CoreDataController *cdController;

    IBOutlet NSTextField *addressField;
    IBOutlet NSTextField *messageField;
    IBOutlet NSTextField *textCounter;
    IBOutlet NSTextField *accountLabel;
    IBOutlet NSTextField *priceLabel;
    IBOutlet NSButton *sendButton;
    NSString *abPhone;
    //MessageBox window
    IBOutlet NSWindow *messageBox;
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
    IBOutlet NSButton *newAccount;
    IBOutlet NSButton *changePassword;
}
@property (nonatomic, retain) NSProgressIndicator *progressIndicator;
@property (nonatomic, retain) NSString *abPhone;
@property (nonatomic, assign) SEL nameDoubleAction;
@property (nonatomic, assign) id target;

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
-(IBAction)newAccount:(id)sender;
-(IBAction)changePassword:(id)sender;
-(IBAction)showMessageBox:(id)sender;
#pragma mark -
#pragma mark Setter Methods
-(void)setAccountCredit;
-(void)setAddressFieldNumber:(NSString *)number;
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
-(NSString *)newAccountURL;
-(NSString *)changePasswordURL;
-(NSString *)normalizePhoneNumber:(NSString *)number;

@end
