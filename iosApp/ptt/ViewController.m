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

- (void) createPlayer:(NSString *)playerLayerPosition videoPath:(NSString *)videoPath;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"readyForDisplay"]){
        NSLog(@"observe:readyForDisplay: %@, %@, %@", object, change, context);
        AVPlayerLayer *playerLayer = (AVPlayerLayer *)object;
        [playerLayer.player play];
    }
}

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
        NSMutableDictionary *tmpPlayers = [NSMutableDictionary dictionaryWithCapacity:3];
        NSMutableDictionary *tmpPlayerLayers = [NSMutableDictionary dictionaryWithCapacity:3];
        for(int i = 0; i < 3; i++){
            NSLog(@"key: %@", keys[i]);
            //AVPlayer
            AVPlayer *player = [[AVPlayer alloc] init];
            [tmpPlayers setObject:player forKey:keys[i]];
            
            //AVPlayerLayer
            AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
            CGRect r = [[UIScreen mainScreen] bounds];
            CGFloat w = r.size.width;
            //CGFloat h = r.size.height;
            CGFloat scale = 1/(320/w);
            
            int topmargin = 0;
            int backHeight = 122;
            int centerHeight = 163;
            int frontHeight = 175;
            
            if([((NSString *)keys[i]) isEqualToString:@"back"]){
                playerLayer.frame = CGRectMake(0, topmargin * scale, w, backHeight * scale);
            }else if([((NSString *)keys[i]) isEqualToString:@"center"]){
                playerLayer.frame = CGRectMake(0, (topmargin + backHeight) * scale, w, centerHeight);
            }else if([((NSString *)keys[i]) isEqualToString:@"front"]){
                playerLayer.frame = CGRectMake(0, (topmargin + backHeight + centerHeight) * scale, w, frontHeight);
            }
            playerLayer.videoGravity = @"AVLayerVideoGravityResizeAspectFill";
            playerLayer.masksToBounds = YES;
            playerLayer.transform = CATransform3DMakeScale(1, -1, 1);
            [self.view.layer addSublayer:playerLayer];
            
            [playerLayer addObserver:self forKeyPath:@"readyForDisplay" options:NSKeyValueObservingOptionNew context:NULL];

            [tmpPlayerLayers setObject:playerLayer forKey:keys[i]];
        
        }
        players = [NSDictionary dictionaryWithDictionary:tmpPlayers];
        playerLayers = [NSDictionary dictionaryWithDictionary:tmpPlayerLayers];
        //NSLog(@"playerLayers %@", playerLayers);
        
        //NSString *videoPath = [[NSBundle mainBundle] pathForResource:@"m02" ofType:@"mp4"];
        [self createPlayer:@"back" videoPath:@"http://utageworks.jpn.ph/test/palm/movie/m03.mp4"];
        [self createPlayer:@"center" videoPath:@"http://utageworks.jpn.ph/test/palm/movie/m02.mp4"];
        [self createPlayer:@"front" videoPath:@"http://utageworks.jpn.ph/test/palm/movie/m01.mp4"];
    }
    return self;
}

- (void) createPlayer:(NSString *)playerLayerPosition videoPath:(NSString *)videoPath
{
    NSLog(@"videoPath: %@", videoPath);
    NSError *error = nil;
    NSRegularExpression *regexp = [NSRegularExpression regularExpressionWithPattern:@"^https?://" options:0 error:&error];
    NSTextCheckingResult *match = [regexp firstMatchInString:videoPath options:0 range:NSMakeRange(0, videoPath.length)];
    NSURL *url;
    if(match){
        url = [NSURL URLWithString:videoPath];
    }else{
        url = [NSURL fileURLWithPath:videoPath];
    }
    AVPlayer *player = [[AVPlayer alloc] initWithURL: url];
    AVPlayerLayer *playerLayer = (AVPlayerLayer *)[playerLayers objectForKey:playerLayerPosition];
    playerLayer.player = player;
}


@end
