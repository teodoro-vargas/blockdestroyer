//
//  Menu.m
//  BlocksDestroyer
//
//  Created by Teodoro Vargas Cortés on 08/04/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

// Import the interfaces
#import "mainGame.h"
#import "PauseGame.h"
#import "EndGame.h"
#import "CCTouchDelegateProtocol.h"
#import "CCTouchDispatcher.h"
#include <stdlib.h>

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

CCSprite *touchedBlock;

#pragma mark - mainGame


@implementation mainGame
@synthesize firstTouch, initialRect, inMovement, touchInSpriteRect, orientation;
@synthesize timerCounter, pointsCounter;

// Helper class method that creates a Scene with the Menu as the only child
+ (CCScene *)scene
{
    // 'scene' is an autorelease object.
    CCScene *scene = [CCScene node];
    // 'layer' is an autorelease object.
    mainGame *game = [mainGame node];
    // Add layer as a child to scene
    [scene addChild:game];
    // Return the scene
    return scene;
}

// On 'init' we initialize our instance
- (id)init
{
    // Always call 'super' init
    // Apple recommends to re-assign 'self' with the "super's" return value
    if ((self = [super init])) {	
        //Fill the array with the first horizontal line blocks
        int indexAnt = 0;
        int random = 0;
        for (int i = 0; i < 6; i++) {
            //Generate the random sprite
            random = (arc4random() % 9) + 1;
            if (random != indexAnt) {
                indexGameBlocks[i][0] = random;
                indexAnt = random;
            } else {
                //If if the same number, have to go back to generete the random again
                i--;
            }
        }
        
        indexAnt = indexGameBlocks[0][0];
        //Fill the first vertical line of blocks
        for (int j = 1; j < 5; j++) {
            //Generate the random sprite
            random = (arc4random() % 9) + 1;
            if (random != indexAnt) {
                indexGameBlocks[0][j] = random;
            } else {
                j--;
            }
        }
        
        //FIll all the other element arrays
        for (int i = 1; i < 6; i++) {
            for (int j = 1; j < 5; j++) {
                random = (arc4random() % 9) + 1;
                if ((random != indexGameBlocks[i][j - 1]) && (random != indexGameBlocks[i - 1][j])) {
                    indexGameBlocks[i][j] = random;
                } else {
                    j--;
                }
            }
        }
        
        //Adding the pause button
        CCMenuItem *Pause = [CCMenuItemImage itemWithNormalImage:@"pause.png" selectedImage: @"pause.png"
                                target:self selector:@selector(pause:)];
        
        CCMenu *PauseButton = [CCMenu menuWithItems: Pause, nil];
        PauseButton.position = ccp(160, 440);
        [self addChild:PauseButton z:1000];
        
        //Set the actuals points in the game
        pointsCounter = 0;
        points_label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i", self.pointsCounter]
                                         fontName:@"Marker Felt" fontSize:46];
        //Set the points label position, color and add it to the layer
        points_label.position = ccp(80, 440);
        points_label.color = ccYELLOW;
        //Create an image for the points
        CCSprite * points_image = [CCSprite spriteWithFile:@"littleBoom.png"];
        points_image.position = ccp(30, 440);
        [self addChild:points_image];
        [self addChild:points_label];
        
        //Set the timer couter to 30 seconds and then asign the value to the label
        timerCounter = 30;
        timer_label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i", self.timerCounter]
                                fontName:@"Marker Felt" fontSize:46];
        //Set the timer label position, color and add it to the layer
        timer_label.position = ccp(290,440);
        timer_label.color = ccYELLOW;
        //Create an image for the points
        CCSprite * timer_image = [CCSprite spriteWithFile:@"littleClock.png"];
        timer_image.position = ccp(240, 440);
        [self addChild:timer_image];
        [self addChild:timer_label];
        //Call the funciton to upload the timer in one second intervals
        [self schedule:@selector(countDown:) interval:1.0f];
        
        //Create a temporal array to add the sprites for each line
        for (int i = 0; i < 6; i++) {
            for (int j = 0; j < 5; j++) {
                //Create and initialize the sprite
                NSString *block_name = [NSString stringWithFormat:@"%i.png", indexGameBlocks[i][j] + 1];
                CCSprite *block = [CCSprite spriteWithFile:block_name];
                [block setPosition:ccp((j + 1) * 57, (i + 1) * 57)];
                [self addChild:block];
                //Add the sprite to a temporal array
                blocks_game[i][j] = block;
            }
        }
        
        // register the touch handle events
        self.isTouchEnabled = YES;
    }
    return self;
}

