//
//  AppController.m
//  InnoSend
//
//  Created by Dominik Kroutvar on 22.08.11.
//  Copyright 2011 Die Cubus Unit GmbH. All rights reserved.
//

#import "AppController.h"
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
    
    NSLog(@"registered dafaults: %@", defaultValues);
    
    return self;
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
    
    NSLog(@"Sending message = %@", postData);
    
    NSString *urlString = [NSString stringWithFormat:
                           @"http://www.innosend.de/gateway/sms.php?"
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
    //    [self setData:urlData encoding:[response textEncodingName]];
    if (error) {
        [alertSheet setMessageText:@"Request error"];
        [alertSheet setInformativeText:[NSString stringWithFormat:@"Could not send following message: %@", input]];
//        [alertSheet setIcon:<#(NSImage *)#>
        //        [alertSheet setInformativeText:[error localizedDescription]];
        [alertSheet beginSheetModalForWindow:[NSApp mainWindow] modalDelegate:self didEndSelector:nil contextInfo:nil];            
        return;
    }
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
    NSLog(@"URLData: %@", theString);
    accountLabel.stringValue = [NSString stringWithFormat:@"Credit account: %@", theString];
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
