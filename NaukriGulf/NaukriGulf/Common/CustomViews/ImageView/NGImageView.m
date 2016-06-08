//
//  NGImageView.m
//  NaukriGulf
//
//  Created by Arun Kumar on 21/08/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGImageView.h"

@implementation NGImageView

- (id)initWithBasicParameters:(NSMutableDictionary*)params
{
    self = [super initWithBasicParameters:params];
    if (self)
    {
        
    }
    return self;
}

-(void)cropImageCircularWithBorderWidth:(float)borderWidth{
    [super cropImageCircularWithBorderWidth:borderWidth borderColor:[UIColor blackColor]];
}

-(void)setImageWithLocalURL:(NSString *)url{
    
    if (![url isEqualToString:@""] && url) {
        NSData *data = [NSData dataWithContentsOfFile:url];
        UIImage *image = [UIImage imageWithData:data];
        if (image) {
            self.image = image;
        }else{
            self.image = [UIImage imageNamed:@"usrPic"];
        }
        
    }else{
        self.image = [UIImage imageNamed:@"usrPic"];
    }
    
}

@end
