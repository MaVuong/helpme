//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"
#import "AppDelegate.h"
#import <sqlite3.h>
#import "OALSimpleAudio.h"
@implementation MainScene{
    CCButton *_btaction;
}


-(void)didLoadFromCCB{
    self.userInteractionEnabled=YES;
    _btaction.title=@"Play Video ..";
}
-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    NSLog(@"sdasdasda");
}

-(void)actionPlayVideo{
    AppController *appcontroller=(AppController *)[[UIApplication sharedApplication] delegate];
    [appcontroller  PlayVideo];
}

-(void)actionSelectEffect{
    
}

-(void)SelectDatabase{
   
}

@end


