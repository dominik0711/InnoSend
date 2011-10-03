//
//  Outbox.h
//  InnoSend
//
//  Created by Dominik Koutvar on 15.09.11.
//  Copyright (c) 2011 Die Cubus Unit GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Outbox : NSManagedObject {
@private
}
@property (nonatomic, retain) NSDate * sendDate;
@property (nonatomic, retain) NSNumber * receiverNumber;
@property (nonatomic, retain) NSString * message;

@end
