//
//  NSSoundPlayer.m
//  audioplayer
//
//  Created by Colin on 28/02/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NSSoundPlayer.h"
#import <Growl/Growl.h>

@implementation NSSoundPlayer

NSMutableArray *_files;
NSSound *_sound;
BOOL *_paused;
BOOL *_shuffle = FALSE;
int *_trackNumber;
NSData *_growlIcon;

- (id)initWithFiles:(NSArray *)files {
	if (self = [super init]) {
		_files = [[NSMutableArray alloc] initWithArray:files];
	}
	
	NSBundle *myBundle = [NSBundle bundleForClass:[NSSoundPlayer class]]; 
	NSString *growlPath = [[myBundle privateFrameworksPath] stringByAppendingPathComponent:@"Growl.framework"]; 
	NSBundle *growlBundle = [NSBundle bundleWithPath:growlPath]; 
	NSString *myImagePath = [[[NSBundle mainBundle] resourcePath]  stringByAppendingPathComponent:@"vol_white.icns"];

	NSImage *img = [[NSImage alloc] initWithContentsOfFile:myImagePath];
	_growlIcon = [img TIFFRepresentation];
	[_growlIcon retain];
	
	if (growlBundle && [growlBundle load]) { 
		// Register ourselves as a Growl delegate 
		[GrowlApplicationBridge setGrowlDelegate:self]; 
	} 
	else { 
		NSLog(@"Could not load Growl.framework"); 
	}
	
	return self;
}

- (void)play {
	
	if([_files count] > 0) {
		
		_trackNumber = 0;
		if (_shuffle)
		{
			srandom(time(NULL));
			_trackNumber = random() % [_files count];
		}
		
		NSString *next = [_files objectAtIndex:_trackNumber];
		NSLog(next);
		
		[GrowlApplicationBridge notifyWithTitle:@"audioplayer"
									description:[[NSString alloc]initWithFormat: @"%@", [next lastPathComponent]]
							   notificationName:@"Current Song"
									   iconData:_growlIcon
									   priority:0
									   isSticky:NO
								   clickContext:[NSDate date]];
		
		[_files removeObjectAtIndex:_trackNumber];	
		_sound = [[NSSound alloc] initWithContentsOfFile:next byReference:NO];
		[_sound setDelegate:self];
		[_sound play];
	}
}

- (BOOL)toggleShuffle {
	if(_shuffle) {
		_shuffle = FALSE;
	} else{
		_shuffle = TRUE;
	}	
	return _shuffle;
}

- (void)stop {
	[_sound stop];	
}

- (void)skip {
	[_sound stop];
	//[self play];
}

- (void)sound:(NSSound *)sound didFinishPlaying:(BOOL)finishedPlaying {
	[self play];
}

- (void)playOrPause {
	if(_paused) {
		[_sound resume];
		_paused = FALSE;
	} else{
		[_sound pause];
		_paused = TRUE;
	}
}

@end
