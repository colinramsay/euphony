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

-(id)initWithFiles:(NSString *)directory :(NSArray *)files;
-(void)play;
-(void)stop;
-(void)skip;
-(void)playOrPause;
@end
