//
//  TrayMenu.h
//  audioplayer
//
//  Created by Colin on 23/02/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Carbon/Carbon.h>


@interface TrayMenu : NSObject {
	@private 
		NSStatusItem *_statusItem;
}


static	OSStatus HotKeyEventHandlerProc( EventHandlerCallRef inCallRef, EventRef inEvent, void* inUserData );

-(void)toggleShuffle;
-(void)registerHotKeys;

@end
