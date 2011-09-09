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
@synthesize nameDoubleAction, target;

- (IBAction)getGroups:(id)sender
{
    NSArray *groups = [ppView selectedGroups];
    NSLog(@"getGroups: %lu groups selected", [groups count]);
    int index;
    for(index=0; index<[groups count]; index++) {
        NSLog(@"  Group %i: %@", index, [(ABRecord *)[groups objectAtIndex:index] uniqueId]);
    }  
}

// get the records (people) currently selected in the view and iterate through
- (IBAction)getRecords:(id)sender
{
    NSArray *records = [ppView selectedRecords];
    NSLog(@"getRecords: %lu records selected", [records count]);
    int index;
    for(index=0; index<[records count]; index++) {
        NSLog(@"  Record %i: %@", index, [(ABRecord *)[records objectAtIndex:index] uniqueId]);
    }
}


// Activate specific values for display
- (IBAction)viewProperty:(NSButton *)sender {
    NSString *property;
    // See MainMenu.nib for the corresponding checkbox tags.
    switch ([sender tag]) {
        case 0: // Phone
            property = kABPhoneProperty;
            break;
        case 1: // Address
            property = kABAddressProperty;
            break;
        case 2: // Email
            property = kABEmailProperty;
            break;
        default:
            property = kABHomePageProperty;
            break;
    } 
    if ([sender state] == NSOnState) {
        [ppView addProperty:property];
    } else {
        [ppView removeProperty:property];
    }
}


// [dis]allows groupSelection in our peoplepicker.
- (IBAction)setGroupSelection:(NSButton *)sender {
    [ppView setAllowsGroupSelection:([sender state] == NSOnState)];
}

- (IBAction) setMultiRecordSelection:(NSButton *)sender {
    [ppView setAllowsMultipleSelection:([sender state] == NSOnState)];
}

- (IBAction)editInAB:(id)sender {
    [ppView editInAddressBook:sender];
}

- (IBAction)selectInAB:(id)sender {
    [ppView selectInAddressBook:sender];
    NSLog(@"selected Person = %@",NSStringFromSelector([ppView nameDoubleAction]));
}

@end
