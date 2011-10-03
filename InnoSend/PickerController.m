//
//  PickerController.m
//  InnoSend
//
//  Created by Dominik Kroutvar on 04.09.11.
//  Copyright 2011 Die Cubus Unit GmbH. All rights reserved.
//

#import "PickerController.h"
#import <AddressBook/ABGroup.h>
#import <AddressBook/ABGlobals.h>

@implementation PickerController
@synthesize nameDoubleAction, target, selectedPhoneNumber;

-(void)awakeFromNib
{
    [ppView setTarget:self];
    [ppView setNameDoubleAction:@selector(selectInAB:)];
}

- (IBAction)selectInAB:(id)sender {
//    [appC setAddressFieldNumber:[[ppView selectedValues] objectAtIndex:0]];
    [appController hideABPickerSheet:nil];
    [appController setAddressFieldNumber:[[ppView selectedValues] objectAtIndex:0]];
//    [appC setAddressFieldNumber:@"01757254508"];
//    NSString *phoneNumber = [[ppView selectedValues] objectAtIndex:0];
//    [appC setValue:phoneNumber forKey:@"abPhone"];
//    [setValue:[[ppView selectedValues] objectAtIndex:0] forKey:phoneNumber];
//    [appC setAddressFieldNumber:@"0711840045"];
//    [mainWindow setAddressFieldNumber:[[ppView selectedValues] objectAtIndex:0]];
//    [mainWindow hideABPickerSheet:nil];
//    [addressField setValue:[[ppView selectedValues] objectAtIndex:0]];
}

@end
