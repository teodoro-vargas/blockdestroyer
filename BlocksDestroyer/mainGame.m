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
@synthesize timerCounter;
@synthesize pointsCounter;
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
        // Initial points: cero
        self.pointsCounter = 0;
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
        
        //Set the timer couter to 90 seconds and then asign the value to the label
        timerCounter = GAME_DURATION;
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
        
        // Create a temporal array to add the sprites for each line
        for (int i = 0; i < ROWS; i++) {
            for (int j = 0; j < COLUMNS; j++) {
                //Create and initialize the sprite
                NSString *block_name = [NSString stringWithFormat:@"%i.png", indexGameBlocks[i][j]];
                CCSprite *block = [CCSprite spriteWithFile:block_name];
                gameCenters[i][j] = CGPointMake(j * WIDTH_SPRITE + OFFSET, i * WIDTH_SPRITE + OFFSET);
                [block setPosition:gameCenters[i][j]];
                [self addChild:block];
                //Add the sprite to a temporal array
                blocks_game[i][j] = block;
            }
        }
        
        // Register the touch handle events
        self.isTouchEnabled = YES;
        
        // Set the background image
        background = [CCSprite spriteWithFile:@"TreeHouse.png"];
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        CGSize backgroundSize = background.contentSize;
        background.scaleX = winSize.width / backgroundSize.width;
        background.scaleY = winSize.height / backgroundSize.height;
        background.position = CGPointMake(winSize.width / 2, winSize.height / 2);
        [self addChild:background z:-2];
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
                
                // Movement to the left
                if (dx < 0) {
                    if (finalPosition.x < 0) {
                        finalPosition.x += (COLUMNS * DIST_CENTERS);
                    } else if (finalPosition.x > (gameCenters[self.activeRow][COLUMNS - 1].x + DIST_CENTERS / 2)) {
                        finalPosition.x -= (COLUMNS * DIST_CENTERS);
                    }
                } else if (dx > 0) {
                    // Movement to the right
                    if (finalPosition.x > (gameCenters[self.activeRow][COLUMNS - 1].x + DIST_CENTERS / 2)) {
                        finalPosition.x -= (COLUMNS * DIST_CENTERS);
                    } else if (finalPosition.x < 0) {
                        finalPosition.x += (COLUMNS * DIST_CENTERS);
                    }
                }
                blocks_game[self.activeRow][i].position = finalPosition;
            }
        } else if (self.orientation == 1) {
            for (i = 0; i < ROWS; i++) {
                finalPosition.y = touchLocation.y + (i - self.activeRow) * DIST_CENTERS;
                
                // Down movement
                if (dy < 0) {
                    if (finalPosition.y < 0) {
                        finalPosition.y += (ROWS * DIST_CENTERS);
                    } else if (finalPosition.y > (gameCenters[ROWS - 1][self.activeColumn].y + DIST_CENTERS / 2)) {
                        finalPosition.y -= (ROWS * DIST_CENTERS);
                    }
                } else if (dy > 0) {
                    // Up movement
                    if (finalPosition.y > (gameCenters[ROWS - 1][self.activeColumn].y + DIST_CENTERS / 2)) {
                        finalPosition.y -= (ROWS * DIST_CENTERS);
                    } else if (finalPosition.y < 0) {
                        finalPosition.y += (ROWS * DIST_CENTERS);
                    }
                }
                
                blocks_game[i][self.activeColumn].position = finalPosition;
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
        finalPosition.y = gameCenters[self.activeRow][0].y;
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
                finalPosition.x = gameCenters[self.activeRow][i].x;
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
                finalPosition.x = gameCenters[self.activeRow][i].x;
                [blocks_game[self.activeRow][i] runAction:[CCMoveTo actionWithDuration:0.2f position:finalPosition]];
            }
        }
        
        // Vertical
    } else if (self.orientation == 1) {
        near = [self nearRow:touchLocation forColumn:self.activeColumn];
        //
        displacement = self.activeRow - near;
        finalPosition.x = gameCenters[0][self.activeColumn].x;
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
                finalPosition.y = gameCenters[i][self.activeColumn].y;
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
                finalPosition.y = gameCenters[i][self.activeColumn].y;
                [blocks_game[i][self.activeColumn] runAction:[CCMoveTo actionWithDuration:0.2f position:finalPosition]];
            }
        }
    }
    
    self.inMovement = false;
    self.touchInSpriteRect = NO;
    self.activeColumn = 0;
    self.activeRow = 0;
    touchedBlock.scale /= 1.1;

    // Now, check if there are some points around and remove sprites
    [self getPoints];
    // Now, fill the empty spaces with some random sprites
    [self fillNewSprites];
}

