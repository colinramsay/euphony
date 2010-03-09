//
//  TrayMenu.m
//  audioplayer
//
//  Created by Colin on 23/02/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TrayMenu.h"
#import "NSSoundPlayer.h"

@implementation TrayMenu

NSSoundPlayer *_player;
NSMenuItem *_shuffleMenu;

- (void) openWebsite:(id)sender {

	int i; // Loop counter.
	int j;
	// Create the File Open Dialog class.
	NSOpenPanel* openDlg = [NSOpenPanel openPanel];
	
	// Enable the selection of directories in the dialog.
	[openDlg setCanChooseDirectories:YES];
	
	// Display the dialog.  If the OK button was pressed,
	// process the files.
	if ( [openDlg runModalForDirectory:@"~/Music" file:nil] == NSOKButton )
	{
		// make sure we not already playing . . . 
		[_player playOrPause];
		
		// Get an array containing the full filenames of all
		// files and directories selected.
		NSArray* selectedItems = [openDlg filenames];
		NSMutableArray *musicItems = [[NSMutableArray alloc] init];
		NSString *file;
		NSFileManager *localFileManager=[[NSFileManager alloc] init];
		NSString* dir;
		
		// Loop through all the files and process them.
		for( i = 0; i < [selectedItems count]; i++ )
		{
			NSString* currentDir = [selectedItems objectAtIndex:i];
			NSLog(currentDir);
			
			NSDirectoryEnumerator *dirEnum = [localFileManager enumeratorAtPath:currentDir];			
			while (file = [dirEnum nextObject]) {
				if ([[file pathExtension] isEqualToString: @"mp3"]) {
					// process the document
					NSLog(file);
					[musicItems addObject:[[NSString alloc]initWithFormat: @"%@/%@", currentDir, file]];
				}
			}
			break;
		}
		
		// mix it up a little
//		if ([musicItems count] > 1) {
//			for (NSUInteger shuffleIndex = [musicItems count] - 1; shuffleIndex > 0; shuffleIndex--) {
//				srandom(time(NULL));
//				[musicItems exchangeObjectAtIndex:shuffleIndex withObjectAtIndex:random() % (shuffleIndex + 1)];
//			}
//		}
		_player = [[NSSoundPlayer alloc] initWithFiles:musicItems];
		[_player play];		
	}
}

- (void) pausePlaying:(id)sender {
	[_player playOrPause];
}

- (void) stopPlaying:(id)sender {
	[_player stop];
}

- (void) skipPlaying:(id)sender {
	[_player skip];
}

- (void) toggleShuffle:(id)sender {
	
	if ([_player toggleShuffle]) {
			[_shuffleMenu setState:1];
	}
	else {		
			[_shuffleMenu setState:0];
	}

}

- (void) actionQuit:(id)sender {
	[NSApp terminate:sender];
}

- (NSMenu *) createMenu {
	NSZone *menuZone = [NSMenu menuZone];
	NSMenu *menu = [[NSMenu allocWithZone:menuZone] init];
	NSMenuItem *menuItem;
	
	menuItem = [menu addItemWithTitle:@"Pause/Play"
							   action:@selector(pausePlaying:)
						keyEquivalent:@""];
	[menuItem setTarget:self];
	
	// Add To Items
	menuItem = [menu addItemWithTitle:@"Open Folder"
							   action:@selector(openWebsite:)
						keyEquivalent:@""];
	[menuItem setToolTip:@"Open Tracks"];
	[menuItem setTarget:self];
	
	menuItem = [menu addItemWithTitle:@"Skip"
							   action:@selector(skipPlaying:)
						keyEquivalent:@""];
	[menuItem setToolTip:@"Skip Track"];
	[menuItem setTarget:self];
	
	_shuffleMenu =[menu addItemWithTitle:@"Shuffle"
							  action:@selector(toggleShuffle:)
					   keyEquivalent:@""];
	[_shuffleMenu setToolTip:@"Shuffle Play"];
	[_shuffleMenu setTarget:self];
	
	// Add Separator
	[menu addItem:[NSMenuItem separatorItem]];
	
	// Add Quit Action
	menuItem = [menu addItemWithTitle:@"Quit"
							   action:@selector(actionQuit:)
						keyEquivalent:@""];
	[menuItem setToolTip:@"Click to Quit this App"];
	[menuItem setTarget:self];
	
	return menu;
}

- (void) applicationDidFinishLaunching:(NSNotification *)notification {
	NSMenu *menu = [self createMenu];
	
	_statusItem = [[[NSStatusBar systemStatusBar]
					statusItemWithLength:NSSquareStatusItemLength] retain];
	[_statusItem setMenu:menu];
	[_statusItem setHighlightMode:YES];
	[_statusItem setToolTip:@"osxplayer"];
	[_statusItem setImage:[NSImage imageNamed:@"volume.png"]];
	
	[menu release];
	[self registerHotKeys];
	[self openWebsite:self];
}

- (void) registerHotKeys
{
	EventHotKeyRef gMyHotKeyRef;
	EventHotKeyID gMyHotKeyID;
	EventTypeSpec eventType;
	eventType.eventClass=kEventClassKeyboard;
	eventType.eventKind=kEventHotKeyPressed;
	
	InstallApplicationEventHandler( NewEventHandlerUPP(HotKeyEventHandlerProc),1, &eventType, 0, NULL );
    
	EventHotKeyID rightArrowID = { 'Arow', 1 };
	EventHotKeyID downArrowID = { 'Arow', 4 };
	
	gMyHotKeyID.signature='htk1';
	gMyHotKeyID.id=1;
	RegisterEventHotKey(124, cmdKey+optionKey+controlKey+shiftKey, rightArrowID, GetApplicationEventTarget(), 0, &gMyHotKeyRef);
	
	gMyHotKeyID.signature='htk2';
	gMyHotKeyID.id=2;
	RegisterEventHotKey(125, cmdKey+optionKey+controlKey+shiftKey, downArrowID, GetApplicationEventTarget(), 0, &gMyHotKeyRef);
}

OSStatus HotKeyEventHandlerProc( EventHandlerCallRef inCallRef, EventRef inEvent, void* inUserData )
{
	EventHotKeyID hotKeyID;
	GetEventParameter( inEvent, kEventParamDirectObject, typeEventHotKeyID, NULL, sizeof(EventHotKeyID), NULL, &hotKeyID );


	
	switch (hotKeyID.id) {
		case 1:
			[_player skip];
			break;
		case 4:
			[_player playOrPause];
			break;
	}	
}

OSStatus OnHotKeyEvent(EventHandlerCallRef nextHandler, EventRef theEvent, void* userData)
{
	EventHotKeyID hkCom;
	
	int l = hkCom.id;
	
	switch (l) {
		case 1:
			//[self pausePlaying:self];
			break;
		case 2:
			//[self pausePlaying:self];
			break;
	}
}

@end