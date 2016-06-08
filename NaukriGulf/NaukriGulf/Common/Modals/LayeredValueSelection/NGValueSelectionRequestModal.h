//
//  NGValueSelectionRequestModal.h
//  Naukri
//
//  Created by Arun Kumar on 8/27/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NGValueSelectionRequestModal : NSObject
@property(nonatomic , strong) NSString* value;
@property(nonatomic , strong) NSString* identifier;
@property(nonatomic , strong) NSMutableArray* requestModalArr;
@property(nonatomic , strong) NSString* selectedIdentifier;
@property(nonatomic) BOOL isSelected;

@end
