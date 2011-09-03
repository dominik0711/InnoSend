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
NSString *const SenderKey = @"Sender";

@implementation AppController

@synthesize progressIndicator;

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
    //Archive the sender object
    NSData *senderAsData = [NSKeyedArchiver archivedDataWithRootObject:@"sender"];
    
    //Put defaults in the dictionary
    [defaultValues setObject:userAsData forKey:UserNameKey];
    [defaultValues setObject:passwordAsData forKey:PasswordKey];
    [defaultValues setObject:senderAsData forKey:SenderKey];
    
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
    [senderField setStringValue:[self sender]];
}

-(IBAction)sendMessage:(id)sender
{
    NSString *type = @"2";
    NSString *user = [userField stringValue];
    NSString *pw = [pwField stringValue];
    NSString *senderNo = [senderField stringValue];
    NSString *address = [addressField stringValue];
    NSString *phoneNumber = [[address stringByReplacingOccurrencesOfString:@"+" withString:@"00"] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *input = [messageField stringValue];
    NSString *postData = [input stringByAddingPercentEscapesUsingEncoding:NSISOLatin1StringEncoding];
    NSUInteger messageLength = [[messageField stringValue] length];
    if (messageLength > 140) {
        type = @"4";
    }
    NSString *senderNumber = @"";
    if ([senderNo length] > 0) {
        senderNumber = [[senderNumber stringByAppendingString:@"&absender="] stringByAppendingString:senderNo];
    }
    
    NSString *urlString = [NSString stringWithFormat:
                           @"https://www.innosend.de/gateway/sms.php?"
                           @"id=%@"
                           @"&pw=%@"
                           @"&text=%@"
                           @"&type=%@"
                           @"&empfaenger=%@"
                           @"%@",
                           user, pw, postData, type, phoneNumber, senderNumber];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30];
    NSURLResponse *response;
    NSError *error;
    [self.progressIndicator startAnimation:self];
    NSData *urlData;
    urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    NSString *retCodeStr = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding]; 
    [self.progressIndicator stopAnimation:self];
    int retCode = [retCodeStr intValue];
    NSString *infoTxt;
    NSString *image;
    switch (retCode) {
        case 100:
            infoTxt = NSLocalizedString(@"Successfully send message.", @"successfully send") ;
            image = NSImageNameInfo;
            break;
        case 111:
            infoTxt = NSLocalizedString(@"IP lock active.", @"IP locked");
            image = NSImageNameCaution;
            break;
        case 112:
            infoTxt = NSLocalizedString(@"Wrong user data. Please check your settings in the Preference panel.", @"wrong user data");
            image = NSImageNameCaution;
            break;
        case 120:
            infoTxt = NSLocalizedString(@"Sender data missing.", @"missing sender");
            image = NSImageNameCaution;
            break;
        case 121:
            infoTxt = NSLocalizedString(@"Message type is missing.", @"message type missing");
            image = NSImageNameCaution;
            break;
        case 122:
            infoTxt = NSLocalizedString(@"Message text is missing.", @"message itself is missing");
            image = NSImageNameCaution;
            break;
        case 123:
            infoTxt = NSLocalizedString(@"Receiver number is missing.", @"receicer phone number is missing");
            image = NSImageNameCaution;
            break;
        case 129:
            infoTxt = NSLocalizedString(@"Wrong sender text. Please do not use special characters or spaces.", @"wrong sender text");
            image = NSImageNameCaution;
            break;
        case 130:
            infoTxt = NSLocalizedString(@"Phone number locked or advertisement detected.", @"phone number locked");
            image = NSImageNameCaution;
            break;
        case 140:
            infoTxt = NSLocalizedString(@"Credit balance too low. Please top up your account.", @"credit too low");
            image = NSImageNameCaution;
            break;
        case 150:
            infoTxt = NSLocalizedString(@"Message spammer protection. Please contact the support of innosend.de.", @"spammer info");
            image = NSImageNameCaution;
            break;
        case 170:
            infoTxt = NSLocalizedString(@"Wrong delivery date. Please correct the date.", @"wrong delivery date");
            image = NSImageNameCaution;
            break;
        case 171:
            infoTxt = NSLocalizedString(@"Delivery date is in the past. Please correct the date.", @"delivery date is set to past");
            image = NSImageNameCaution;
            break;
        case 172:
            infoTxt = NSLocalizedString(@"Too many phone numbers added. Please delete some phone numbers.", @"too many phone numbers");
            image = NSImageNameCaution;
            break;
        case 173:
            infoTxt = NSLocalizedString(@"Phone number format wrong. Please check the format of the phone number.", @"phone number format wrong");
            image = NSImageNameCaution;
            break;
            
        default:
            infoTxt = NSLocalizedString(@"Successfully send message.", @"successfully send") ;
            image = NSImageNameInfo;
            break;
    }
    [alertSheet setMessageText:NSLocalizedString(@"Message status", @"message status")];
    [alertSheet setInformativeText:[NSString stringWithFormat:@"%@", infoTxt]];
    [alertSheet setIcon:[NSImage imageNamed:image]];
    [alertSheet beginSheetModalForWindow:[NSApp mainWindow] modalDelegate:self didEndSelector:nil contextInfo:nil];
    
    //Refresh account
//    [self setAccountCredit];
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
        [sendButton setTitle:NSLocalizedString(@"Free SMS", @"free sms")];
        [sendButton setEnabled:YES];
    } else {
        [sendButton setTitle:NSLocalizedString(@"Paid SMS", @"paid sms")];
    }
	textCounter.stringValue = [NSString stringWithFormat:@"%lu/140", count];
    
}

-(IBAction)closeApplication:(id)sender
{
    [NSApp terminate:self];
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
    int retCode = [accountCredit intValue];
    if (retCode == 112) {
        accountCredit = @"";
    }
    accountLabel.stringValue = [NSString stringWithFormat:NSLocalizedString(@"Credit: %@", @"credit"), accountCredit];

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

-(NSString *)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *senderAsData = [defaults objectForKey:SenderKey];
    return [NSKeyedUnarchiver unarchiveObjectWithData:senderAsData];
}

@end
