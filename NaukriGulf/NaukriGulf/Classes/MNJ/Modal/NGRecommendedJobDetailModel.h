//
//  NGRecommendedJobDetailModel.h
//  NaukriGulf
//
//  Created by bazinga on 13/07/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

@protocol NGRecommendedJobDetails

@end

@interface NGRecommendedJobDetails : NGJobDetails
@end

@interface NGRecommendedJobDetailModel : JSONModel
@property (nonatomic,strong) NSMutableArray<NGRecommendedJobDetails> *jobList;

@property (nonatomic) NSInteger totoalJobsCount;
@property (nonatomic) NSInteger newJobsCount;
@end
