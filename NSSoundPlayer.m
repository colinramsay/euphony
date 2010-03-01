//
//  NSSoundPlayer.m
//  audioplayer
//
//  Created by Colin on 28/02/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NSSoundPlayer.h"


@implementation NSSoundPlayer

NSMutableArray *_files;
NSSound *_sound;
NSString *_directory;
BOOL *_paused;

- (id)initWithFiles:(NSString *) directory :(NSArray *)files {
	if (self = [super init]) {
		_files = [[NSMutableArray alloc] initWithArray:files];
		_directory = directory;
		[_directory retain];
	}
	return self;
}

- (void)play {
	
	if([_files count] > 0) {
	
		NSString *next = [_files objectAtIndex:0];
		NSString *file = [[NSString alloc]initWithFormat: @"%@/%@", _directory, next];

		NSLog(file);
	
		[_files removeObjectAtIndex:0];
	
		_sound = [[NSSound alloc] initWithContentsOfFile:file byReference:NO];
		[_sound setDelegate:self];
		[_sound play];
	}
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
