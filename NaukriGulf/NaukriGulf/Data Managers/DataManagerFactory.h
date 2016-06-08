//
//  DataManagerFactory.h
//  NaukriGulf
//
//  Created by Arun Kumar on 09/07/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NGStaticContentManager.h"
#import "NGWebDataManager.h"

/**
 *  The class uses the concept of Factory Design Pattern to create objects of Data Manager class.
 */

@interface DataManagerFactory : NSObject


/**
 *  This method is used for getting the object of NGStaticContentManager class.
 *
 *  @return Returns the object of NGStaticContentManager class.
 */
+(NGStaticContentManager *)getStaticContentManager;

/**
 *  This method is used for getting the object of NGWebDataManager class.
 *
 *  @return Returns the object of NGWebDataManager class.
 */
+(NGWebDataManager *)getWebDataManagerWithServiceType:(NSInteger)serviceType;

@end