/* Function to make the countdown timer*/
-(void)countDown:(ccTime)delta {
    //Reduces the timer and set the label value with the timpe updated
    self.timerCounter--;
    [timer_label setString:[NSString stringWithFormat:@"%i", self.timerCounter]];
    //If the remaining time is over, un schedule the function
    if (self.timerCounter <= 0) {
        [self unschedule:@selector(countDown:)];
        [[CCDirector sharedDirector] sendCleanupToScene];
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade
                                                   transitionWithDuration:1
                                                   scene:[EndGame node]]
         ];
    }
}


/*This method receives the window point where that user touched and returns the touched sprite, if
    touched one*/
- (CCSprite *)touchedSprite:(CGPoint ) location {
    for (int i = 0; i < 6; i++) {
        for (int j=0; j < 5; j++) {
            //If the point is inside the rect, return the sprite
            if(CGRectContainsPoint([blocks_game[i][j] boundingBox], location)) {
                return blocks_game[i][j];
            }
        }
    }
    //The touch event is outside the blocks
    return nil;
}

-(void) pause: (id) sender{
    [[CCDirector sharedDirector] pushScene:[ PauseGame node]];
}

-(void) registerWithTouchDispatcher
{
        [[[CCDirector sharedDirector] touchDispatcher]
         addTargetedDelegate:self priority:0
         swallowsTouches:YES];
}

// return YES here to tell the touch dispatcher that you want to claim this touch
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchLocation;
    CGSize blocksSize;
    // Handle the position of the touch
    self.inMovement = false;
    self.touchInSpriteRect = NO;
    touchLocation = [self convertTouchToNodeSpace:touch];
    touchedBlock = [self touchedSprite:touchLocation];
    if(touchedBlock){
        blocksSize = touchedBlock.textureRect.size;
        self.initialRect = CGRectMake(touchedBlock.position.x - blocksSize.width / 2,
                                      touchedBlock.position.y - blocksSize.height / 2,
                                      blocksSize.width, blocksSize.height);
        
        self.touchInSpriteRect = CGRectContainsPoint(self.initialRect, touchLocation);
        if (self.touchInSpriteRect) {
            self.firstTouch = touchLocation;
            touchedBlock.scale *= 1.1;
        }
    }
    return self.touchInSpriteRect;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    float dx, dy;
    CGPoint touchLocation, lastLocation, origin, finalPosition;
    CGSize size;
    if (!self.touchInSpriteRect) {
        return;
    }
    // Now, we start the movement
    if (self.inMovement) {
        touchLocation = [self convertTouchToNodeSpace:touch];
        lastLocation = [touch previousLocationInView:[touch view]];
        finalPosition = touchedBlock.position;
        dx = touchLocation.x - lastLocation.x;
        dy = touchLocation.y - lastLocation.y;
        if (self.orientation == 0) {
            finalPosition.x = touchLocation.x;
            if (dx > 0) {
                NSLog(@"Moviendose horizontal a la derecha");
            } else if (dx < 0) {
                NSLog(@"Moviendose horizontal a la izquierda");
            }
        } else if (self.orientation == 1) {
            finalPosition.y = touchLocation.y;
            if (dy > 0) {
                NSLog(@"Moviendose vertical hacia arriba");
            } else {
                NSLog(@"Moviendose vertical hacia abajo");
            }
        } else {
            NSLog(@"Direccion no especificada");
        }
        if (self.orientation != 2) {
            touchedBlock.position = finalPosition;
        }
    } else {
        touchLocation = [self convertTouchToNodeSpace:touch];
        lastLocation = [touch previousLocationInView:[touch view]];
        origin = self.initialRect.origin;
        size = self.initialRect.size;
        
        dx = touchLocation.x - self.firstTouch.x;
        dy = touchLocation.y - self.firstTouch.y;
        dx = fabsf(dx);
        dy = fabsf(dy);
        // Checks the orientation of the movement
        // 0 -> horizontal,  1 -> vertical,  2 -> error
        if (touchLocation.y >= origin.y && touchLocation.y <= (origin.y + size.height) &&
            dx >= kMinimumGestureLength && dy <= kMaximumVariance) {
            self.orientation = 0;
            self.inMovement = YES;
        } else if (touchLocation.x >= origin.x && touchLocation.x <= (origin.x + size.width) &&
                   dy >= kMinimumGestureLength && dx <= kMaximumVariance) {
            self.orientation = 1;
            self.inMovement = YES;
        } else {
            self.orientation = 2;
        }
    }
}

// move the sprite wherever the touch ends
- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    self.inMovement = false;
    self.touchInSpriteRect = NO;
    [touchedBlock stopAllActions];
    touchedBlock.scale /= 1.1;
}

#pragma mark GameKit delegate

- (void)achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

@end
