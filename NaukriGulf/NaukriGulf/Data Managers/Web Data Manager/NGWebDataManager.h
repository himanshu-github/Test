//
//  NGWebDataManager.h
//  NaukriGulf
//
//  Created by Arun Kumar on 13/09/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "BaseWebDataManager.h"

#import "BaseAPICaller.h"

#import "NGMNJProfileServiceClient.h"
#import "NGAPIResponseModal.h"

/**
 *  The class used to fetch data from the server.
 
 Conforms to APICallerDelegate protocol.
 */
@interface NGWebDataManager : BaseWebDataManager

/**
 *  This method initializes service client.
 *
 *  @param serviceType Denotes the type of service/API.
 *
 *  @return Returns the self object.
 */
-(id)initWithServiceType:(NSInteger)serviceType;

#pragma mark - Blocks+NSOperation
-(void)getDataWithParams:(NSMutableDictionary*)params
                 handler:(void(^)(NGAPIResponseModal* responseInfo))completionHandler;


@end
