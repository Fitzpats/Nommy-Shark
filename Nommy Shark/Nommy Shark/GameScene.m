//
//  GameScene.m
//  Nommy Shark
//
//  Created by Shayla Fitzpatrick on 5/8/16.
//  Copyright (c) 2016 Shayla Fitzpatrick. All rights reserved.
//
#import "GameScene.h"

@interface GameScene () {
    SKSpriteNode* sprite;
    SKSpriteNode* sea;
    SKSpriteNode* coin;
    SKAction* MoveAndRemoveCoin;
    SKLabelNode* scoreLabelNode;
    NSInteger score;
}
@end

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    self.physicsWorld.gravity = CGVectorMake( 0.0, 0.5 );
    /* Setup your scene here */
    
    //number of coins hit(work in progress
    score = 0;
    scoreLabelNode = [SKLabelNode labelNodeWithFontNamed:@"MarkerFelt-Wide"];
    scoreLabelNode.position = CGPointMake( CGRectGetMidX( self.frame ) ,7* self.frame.size.height /8 );
    scoreLabelNode.zPosition = 100;
    scoreLabelNode.text = [NSString stringWithFormat:@"%ld",(long)score];
    [self addChild:scoreLabelNode];
    //set up shark
    SKTexture* shark1 = [SKTexture textureWithImageNamed:@"Spaceship"];
    shark1.filteringMode = SKTextureFilteringNearest;
    SKTexture* shark2 = [SKTexture textureWithImageNamed:@"spaceship2"];
    shark2.filteringMode = SKTextureFilteringNearest;
    
    SKAction* nom = [SKAction repeatActionForever:[SKAction animateWithTextures:@[shark1, shark2] timePerFrame:0.2]];
    
    sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
    sprite.name = @"shark";
    sprite.xScale = 0.1;
    sprite.yScale = 0.1;
    sprite.position = CGPointMake(CGRectGetMidX(self.frame),
                                  (CGRectGetMinY(self.frame))+.5);
    sprite.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:sprite.size.height / 2];
    
    //set up background
    self.backgroundColor = [SKColor cyanColor];
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    
    //ocean floor
    sea = [SKSpriteNode spriteNodeWithImageNamed:@"background"];
    sea.xScale = 0.25;
    sea.yScale = 0.25;
    sea.zPosition = -50;
    sea.position = CGPointMake(CGRectGetMidX(self.frame),
                               (CGRectGetMinY(self.frame))+50);
    
    
    //making it so coins spawn comsistantly
    SKAction* spawn = [SKAction performSelector:@selector(spawnCoins) onTarget:self];
    SKAction* delay = [SKAction waitForDuration:2.0];
    SKAction* spawnThenDelay = [SKAction sequence:@[spawn, delay]];
    SKAction* spawnThenDelayForever = [SKAction repeatActionForever:spawnThenDelay];
    
    
    //and add it all to the scene
    
    [self addChild:sprite];
    [sprite runAction:nom];
    [self addChild:sea];
    [self runAction:spawnThenDelayForever];

    
    
}

-(void)spawnCoins {
    //setting up coin
    coin = [SKSpriteNode spriteNodeWithImageNamed:@"coin"];
    coin.name = @"coin";
    coin.xScale = 0.1;
    coin.yScale = 0.1;
    coin.zPosition = -10;
    CGFloat y = arc4random() % (NSInteger)( self.frame.size.height);
    coin.position = CGPointMake(CGRectGetMaxX(self.frame), y );
    coin.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:coin.size];
    
    
    //moving the coin
    CGFloat distanceToMove = self.frame.size.width + 2 * coin.size.width;
    coin.physicsBody.dynamic = NO;
    SKAction* moveCoin = [SKAction moveByX:-distanceToMove y:0 duration:0.01 * distanceToMove];
    SKAction* removeCoin = [SKAction removeFromParent];
    MoveAndRemoveCoin = [SKAction sequence:@[moveCoin, removeCoin]];
    
    [self addChild:coin];
    [coin runAction:moveCoin];
    
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    /* Called when a touch begins */
    
    if((sprite.position.y) > CGRectGetMinY(self.frame)+300)
        sprite.position = CGPointMake(CGRectGetMidX(self.frame),
                                      (sprite.position.y)-200);
    
    score++;
    scoreLabelNode.text = [NSString stringWithFormat:@"%ld", (long)score];

  

    
    
    
}
-(void)resetScene {
    self.backgroundColor = [SKColor cyanColor];
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    sprite.position = CGPointMake(CGRectGetMidX(self.frame),
                                  (CGRectGetMinY(self.frame))+.5);
    sprite.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:sprite.size.height / 2];
    
    
}
/*- (void)didBeginContact:(SKPhysicsContact *)contact {
            // Bird has contact with score entity
    uint32_t collision = (contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask);
    
    if (collision == (playerCategory | asteroidCategory)) {
        // do something
    
            score++;
            scoreLabelNode.text = [NSString stringWithFormat:@"%ld", (long)score];
    }
    
}*/


@end

@interface ApproachingSprite : SKSpriteNode
@property (nonatomic, weak) UITouch *touch;
@property (nonatomic) CGPoint targetPosition;
-(void)update;
@end

