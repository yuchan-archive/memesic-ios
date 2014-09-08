//
//  ViewController.m
//  Memesic
//
//  Created by Ohashi Yusuke on 9/7/14.
//  Copyright (c) 2014 Ohashi Yusuke. All rights reserved.
//

#import "ViewController.h"
#import "GDSoundEngine.h"

#include <stdlib.h>

#import <FMDB.h>

@interface ViewController ()
{
    NSTimer *timer;
    NSMutableArray *sounds, *soundSequeces;
    NSInteger simulSounds, limitSounds;
}
@property (nonatomic, strong) GDSoundEngine *soundEngine;
@end

@implementation ViewController
@synthesize soundEngine = _soundEngine;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _soundEngine = [[GDSoundEngine alloc] init];
    sounds = [[NSMutableArray alloc] init];
    soundSequeces = [[NSMutableArray alloc] init];
    simulSounds = 4;
    limitSounds = 16;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)toglePlay:(id)sender {
    if ([timer isValid]){
        [self stop];
        [timer invalidate];
    }else {
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(playWithInterval:) userInfo:self repeats:YES];
        [timer fire];
    }
}

- (void)stop {
    for (NSNumber *note in sounds) {
        [_soundEngine playNoteOff:[note intValue]];
    }
    [sounds removeAllObjects];
    [soundSequeces removeAllObjects];
}

- (void)stopCurrent {
    [_soundEngine playNoteOff:[[sounds objectAtIndex:0] intValue]];
    [sounds removeObjectAtIndex:0];
}

- (void)playSound {
    int r = arc4random_uniform(37);
    int note = 50 + r;
    r = arc4random_uniform(30);
    int vel = 50 + r;

    [_soundEngine playNoteOn:note :vel];
    [sounds addObject:[NSNumber numberWithInt:note]];
    [soundSequeces addObject:[NSNumber numberWithInt:note]];
}

- (void) playWithInterval:(NSTimer *)tm {
    if ([sounds count] == simulSounds) {
        [self stopCurrent];
    }
    
    if ([soundSequeces count] == limitSounds) {
        [self stop];
        [tm invalidate];
        
        return;
    }
    
    [self playSound];
}

@end
