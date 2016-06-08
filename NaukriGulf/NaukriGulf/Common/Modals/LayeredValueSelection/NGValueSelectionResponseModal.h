//
//  NGValueSelectionResponseModal.h
//  Naukri
//
//  Created by Arun Kumar on 8/27/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NGValueSelectionResponseModal : NSObject

@property(nonatomic, readwrite) NSInteger dropDownType;
@property(nonatomic , strong) NSString* selectedValue;
@property(nonatomic , strong) NSString* selectedId;
@property(nonatomic , strong) NGValueSelectionResponseModal* valueSelectionResponseObj;
@end
