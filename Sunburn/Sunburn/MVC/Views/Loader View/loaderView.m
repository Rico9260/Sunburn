//
//  loaderView.m
//  Sunburn
//
//  Created by binit on 26/08/15.
//  Copyright (c) 2015 Code Brew Labs. All rights reserved.
//

#import "loaderView.h"

@implementation loaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self){
        
        self = [[[NSBundle mainBundle] loadNibNamed:@"loaderView" owner:self options:nil] firstObject];
        [self setFrame:frame];
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    _spinner = [[RTSpinKitView alloc] initWithStyle:RTSpinKitViewStyleWanderingCubes color:[UIColor whiteColor]];
    _spinner.center = self.center;
    [self addSubview:_spinner];
    return self;
}

-(void)startAnimating{
    
    [_spinner startAnimating];
}

-(void)stopAnimating{
    
    [_spinner stopAnimating];
}
@end
