//
//  CoreDataController.h
//  InnoSend
//
//  Created by Dominik Koutvar on 07.10.11.
//  Copyright 2011 Die Cubus Unit GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
@class InnoSendAppDelegate;

@interface CoreDataController : NSObject
{
    IBOutlet InnoSendAppDelegate *appDelegate;
}
-(void)saveMessage:(NSString *)message
    receiverNumber:(NSString *)number;

@end
