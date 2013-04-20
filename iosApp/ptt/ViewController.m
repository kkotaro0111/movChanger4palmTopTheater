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
    
    SRWebSocket *socket;
}

- (void) createPlayer:(NSString *)playerLayerPosition videoPath:(NSString *)videoPath;
- (void) loop:(NSNotification *)notification;

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
        //NSLog(@"observe:readyForDisplay: %@, %@, %@", object, change, context);
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
        NSArray *keys = [[NSArray alloc] initWithObjects:@"front", @"middle", @"back", nil];
        NSMutableDictionary *tmpPlayers = [NSMutableDictionary dictionaryWithCapacity:3];
        NSMutableDictionary *tmpPlayerLayers = [NSMutableDictionary dictionaryWithCapacity:3];
        for(int i = 0; i < 3; i++){
            //NSLog(@"key: %@", keys[i]);
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
            int middleHeight = 163;
            int frontHeight = 175;
            
            if([((NSString *)keys[i]) isEqualToString:@"back"]){
                playerLayer.frame = CGRectMake(0, topmargin * scale, w, backHeight * scale);
            }else if([((NSString *)keys[i]) isEqualToString:@"middle"]){
                playerLayer.frame = CGRectMake(0, (topmargin + backHeight) * scale, w, middleHeight);
            }else if([((NSString *)keys[i]) isEqualToString:@"front"]){
                playerLayer.frame = CGRectMake(0, (topmargin + backHeight + middleHeight) * scale, w, frontHeight);
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
        
        NSString *hostname = @"utageworks.jpn.ph";
        NSURL *wsurl = [NSURL URLWithString:[NSString stringWithFormat:@"ws://%@:9001", hostname]];
        socket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:wsurl]];
        socket.delegate = self;
        [socket open];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(loop:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:nil];
    }
    
    
    return self;
}

- (void) createPlayer:(NSString *)playerLayerPosition videoPath:(NSString *)videoPath
{
    //NSLog(@"videoPath: %@", videoPath);
    
    NSRange match = [videoPath rangeOfString:@"^https?://" options:NSRegularExpressionSearch];
    NSURL *url;
    if(match.location != NSNotFound){
        NSRange ytmatch = [videoPath rangeOfString:@"^https?://(www.)?youtube.com" options:NSRegularExpressionSearch];
        if(ytmatch.location != NSNotFound){
            LBYouTubeExtractor *ext = [[LBYouTubeExtractor alloc] initWithURL:[NSURL URLWithString:videoPath] quality:LBYouTubeVideoQualitySmall];
            ext.delegate = self;
            [ext startExtracting];
            return;
        }
        url = [NSURL URLWithString:videoPath];
    }else{
        url = [NSURL URLWithString: [NSString stringWithFormat:@"http://utageworks.jpn.ph/test/palm/movie/%@.mp4", videoPath]];
    }
    AVPlayer *player = [[AVPlayer alloc] initWithURL: url];
    
    player.actionAtItemEnd = AVPlayerActionAtItemEndNone;

    AVPlayerLayer *playerLayer = (AVPlayerLayer *)[playerLayers objectForKey:playerLayerPosition];
    playerLayer.player = player;
}

- (void)loop:(NSNotification *)notification
{
    //NSLog(@"loop: %@", notification);
    //NSLog(@"object: %@", [notification object]);
    AVPlayerItem *playerItem = (AVPlayerItem *)[notification object];
    //NSLog(@"playerItem: %@", playerItem);
    [playerItem seekToTime:kCMTimeZero];
}


- (void)webSocketDidOpen:(SRWebSocket *)webSocket
{
    [webSocket send:@"msg:Connected"];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
    NSLog(@"WebSocketMessage: %@", [message description]);
    
    //NSArray *wsmsg = [[message description] componentsSeparatedByString:@":"];
    NSError *err = nil;
    NSRegularExpression *regexp = nil;
    
    regexp = [NSRegularExpression regularExpressionWithPattern:@"([^:]*):(.*)"
                                                       options:NSRegularExpressionCaseInsensitive
                                                         error:&err];
    NSTextCheckingResult *match = [regexp firstMatchInString:[message description]
                                                     options:0
                                                       range:NSMakeRange(0, [message description].length)];
    NSMutableArray *wsmsg = [NSMutableArray array];
    
    if(match){
        [wsmsg addObject:[[message description] substringWithRange:[match rangeAtIndex:1]]];
        [wsmsg addObject:[[message description] substringWithRange:[match rangeAtIndex:2]]];
    }
    
    NSLog(@"wsmsg: %@, count: %d", wsmsg, [wsmsg count]);
    if(wsmsg.count == 2){
        if(![@"msg" isEqualToString:[wsmsg objectAtIndex:0]]){
            //[self createPlayer:[wsmsg objectAtIndex:0] videoPath:[NSString stringWithFormat:@"http://utageworks.jpn.ph/test/palm/movie/%@.mp4", [wsmsg objectAtIndex:1]]];
            [self createPlayer:[wsmsg objectAtIndex:0] videoPath:[wsmsg objectAtIndex:1]];
        }
    }
}

-(void)youTubePlayerViewController:(LBYouTubePlayerController *)controller didSuccessfullyExtractYouTubeURL:(NSURL *)videoURL
{
    NSLog(@"didSuccessfullyExtractYouTubeURL:%@, %@", controller, videoURL);
}

-(void)youTubePlayerViewController:(LBYouTubePlayerController *)controller failedExtractingYouTubeURLWithError:(NSError *)error
{
    NSLog(@"failedExtractingYouTubeURLWithError:%@, %@", controller, error);
}

-(void)youTubeExtractor:(LBYouTubeExtractor *)extractor didSuccessfullyExtractYouTubeURL:(NSURL *)videoURL
{
    NSLog(@"didSuccessfullyExtractYouTubeURL:%@, %@", extractor, videoURL);
    AVPlayer *player = [[AVPlayer alloc] initWithURL: videoURL];
    
    player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    
    AVPlayerLayer *playerLayer = (AVPlayerLayer *)[playerLayers objectForKey:@"front"];
    playerLayer.player = player;
    
}
-(void)youTubeExtractor:(LBYouTubeExtractor *)extractor failedExtractingYouTubeURLWithError:(NSError *)error
{
    NSLog(@"failedExtractingYouTubeURLWithError:%@, %@", extractor, error);
    
}


@end
