//
//  ViewController.h
//  ptt
//
//  Created by 川嶋 光太郎 on 2013/04/19.
//  Copyright (c) 2013年 川嶋 光太郎. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreMedia/CoreMedia.h>
#import <SocketRocket/SRWebSocket.h>
#import <JSONKit/JSONKit.h>
#import "LBYouTube.h"

@interface ViewController : UIViewController <SRWebSocketDelegate, LBYouTubePlayerControllerDelegate,LBYouTubeExtractorDelegate>

@end
