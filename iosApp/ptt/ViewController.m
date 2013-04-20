//
//  ViewController.m
//  ptt
//
//  Created by 川嶋 光太郎 on 2013/04/19.
//  Copyright (c) 2013年 川嶋 光太郎. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
    NSDictionary *players;
    NSDictionary *playerLayers;
    //AVPlayer *frontPlayer, *centerPlayer, *backPlayer;
    //AVPlayerLayer *frontPlayerLayer, *centerPlayerLayer, *backPlayerLayer;
}


@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //front
    //playerLayer.frame = self.view.frame;
    /*
    frontPlayerLayer.frame = CGRectMake(0, 0, 320, 142/2);
    frontPlayerLayer.videoGravity = @"AVLayerVideoGravityResizeAspectFill";
    frontPlayerLayer.transform = CATransform3DMakeScale(1, -1, 1);
    [self.view.layer addSublayer:frontPlayerLayer];
    [playerLayer addObserver:self forKeyPath:@"readyForDisplay" options:NSKeyValueObservingOptionNew context:NULL];
     */
    
    
}
/*
- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"readyForDisplay"]){
        [playerLayer removeObserver:self forKeyPath:@"readyForDisplay"];
        [player play];
    }
}
*/
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        NSArray *keys = [[NSArray alloc] initWithObjects:@"front", @"center", @"back", nil];
        NSMutableDictionary *tmpPlayerLayers = [NSMutableDictionary dictionaryWithCapacity:3];
        for(int i = 0; i < 3; i++){
            NSString *key = keys[i];
            AVPlayer *player = [[AVPlayer alloc] init];
            [tmpPlayerLayers setObject:player forKey:key];            
        }
        playerLayers = [NSDictionary dictionaryWithDictionary:tmpPlayerLayers];
        
        //NSString *videoPath = [[NSBundle mainBundle] pathForResource:@"m02" ofType:@"mp4"];
        //NSLog(@"videoPath: %@", videoPath);
        //player = [[AVPlayer alloc] initWithURL:[NSURL fileURLWithPath:videoPath]];
        //player = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:@"http://utageworks.jpn.ph/test/palm/movie/m02.mp4"]];
    }
    return self;
}
/*
- (void) createPlayer:(AVPlayer *)player videoPath:(NSString *)videoPath
{
    player = [[AVPlayer alloc] initWithURL: [NSURL fileURLWithPath:videoPath]];
    PlayerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    
}
*/

@end
