//
//  PickerController.h
//  InnoSend
//
//  Created by Dominik Kroutvar on 04.09.11.
//  Copyright 2011 Die Cubus Unit GmbH. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AddressBook/ABPeoplePickerView.h>

@interface PickerController : NSObject
{
    IBOutlet ABPeoplePickerView *ppView;
}
@property (nonatomic, assign) SEL nameDoubleAction;
@property (nonatomic, assign) id target;

- (IBAction)getGroups:(id)sender;
- (IBAction)getRecords:(id)sender;
- (IBAction)viewProperty:(NSButton *)sender;
- (IBAction)setGroupSelection:(NSButton *)sender;
- (IBAction)setMultiRecordSelection:(NSButton *)sender;

- (IBAction)editInAB:(id)sender;
- (IBAction)selectInAB:(id)sender;

@end
