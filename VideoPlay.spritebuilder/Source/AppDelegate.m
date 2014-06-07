/*
 * SpriteBuilder: http://www.spritebuilder.org
 *
 * Copyright (c) 2012 Zynga Inc.
 * Copyright (c) 2013 Apportable Inc.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "cocos2d.h"
#import <CoreMedia/CoreMedia.h>
#import "AppDelegate.h"
#import "CCBuilderReader.h"
@implementation AppController

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Configure Cocos2d with the options set in SpriteBuilder
    NSString* configPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Published-iOS"]; // TODO: add support for Published-Android support
    configPath = [configPath stringByAppendingPathComponent:@"configCocos2d.plist"];
    
    NSMutableDictionary* cocos2dSetup = [NSMutableDictionary dictionaryWithContentsOfFile:configPath];
    
    // Note: this needs to happen before configureCCFileUtils is called, because we need apportable to correctly setup the screen scale factor.
#ifdef APPORTABLE
    if([cocos2dSetup[CCSetupScreenMode] isEqual:CCScreenModeFixed])
        [UIScreen mainScreen].currentMode = [UIScreenMode emulatedMode:UIScreenAspectFitEmulationMode];
    else
        [UIScreen mainScreen].currentMode = [UIScreenMode emulatedMode:UIScreenScaledAspectFitEmulationMode];
#endif
    
    // Configure CCFileUtils to work with SpriteBuilder
    [CCBReader configureCCFileUtils];
    CCFileUtils *fileutils=[CCFileUtils sharedFileUtils];
    fileutils.searchPath=
    [NSArray arrayWithObjects:sys_dir,
     [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"SourceRun"],
     [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Published-iOS"],
     [[NSBundle mainBundle] resourcePath],
     nil];
    
    
    NSLog(@"sys_dir:%@",sys_dir);
    [self copyResourceToDocuments:@"cats.mp4" NewFileName:@"meo.mp4"];// copy and rename file
    
    
    [self setupCocos2dWithOptions:cocos2dSetup];
    
    return YES;
}

-(void)copyResourceToDocuments:(NSString *)strfilename NewFileName:(NSString*)strnewfile{
    NSString *strTarget=[NSString stringWithFormat:@"%@/%@",sys_dir,strnewfile];
    NSString *strfileSource=[[[NSBundle mainBundle] bundlePath] stringByAppendingFormat:@"/%@",strfilename];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    BOOL exits = [fileManager fileExistsAtPath:strTarget];
    if (!exits){
        [fileManager copyItemAtPath:strfileSource toPath:strTarget error:nil];
    }
    
}
/**
 not play on the android device
 
 */
-(void)PlayVideo{
    NSString *strPath=[NSString stringWithFormat:@"%@/%@",sys_dir,@"meo.mp4"];// get path from documents
    
    //strPath=[[NSBundle mainBundle] pathForResource:@"cats" ofType:@"mp4"];
    
    NSURL *videoURL = [NSURL fileURLWithPath:strPath];
    self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:videoURL];
    self.moviePlayer.controlStyle = MPMovieControlStyleNone;
    self.moviePlayer.shouldAutoplay = YES;
    self.moviePlayer.fullscreen = YES;
    self.moviePlayer.view.userInteractionEnabled=NO;
    self.moviePlayer.repeatMode=MPMovieRepeatModeOne;
    [self.moviePlayer play];
    UIView* glView = [[CCDirector sharedDirector] view];
    
    self.moviePlayer.view.frame = CGRectMake(0, 50, 500, 300);
    
    [glView.superview addSubview:self.moviePlayer.view];
    
    /* view file size,path
     
    NSData *datafile=[NSData dataWithContentsOfURL:videoURL];
    UIAlertView *alertview=[[UIAlertView alloc] initWithTitle:@"URL" message:[NSString stringWithFormat:@"Filesize:%d\nPath:%@",datafile.length,videoURL.absoluteString] delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
    [alertview show];
    
    */
    
    glView.opaque = NO; // attention
    glClearColor(0.0f, 0.0f, 0.0f, 0.0f); // attention
    
}

- (CCScene*) startScene
{
    return [CCBReader loadAsScene:@"MainScene"];
}

@end
/*
 UIAlertView *alertview=[[UIAlertView alloc] initWithTitle:@"URL" message:videoURL.absoluteString delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil];
 [alertview show];
 */
