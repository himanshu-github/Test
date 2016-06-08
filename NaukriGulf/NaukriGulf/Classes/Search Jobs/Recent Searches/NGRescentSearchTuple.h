//
//  NGRescentSearchTuple.h
//  NaukriGulf
//
//  Created by Minni Arora on 19/06/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NGRescentSearchTuple : NSObject

@property (strong, nonatomic) NSString *keyword;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSNumber *experience;
@property (strong, nonatomic) NSString *searchedString;

@property (strong, nonatomic) NSNumber *searchJobCount;//This value will not save in saveData, but help in maintaing recent search job's job count at runtime only.

@end
