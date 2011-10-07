//
//  CoreDataController.m
//  InnoSend
//
//  Created by Dominik Koutvar on 07.10.11.
//  Copyright 2011 Die Cubus Unit GmbH. All rights reserved.
//

#import "CoreDataController.h"
#import "InnoSendAppDelegate.h"

@implementation CoreDataController

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

-(void)saveMessage:(NSString *)message
    receiverNumber:(NSString *)number
{
    appDelegate = [[NSApplication sharedApplication] 
                   delegate];

    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSManagedObject *newMessage;

    newMessage = [NSEntityDescription insertNewObjectForEntityForName:@"MessageBox"   
                                               inManagedObjectContext:context];

    [newMessage setValue:message forKey:@"message"];
    [newMessage setValue:number forKey:@"receiverNumber"];
    [newMessage setValue:[NSDate date] forKey:@"sendDate"];
    NSError *error;
    [context save:&error];
    [context release];
    [newMessage release];
}
@end
