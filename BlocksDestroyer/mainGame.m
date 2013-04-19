//
//  Menu.m
//  BlocksDestroyer
//
//  Created by Teodoro Vargas Cortés on 08/04/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

// Import the interfaces
#import "mainGame.h"
#import "CCTouchDelegateProtocol.h"
#import "CCTouchDispatcher.h"
#include <stdlib.h>
#include <string.h>

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

CCSprite *touchedBlock;
CCSprite *copySprite;

#pragma mark - mainGame


@implementation mainGame
@synthesize firstTouch;
@synthesize initialRect;
@synthesize inMovement;
@synthesize touchInSpriteRect;
@synthesize orientation;
@synthesize activeColumn;
@synthesize activeRow;

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
        for (int i = 0; i < ROWS; i++) {
            //Generate the random sprite
            random = (arc4random() % NUM_SPRITES) + 1;
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
        for (int j = 1; j < COLUMNS; j++) {
            //Generate the random sprite
            random = (arc4random() % NUM_SPRITES) + 1;
            if (random != indexAnt) {
                indexGameBlocks[0][j] = random;
            } else {
                j--;
            }
        }
        
        // Fill all the other element arrays
        for (int i = 1; i < ROWS; i++) {
            for (int j = 1; j < COLUMNS; j++) {
                random = (arc4random() % NUM_SPRITES) + 1;
                if ((random != indexGameBlocks[i][j - 1]) && (random != indexGameBlocks[i - 1][j])) {
                    indexGameBlocks[i][j] = random;
                } else {
                    j--;
                }
            }
        }
        
        // Create a temporal array to add the sprites for each line
        for (int i = 0; i < ROWS; i++) {
            for (int j = 0; j < COLUMNS; j++) {
                //Create and initialize the sprite
                NSString *block_name = [NSString stringWithFormat:@"%i.png", indexGameBlocks[i][j]];
                CCSprite *block = [CCSprite spriteWithFile:block_name];
                [block setPosition:ccp(j * WIDTH_SPRITE + OFFSET, i * WIDTH_SPRITE + OFFSET)];
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


/* This method receives the window point where that user touched and returns the touched sprite, if
    touched one */
- (CCSprite *)touchedSprite:(CGPoint)location
{
    for (int i = 0; i < ROWS; i++) {
        for (int j = 0; j < COLUMNS; j++) {
            //If the point is inside the rect, return the sprite
            if(CGRectContainsPoint([blocks_game[i][j] boundingBox], location)) {
                self.activeRow = i;
                self.activeColumn = j;
                return blocks_game[i][j];
            }
        }
    }
    //The touch event is outside the blocks
    return nil;
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
    if (touchedBlock){
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
    int i;
    float dx, dy;
    CGPoint touchLocation, lastLocation, origin, finalPosition;
    CGSize size;
    if (!self.touchInSpriteRect) {
        return;
    }
    // Now, we start the movement
    touchLocation = [self convertTouchToNodeSpace:touch];
    lastLocation = [touch previousLocationInView:[touch view]];
    if (self.inMovement) {
        finalPosition = touchedBlock.position;
        dx = touchLocation.x - lastLocation.x;
        dy = touchLocation.y - lastLocation.y;
        if (self.orientation == 0) {
            for (i = 0; i < COLUMNS; i++) {
                finalPosition.x = touchLocation.x + (i - self.activeColumn) * DIST_CENTERS;
                blocks_game[self.activeRow][i].position = finalPosition;
            }
            if (dx > 0) {
                //NSLog(@"Moviendose horizontal a la derecha");
            } else if (dx < 0) {
                //NSLog(@"Moviendose horizontal a la izquierda");
            }
        } else if (self.orientation == 1) {
            for (i = 0; i < ROWS; i++) {
                finalPosition.y = touchLocation.y + (i - self.activeRow) * DIST_CENTERS;
                blocks_game[i][self.activeColumn].position = finalPosition;
            }
            if (dy > 0) {
                // NSLog(@"Moviendose vertical hacia arriba");
            } else {
                // NSLog(@"Moviendose vertical hacia abajo");
            }
        } else {
            NSLog(@"Direccion no especificada");
        }
    } else {
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
    int i, j, near, displacement, tempIndex[ROWS];
    CGPoint touchLocation, finalPosition;
    CCSprite *tempSprites[ROWS];

    // Get the last touch location
    touchLocation = [self convertTouchToNodeSpace:touch];
    // Horizontal
    if (self.orientation == 0) {
        near = [self nearColumn:touchLocation forRow:self.activeRow];
        //
        displacement = self.activeColumn - near;
        finalPosition.y = self.activeRow * WIDTH_SPRITE + OFFSET;
        for (i = 0; i < COLUMNS; i++) {
            tempIndex[i] = indexGameBlocks[self.activeRow][i];
            tempSprites[i] = blocks_game[self.activeRow][i];
            blocks_game[self.activeRow][i] = nil;
        }
        if (displacement < 0) {
            // Move everything to the left
            for (i = 0; i < COLUMNS; i++) {
                j = (displacement + i + COLUMNS) % COLUMNS;
                indexGameBlocks[self.activeRow][i] = tempIndex[j];
                tempIndex[j] = 0;
                blocks_game[self.activeRow][i] = tempSprites[j];
                tempSprites[j] = nil;
            }
            for (i = 0; i < COLUMNS; i++) {
                finalPosition.x = i * WIDTH_SPRITE + OFFSET;
                [blocks_game[self.activeRow][i] runAction:[CCMoveTo actionWithDuration:0.2f position:finalPosition]];
            }
        } else {
            // Move everything to the right
            for (i = 0; i < COLUMNS; i++) {
                j = (displacement + i) % COLUMNS;
                indexGameBlocks[self.activeRow][i] = tempIndex[j];
                tempIndex[j] = 0;
                blocks_game[self.activeRow][i] = tempSprites[j];
                tempSprites[j] = nil;
            }
            for (i = 0; i < COLUMNS; i++) {
                finalPosition.x = i * WIDTH_SPRITE + OFFSET;
                [blocks_game[self.activeRow][i] runAction:[CCMoveTo actionWithDuration:0.2f position:finalPosition]];
            }
        }
        
        // Vertical
    } else if (self.orientation == 1) {
        near = [self nearRow:touchLocation forColumn:self.activeColumn];
        //
        displacement = self.activeRow - near;
        finalPosition.x = self.activeColumn * WIDTH_SPRITE + OFFSET;
        for (i = 0; i < ROWS; i++) {
            tempIndex[i] = indexGameBlocks[i][self.activeColumn];
            tempSprites[i] = blocks_game[i][self.activeColumn];
            blocks_game[i][self.activeColumn] = nil;
        }
        if (displacement < 0) {
            // Move everything down
            for (i = 0; i < ROWS; i++) {
                j = (displacement + i + ROWS) % ROWS;
                indexGameBlocks[i][self.activeColumn] = tempIndex[j];
                tempIndex[j] = 0;
                blocks_game[i][self.activeColumn] = tempSprites[j];
                tempSprites[j] = nil;
            }
            for (i = 0; i < ROWS; i++) {
                finalPosition.y = i * WIDTH_SPRITE + OFFSET;
                [blocks_game[i][self.activeColumn] runAction:[CCMoveTo actionWithDuration:0.2f position:finalPosition]];
            }
        } else {
            // Move everything up
            for (i = 0; i < ROWS; i++) {
                j = (displacement + i) % ROWS;
                indexGameBlocks[i][self.activeColumn] = tempIndex[j];
                tempIndex[j] = 0;
                blocks_game[i][self.activeColumn] = tempSprites[j];
                tempSprites[j] = nil;
            }
            for (i = 0; i < ROWS; i++) {
                finalPosition.y = i * WIDTH_SPRITE + OFFSET;
                [blocks_game[i][self.activeColumn] runAction:[CCMoveTo actionWithDuration:0.2f position:finalPosition]];
            }
        }
    }
    
    self.inMovement = false;
    self.touchInSpriteRect = NO;
    self.activeColumn = 0;
    self.activeRow = 0;
    //[touchedBlock stopAllActions];
    touchedBlock.scale /= 1.1;
    //[self removeChild:copySprite cleanup:YES];
    //copySprite = nil;
}

- (NSInteger)nearColumn:(CGPoint)location forRow:(NSInteger)row
{
    NSInteger x, i, c;
    CGFloat diff, minimum;
    minimum = 10000;
    for (i = 0; i < COLUMNS; i++) {
        x = i * 60 + 32;
        diff = fabsf(x - location.x);
        if (diff < minimum) {
            c = i;
            minimum = diff;
        }
    }
    return c;
}

- (NSInteger)nearRow:(CGPoint)location forColumn:(NSInteger)column
{
    NSInteger y, i, r;
    CGFloat diff, minimum;
    minimum = 10000;
    for (i = 0; i < ROWS; i++) {
        y = i * 60 + 32;
        diff = fabsf(y - location.y);
        if (diff < minimum) {
            r = i;
            minimum = diff;
        }
    }
    return r;
}

- (void)debug
{
    int i, j;
    for (i = 0; i < ROWS; i++) {
        for (j = 0; j < COLUMNS; j++) {
            printf("%d ", indexGameBlocks[i][j]);
        }
        printf("\n");
    }
    printf("\nDirecciones:\n");
    for (i = 0; i < ROWS; i++) {
        for (j = 0; j < COLUMNS; j++) {
            printf("%p ", blocks_game[i][j]);
        }
        printf("\n");
    }
    printf("\n");
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
