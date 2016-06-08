//
//  NGStaticContentManager.h
//  NaukriGulf
//
//  Created by Arun Kumar on 09/07/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "BaseStaticContentManager.h"

/**
 *  The class used for getting static data like dropdown data from file or from local database.
 */
@interface NGStaticContentManager : BaseStaticContentManager


+(NSArray *)getNewDropDownData:(int) ddType;
@end
