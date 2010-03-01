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

- (void) openWebsite:(id)sender {

	int i; // Loop counter.
	int j;
	// Create the File Open Dialog class.
	NSOpenPanel* openDlg = [NSOpenPanel openPanel];
	
	// Enable the selection of directories in the dialog.
	[openDlg setCanChooseDirectories:YES];
	
	// Display the dialog.  If the OK button was pressed,
	// process the files.
	if ( [openDlg runModalForDirectory:nil file:nil] == NSOKButton )
	{
		// Get an array containing the full filenames of all
		// files and directories selected.
		NSArray* selectedItems = [openDlg filenames];
		
		// Loop through all the files and process them.
		for( i = 0; i < [selectedItems count]; i++ )
		{
			NSString* dir = [selectedItems objectAtIndex:i];
			
			NSLog(dir);
			
			NSArray *dirContents = [[NSFileManager defaultManager] directoryContentsAtPath:dir];
			
			_player = [[NSSoundPlayer alloc] initWithFiles:dir :dirContents];
			[_player play];
			
			break;
		}
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
	[menuItem setTarget:self];
	
	menuItem = [menu addItemWithTitle:@"Stop"
							   action:@selector(stopPlaying:)
						keyEquivalent:@""];
	[menuItem setTarget:self];
	
	menuItem = [menu addItemWithTitle:@"Skip"
							   action:@selector(skipPlaying:)
						keyEquivalent:@""];
	[menuItem setTarget:self];
	
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
	[_statusItem setToolTip:@"Test Tray"];
	[_statusItem setImage:[NSImage imageNamed:@"volume"]];
	
	[menu release];
}

@end