- (int)nearColumn:(CGPoint)location forRow:(int)row
{
    int i, c;
    CGFloat diff, minimum, x;
    minimum = 10000;
    for (i = 0; i < COLUMNS; i++) {
        x = gameCenters[row][i].x;
        diff = fabsf(x - location.x);
        if (diff < minimum) {
            c = i;
            minimum = diff;
        }
    }
    return c;
}

- (int)nearRow:(CGPoint)location forColumn:(int)column
{
    int i, r;
    CGFloat diff, minimum, y;
    minimum = 10000;
    for (i = 0; i < ROWS; i++) {
        y = gameCenters[i][column].y;
        diff = fabsf(y - location.y);
        if (diff < minimum) {
            r = i;
            minimum = diff;
        }
    }
    return r;
}

- (void)getPoints
{
    int i, j, equal;
    BOOL points = NO;
    while (!points) {
        points = YES;
        memset(processed, NO, sizeof(processed));
        for (i = 0; i < ROWS; i++) {
            for (j = 0; j < COLUMNS; j++) {
                equal = [self checkEqualIndex:indexGameBlocks[i][j] posX:j posY:i];
                if (equal >= 3) {
                    equal = (equal - 2) * 5;
                    points = NO;
                    [self markToDelete:indexGameBlocks[i][j] posX:j posY:i];
                    self.pointsCounter += equal;
                    
                    // Show the earned points in the game area
                    CCLabelTTF *earnedPoints = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i", equal] fontName:@"Marker Felt" fontSize:55];
                    [earnedPoints setPosition:gameCenters[i][j]];
                    [earnedPoints setColor:ccRED];
                    [earnedPoints setOpacity:0.0];
                    [self addChild:earnedPoints z:10];
                    CCFadeIn *fadeIn = [CCFadeIn actionWithDuration:0.4];
                    CCFadeOut *fadeOut = [CCFadeOut actionWithDuration:0.4];
                    CGPoint earnedPos = gameCenters[i][j];
                    earnedPos.y += 30;
                    CCMoveTo *moveTo = [CCMoveTo actionWithDuration:0.4 position:earnedPos];
                    CCSpawn *spawnActions = [CCSpawn actionOne:fadeOut two:moveTo];
                    CCCallBlockN *removeEarned = [CCCallBlockN actionWithBlock:^(CCNode *node) {
                        [node removeFromParentAndCleanup:YES];
                    }];
                    CCSequence *sequence = [CCSequence actions:fadeIn, spawnActions, removeEarned, nil];
                    [earnedPoints runAction:sequence];
                    // Play sound
#pragma mark TODO
                }
            }
        }
        // Remove and move down the other sprites
        [self destroyAdjacents];
    }
    // Update the pointer marker
    [points_label setString:[NSString stringWithFormat:@"%i", self.pointsCounter]];
}

- (int)checkEqualIndex:(int)index posX:(int)x posY:(int)y
{
    int dx[4] = {0, 1, 0, -1};
    int dy[4] = {-1, 0, 1, 0};
    int i, nx, ny, total = 1;
    
    // Out of the matrix
    if (x < 0 || y < 0 || x >= COLUMNS || y >= ROWS) {
        return 0;
    }
    // Already processed
    if (processed[y][x] == YES) {
        return 0;
    }
    // Different index or marked to deleted or empty
    if (indexGameBlocks[y][x] == TO_DELETED ||
        indexGameBlocks[y][x] == EMPTY ||
        indexGameBlocks[y][x] != index)
    {
        return 0;
    }
    // Change the index and check the cells around
    processed[y][x] = YES;
    for (i = 0; i < 4; i++) {
        nx = x + dx[i];
        ny = y + dy[i];
        total += [self checkEqualIndex:index posX:nx posY:ny];
    }
    
    return total;
}

