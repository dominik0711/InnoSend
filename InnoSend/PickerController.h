//
//  PickerController.h
//  InnoSend
//
//  Created by Dominik Kroutvar on 04.09.11.
//  Copyright 2011 Die Cubus Unit GmbH. All rights reserved.
//

#import "AppController.h"
#import <Cocoa/Cocoa.h>
#import <AddressBook/ABPeoplePickerView.h>

@interface PickerController : NSObject
{
    IBOutlet ABPeoplePickerView *ppView;
    NSString *selectedPhoneNumber;
    AppController *appController;
}
@property (nonatomic, assign) SEL nameDoubleAction;
@property (nonatomic, assign) id target;
@property (nonatomic, assign) NSString *selectedPhoneNumber;

- (IBAction)selectInAB:(id)sender;
@end
