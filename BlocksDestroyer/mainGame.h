//
//  Menu.h
//  BlocksDestroyer
//
//  Created by Teodoro Vargas Cortés on 08/04/13.
//  Copyright 2013 ITESM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "cocos2d.h"

#define kMinimumGestureLength 10
#define kMaximumVariance 5
#define ROWS 6
#define COLUMNS 5
#define NUM_SPRITES 10
#define WIDTH_SPRITE 60
#define OFFSET 35
#define DIST_CENTERS 65

@interface mainGame : CCLayer<GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate>
{
    CCLabelTTF *points_label;
    CCLabelTTF *timer_label;
    CCSprite *blocks_game[ROWS][COLUMNS];
    int indexGameBlocks[ROWS][COLUMNS];
    CGPoint gameCenters[ROWS][COLUMNS];
}
@property int pointsCounter;
@property int timerCounter;
@property CGPoint firstTouch;
@property BOOL inMovement;
@property BOOL touchInSpriteRect;
@property NSUInteger orientation;
@property CGRect initialRect;
@property NSInteger activeColumn;
@property NSInteger activeRow;


// Returns a CCScene that contains the mainGame 
+ (CCScene *)scene;

- (id)init;
- (CCSprite *)touchedSprite:(CGPoint)location;
- (void)registerWithTouchDispatcher;
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event;
- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event;
- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event;
- (int)nearColumn:(CGPoint)location forRow:(int)row;
- (int)nearRow:(CGPoint)location forColumn:(int)column;
- (void)debug;

@end