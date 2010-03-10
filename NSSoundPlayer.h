//
//  NSSoundPlayer.h
//  audioplayer
//
//  Created by Colin on 28/02/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSSoundPlayer : NSObject<NSSoundDelegate> {

}

-(id)initWithFiles:(NSArray *)files;
-(void)play;
-(void)stop;
-(void)skip;
-(void)playOrPause;
-(void)displayInfo;
-(BOOL)toggleShuffle;
-(void)displayMessage:(NSString *)notification :(NSString *)title :(NSString *)description;

@end
