//
//  TapScrollView.m
//  Sunburn
//
//  Created by Aseem on 03/09/15.
//  Copyright (c) 2015 Code Brew Labs. All rights reserved.
//

#import "TapScrollView.h"

@implementation TapScrollView


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    
    
    // If not dragging, send event to next responder
    
    if (!self.dragging){
        
        [self.nextResponder touchesBegan: touches withEvent:event];
        
    }
    
    else{
        
        [super touchesEnded: touches withEvent: event];
        
    }
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    
    
    // If not dragging, send event to next responder
    
    if (!self.dragging){
        
        [self.nextResponder touchesBegan: touches withEvent:event];
        
    }
    
    else{
        
        [super touchesEnded: touches withEvent: event];
        
    }
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    
    
    // If not dragging, send event to next responder
    
    if (!self.dragging){
        
        [self.nextResponder touchesBegan: touches withEvent:event];
        
    }
    
    else{
        
        [super touchesEnded: touches withEvent: event];
        
    }
    
}

@end
