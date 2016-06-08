
//
//  NGRescentSearchTuple.m
//  NaukriGulf
//
//  Created by Minni Arora on 19/06/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NGRescentSearchTuple.h"

@implementation NGRescentSearchTuple

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if(self) {
        self.experience = [NSNumber numberWithInteger:(NSInteger)[decoder decodeIntegerForKey:@"experience"]];
        self.location = [decoder decodeObjectForKey:@"locations"];
        self.keyword = [decoder decodeObjectForKey:@"keywords"];
        self.searchedString=[decoder decodeObjectForKey:@"searchedstring"];
        self.searchJobCount = [NSNumber numberWithInteger:0];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeInteger:[_experience integerValue] forKey:@"experience"];
    [encoder encodeObject:self.location forKey:@"locations"];
    [encoder encodeObject:self.keyword forKey:@"keywords"];
    [encoder encodeObject:self.searchedString forKey:@"searchedstring"];
}

@end
