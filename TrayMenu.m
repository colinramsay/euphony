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

static NSSoundPlayer *_player;
static NSMenuItem *_shuffleMenu;
TrayMenu *_self;

- (void) openWebsite:(id)sender {

	//int i; // Loop counter.
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
		
		// Loop through all the files and process them.
		for( int i = 0; i < [selectedItems count]; i++ )
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
		if (_player) {
			[_player setFiles:musicItems];
		} else {
			_player = [[NSSoundPlayer alloc] initWithFiles:musicItems];
		}
		
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

- (void) toggleShuffle {
	
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
								  action:@selector(toggleShuffle)
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
	_self = self;
}

- (void) registerHotKeys
{
	EventHotKeyRef gMyHotKeyRef;
	EventTypeSpec eventType;
	eventType.eventClass=kEventClassKeyboard;
	eventType.eventKind=kEventHotKeyPressed;
	
	InstallApplicationEventHandler( NewEventHandlerUPP(HotKeyEventHandlerProc),1, &eventType, 0, NULL );
	
	EventHotKeyID hk1 = { 'Arow', 1 }; // s
	EventHotKeyID hk31 = { 'Arow', 31 }; // o
	EventHotKeyID hk44 = { 'Arow', 44 }; // ?
	EventHotKeyID hk124 = { 'Arow', 124 }; // right arrow
	EventHotKeyID hk125 = { 'Arow', 125 }; // down arrow
	
	RegisterEventHotKey(1, cmdKey+optionKey+controlKey+shiftKey, hk1, GetApplicationEventTarget(), 0, &gMyHotKeyRef);
	RegisterEventHotKey(31, cmdKey+optionKey+controlKey+shiftKey, hk31, GetApplicationEventTarget(), 0, &gMyHotKeyRef);
	RegisterEventHotKey(44, cmdKey+optionKey+controlKey+shiftKey, hk44, GetApplicationEventTarget(), 0, &gMyHotKeyRef);
	RegisterEventHotKey(124, cmdKey+optionKey+controlKey+shiftKey, hk124, GetApplicationEventTarget(), 0, &gMyHotKeyRef);
	RegisterEventHotKey(125, cmdKey+optionKey+controlKey+shiftKey, hk125, GetApplicationEventTarget(), 0, &gMyHotKeyRef);	
}

OSStatus HotKeyEventHandlerProc( EventHandlerCallRef inCallRef, EventRef inEvent, void* inUserData )
{
	EventHotKeyID hotKeyID;
	GetEventParameter( inEvent, kEventParamDirectObject, typeEventHotKeyID, NULL, sizeof(EventHotKeyID), NULL, &hotKeyID );
	
	switch (hotKeyID.id) {
		case 1:
			[_self toggleShuffle];
			break;
		case 31:
			[_self openWebsite:_self];
			break;
		case 44:
			[_player displayInfo];
			break;
		case 124:
			[_player skip];
			break;
		case 125:
			[_player playOrPause];
			break;
	}	
}

@end