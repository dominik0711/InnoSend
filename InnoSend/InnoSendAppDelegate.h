//
//  InnoSendAppDelegate.h
//  InnoSend
//
//  Created by Dominik Kroutvar on 22.08.11.
//  Copyright 2011 flexis AG. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface InnoSendAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;

@end
