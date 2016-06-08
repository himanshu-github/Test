//
//  DataFormatter.h
//  NaukriGulf
//
//  Created by Arun Kumar on 09/07/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebAPICaller.h"
#import "WebDataFormatter.h"
#import "NGDataParser.h"

/**
 *  The delegate used to notify once data is fetched from the server.
 */
@protocol WebDataFetcherDelegate <NSObject>

/**
 *  The method gets invoked when data is fetched from the server.
 *
 *  @param responseData Denotes the data received from the server.
 *  @param flag         Denotes if a valid data is received successfully from the server.
 */
@optional
@end

/**
 *  Base class of web data fetched. It is used to fetch data from the server.
 
    Conforms to APICallerDelegate protocol.
 */
@interface BaseWebDataFetcher : NSObject
/**
 *  The WebDataFetcherDelegate object.
 */
@property(strong,nonatomic) id<WebDataFetcherDelegate> delegate;

@end
