//
//  NGFilterViewController.h
//  NaukriGulf
//
//  Created by Arun Kumar on 20/06/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NGSecondLayer.h"
/**
 A delegate that informs about the filteration of jobs using clusters options.
 */
@protocol FilterDelegate <NSObject>

/**
 *  Inform delegate that filtering is done
 *
 *  @param resultDict  dictionary with results 
 *  @param slectedDict dictionary with selected clusters
 */

-(void) doneFiltering:(NSMutableDictionary *) resultDict withRowsSelected:(NSMutableDictionary *)slectedDict;

@end

/**
 *  The class filters searched results by selecting clusters options.
 Conforms the SecondLayerDelegate,UITableViewDataSource & UITableViewDelegate
 */

@interface NGFilterViewController : NGBaseViewController <UITableViewDelegate, UITableViewDataSource,SecondLayerDelegate>

/**
 *  Dictionary with list of Clusters and subclusters
 */

@property (strong, nonatomic) NSMutableDictionary *clusterDict;
@property (nonatomic, weak) id <FilterDelegate> filterDelegate;

/**
 *  Dictionary with information of search parameters/fields and selected clusters
 */
@property (strong, nonatomic) NSMutableDictionary *paramsDict;

/**
 *  lists selected clusters
 */
@property (strong, nonatomic) NSMutableDictionary *resultDict;

/**
 *  Reset/Uncheck all the selected clusters.
 */






-(void)resetAll;
-(void)updateFiltersList;
-(IBAction)gotoReset:(id)sender;
@end