- (void)markToDelete:(int)index posX:(int)x posY:(int)y
{
    int dx[4] = {0, 1, 0, -1};
    int dy[4] = {-1, 0, 1, 0};
    int i, nx, ny;
    
    // Out of the matrix
    if (x < 0 || y < 0 || x >= COLUMNS || y >= ROWS) {
        return;
    }
    // Different index
    if (indexGameBlocks[y][x] != index) {
        return;
    }
    // Marke to delete
    indexGameBlocks[y][x] = TO_DELETED;
    for (i = 0; i < 4; i++) {
        nx = x + dx[i];
        ny = y + dy[i];
        [self markToDelete:index posX:nx posY:ny];
    }
}

- (void)destroyAdjacents
{
    int i, j, z;
    CCSprite *temporalSprite;
    for (i = 0; i < ROWS; i++) {
        for (j = 0; j < COLUMNS; j++) {
            if (indexGameBlocks[i][j] == TO_DELETED) {
                temporalSprite = blocks_game[i][j];
                // [blocks_game[i][j] removeFromParentAndCleanup:YES];
                z = i;
                while (z < (ROWS - 1)) {
                    // Move the sprite
                    blocks_game[z][j] = blocks_game[z + 1][j];
                    if (blocks_game[z][j] != nil) {
                        [blocks_game[z][j] runAction:
                         [CCMoveTo actionWithDuration:0.3f position:gameCenters[z][j]]];
                    }
                    // Move the index
                    indexGameBlocks[z][j] = indexGameBlocks[z + 1][j];
                    z++;
                }
                // Fill the up cell for this column
                // Sprite = nil
                blocks_game[z][j] = nil;
                // Index = EMPTY
                indexGameBlocks[z][j] = EMPTY;
                
                // Then, if the new value is TO_DELETED, go back one position
                if (indexGameBlocks[i][j] == TO_DELETED) {
                    --j;
                }
                
                CCFiniteTimeAction *action1 = [CCFadeOut actionWithDuration:0.3f];
                CCFiniteTimeAction *action2 = [CCCallBlockN actionWithBlock:^(CCNode *node) {
                    [node removeFromParentAndCleanup:YES];
                }];
                [temporalSprite runAction:
                 [CCSequence actions:action1, action2, nil]];
            }
        }
    }
}

- (void)fillNewSprites
{
    int i, j, temp;
    for (i = 0; i < ROWS; i++) {
        for (j = 0; j < COLUMNS; j++) {
            if (indexGameBlocks[i][j] == EMPTY) {
                if (j == 0) {
                    temp = (arc4random() % NUM_SPRITES) + 1;
                } else if (i == 0 && j != 0) {
                    while ((temp = (arc4random() % NUM_SPRITES) + 1) == indexGameBlocks[i][j - 1]) {
                        ;
                    }
                    
                } else {
                    do {
                        temp = (arc4random() % NUM_SPRITES) + 1;
                    } while (temp == indexGameBlocks[i - 1][j] || temp == indexGameBlocks[i][j - 1]);
                }
                indexGameBlocks[i][j] = temp;
                NSString *block_name = [NSString stringWithFormat:@"%i.png", temp];
                CCSprite *block = [CCSprite spriteWithFile:block_name];
                [block setPosition:gameCenters[i][j]];
                block.opacity = 0;
                [self addChild:block];
                [block runAction:
                 [CCFadeIn actionWithDuration:0.5f]];
                blocks_game[i][j] = block;
            }
        }
    }
}

- (void)debug
{
    int i, j;
    printf("Indices:\n");
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
