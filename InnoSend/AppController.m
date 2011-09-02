//
//  AppController.m
//  InnoSend
//
//  Created by Dominik Kroutvar on 22.08.11.
//  Copyright 2011 Die Cubus Unit GmbH. All rights reserved.
//

#import "AppController.h"
#import <AppKit/NSImage.h>
NSString *const UserNameKey = @"Username";
NSString *const PasswordKey = @"Password";

@implementation AppController

- (id)init
{
    if (![super init]) {
        return nil;
    }
    // Create an alert sheet used to show connection and parse errors
    alertSheet = [[NSAlert alloc] init];
    [alertSheet addButtonWithTitle:@"OK"];
    [alertSheet setAlertStyle:NSWarningAlertStyle];

    //Create a dictionary
    NSMutableDictionary *defaultValues = [NSMutableDictionary dictionary];
    
    //Archive the user object
    NSData *userAsData = [NSKeyedArchiver archivedDataWithRootObject:@"userId"];
    //Archive the password object
    NSData *passwordAsData = [NSKeyedArchiver archivedDataWithRootObject:@"password"];
    
    //Put defaults in the dictionary
    [defaultValues setObject:userAsData forKey:UserNameKey];
    [defaultValues setObject:passwordAsData forKey:PasswordKey];
    
    //Register the dictionary of defaults
    [[NSUserDefaults standardUserDefaults]
     registerDefaults:defaultValues];
    
    return self;
}

-(void)awakeFromNib
{
    //set account account
    [self setAccountCredit];
}

-(void)windowDidLoad
{
    [userField setStringValue:[self userName]];
    [pwField setStringValue:[self password]];
}

-(IBAction)sendMessage:(id)sender
{
    NSString *type = @"2";
    NSString *user = [userField stringValue];
    NSString *pw = [pwField stringValue];
    NSString *address = [addressField stringValue];
    NSString *phoneNumber = [address stringByReplacingOccurrencesOfString:@"+" withString:@"00"];
    NSString *input = [messageField stringValue];
    NSString *postData = [input stringByAddingPercentEscapesUsingEncoding:NSISOLatin1StringEncoding];
    NSUInteger messageLength = [[messageField stringValue] length];
    if (messageLength > 140) {
        type = @"4";
    }
    
    NSString *urlString = [NSString stringWithFormat:
                           @"https://www.innosend.de/gateway/sms.php?"
                           @"id=%@"
                           @"&pw=%@"
                           @"&text=%@"
                           @"&type=%@"
                           @"&empfaenger=%@",
                           user, pw, postData, type, phoneNumber];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
    NSURLResponse *response;
    NSError *error;
    NSData *urlData;
    urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    NSString *retCodeStr = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding]; 
    int retCode = [retCodeStr intValue];
    NSString *infoTxt;
    NSString *image;
    switch (retCode) {
        case 100:
            infoTxt = @"Successfully send message.";
            image = NSImageNameInfo;
            break;
        case 111:
            infoTxt = @"IP lock active.";
            image = NSImageNameCaution;
            break;
        case 112:
            infoTxt = @"Wrong user data. Please check your settings in the Preference panel.";
            image = NSImageNameCaution;
            break;
        case 120:
            infoTxt = @"Sender data missing.";
            image = NSImageNameCaution;
            break;
        case 121:
            infoTxt = @"Message type is missing.";
            image = NSImageNameCaution;
            break;
        case 122:
            infoTxt = @"Message text is missing.";
            image = NSImageNameCaution;
            break;
        case 123:
            infoTxt = @"Receiver number is missing.";
            image = NSImageNameCaution;
            break;
        case 129:
            infoTxt = @"Wrong sender text. Please do not use special characters or spaces.";
            image = NSImageNameCaution;
            break;
        case 130:
            infoTxt = @"Phone number locked or advertisement detected.";
            image = NSImageNameCaution;
            break;
        case 140:
            infoTxt = @"Credit balance too low. Please top up your account.";
            image = NSImageNameCaution;
            break;
        case 150:
            infoTxt = @"Message spammer protection. Please contact the support of innosend.de.";
            image = NSImageNameCaution;
            break;
        case 170:
            infoTxt = @"Wrong delivery date. Please correct the date.";
            image = NSImageNameCaution;
            break;
        case 171:
            infoTxt = @"Delivery date is in the past. Please correct the date.";
            image = NSImageNameCaution;
            break;
        case 172:
            infoTxt = @"Too many phone numbers added. Please delete some phone numbers.";
            image = NSImageNameCaution;
            break;
        case 173:
            infoTxt = @"Phone number format wrong. Please check the format of the phone number.";
            image = NSImageNameCaution;
            break;
            
        default:
            break;
    }
    [alertSheet setMessageText:@"Message status"];
    [alertSheet setInformativeText:[NSString stringWithFormat:@"%@", infoTxt]];
    [alertSheet setIcon:[NSImage imageNamed:image]];
    [alertSheet beginSheetModalForWindow:[NSApp mainWindow] modalDelegate:self didEndSelector:nil contextInfo:nil];            
    return;
}

// This controller is the delegate of the text field, and this gets called when the text changes.
-(void)controlTextDidChange:(NSNotification *)note
{
    NSUInteger phoneCount = [[addressField stringValue] length];
    NSUInteger count = [[messageField stringValue] length];
    if (phoneCount == 0) {
        [sendButton setEnabled:NO];
    } else if (phoneCount == 0 || count == 0) {
        [sendButton setEnabled:NO];
    } else if (count <= 140) {
        [sendButton setTitle:@"Free SMS"];
        [sendButton setEnabled:YES];
    } else {
        [sendButton setTitle:@"Paid SMS"];
    }
	textCounter.stringValue = [NSString stringWithFormat:@"%lu/140", count];
    
}

-(IBAction)closeApplication:(id)sender
{
    [NSApp terminate:self];
}

-(IBAction)fetchAccount:(id)sender
{
    [self setAccountCredit];
}

-(IBAction)showPreferenceSheet:(id)sender
{
    [NSApp beginSheet:preferenceSheet
       modalForWindow:[addressField window]
        modalDelegate:nil 
       didEndSelector:nil 
          contextInfo:nil];
}

-(IBAction)hidePreferenceSheet:(id)sender
{
    [NSApp endSheet:preferenceSheet];
    [preferenceSheet orderOut:sender];
}

-(void)setAccountCredit
{
    NSString *accountCredit = [self accountCredit];
    accountLabel.stringValue = [NSString stringWithFormat:@"Credit: %@", accountCredit];

}

-(NSString *)accountCredit
{
    NSString *user = [userField stringValue];
    NSString *pw = [pwField stringValue];
    NSString *urlString = [NSString stringWithFormat:
                           @"http://www.innosend.de/gateway/konto.php?"
                           @"id=%@"
                           @"&pw=%@",
                           user, pw];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
    NSURLResponse *response;
    NSError *error;
    NSData *urlData;
    urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    NSString *theString = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding]; 
    
    return [NSString stringWithFormat:@"%@", theString];
    
}

-(NSString *)userName
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *userAsData = [defaults objectForKey:UserNameKey];
    return [NSKeyedUnarchiver unarchiveObjectWithData:userAsData];
}

-(NSString *)password
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *passwordAsData = [defaults objectForKey:PasswordKey];
    return [NSKeyedUnarchiver unarchiveObjectWithData:passwordAsData];
}

@end
