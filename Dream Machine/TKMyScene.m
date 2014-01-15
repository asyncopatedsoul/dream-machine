//
//  TKMyScene.m
//  Dream Machine
//
//  Created by Michael Garrido on 1/14/14.
//  Copyright (c) 2014 Michael Garrido. All rights reserved.
//

#import "TKMyScene.h"

@implementation TKMyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        //self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        self.backgroundColor = [UIColor whiteColor];
        
        self.anchorPoint = CGPointMake(0.5, 0.5); //0,0 to 1,1
        self.worldNode = [SKNode node];
        [self addChild:self.worldNode];
        
        [self setupTerrain];
        
        self.physicsWorld.gravity = CGVectorMake(0.0, -10.0);
        self.physicsWorld.contactDelegate = self;
        
        [self setupToys];
    }
    return self;
}

-(void) moveToy: (SKSpriteNode*) toy toPoint: (CGPoint)rallyPoint
{
    NSLog(@"executeMovement toy position: %f,%f", self.position.x, self.position.y);
    
    if (_actionPoint.x==0.0 && _actionPoint.y==0.0)
        return;
    
    CGPoint movementTarget = CGPointMake(self.position.x+_actionPoint.x, self.position.y+_actionPoint.y);
    SKAction *movementAction = [SKAction moveTo:movementTarget duration:_actionMagnitude/_movementSpeed];
    SKAction *movementDoneAction = [SKAction runBlock:(dispatch_block_t)^() {
        NSLog(@"Movement Completed");
    }];
    
    
    
    SKAction *moveActionWithDone = [SKAction sequence:@[movementAction,movementDoneAction]];
    [self runAction:moveActionWithDone withKey:@"isMoving"];
}

-(void) setupToys
{
    SKSpriteNode* toy = [SKSpriteNode spriteNodeWithColor:[UIColor blueColor] size: CGSizeMake(50.0, 50.0)];
    toy.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(50.0, 50.0)];
    toy.physicsBody.mass = 1.0;
    toy.physicsBody.dynamic = YES;
    
    toy.position = CGPointMake(0.0, 300.0);
    [self.worldNode addChild:toy];
}

-(void) setupTerrain
{
    //self.view.frame.size.width
    SKSpriteNode* groundNode = [SKSpriteNode spriteNodeWithColor:[UIColor brownColor] size:CGSizeMake(2000.0, 100.0) ];
    groundNode.position = CGPointMake(0.0,-300.0);
    [self.worldNode addChild:groundNode];

    groundNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(2000.0, 100.0)];
    groundNode.physicsBody.mass = 1.0;
    groundNode.physicsBody.dynamic = NO;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
        
        sprite.position = location;
        
        SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
        
        [sprite runAction:[SKAction repeatActionForever:action]];
        
        [self addChild:sprite];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
