//
//  main.m
//  audioplayer
//
//  Created by Colin on 23/02/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TrayMenu.h"

int main(int argc, char *argv[])
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [NSApplication sharedApplication];
	
    TrayMenu *menu = [[TrayMenu alloc] init];
    [NSApp setDelegate:menu];
    [NSApp run];
	
    [pool release];
    return EXIT_SUCCESS;
}
