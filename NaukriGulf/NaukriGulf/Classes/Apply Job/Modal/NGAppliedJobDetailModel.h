//
//  NGAppliedJobDetailModel.h
//  NaukriGulf
//
//  Created by Swati Kaushik on 30/06/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//


@protocol NGAppliedJobDetails

@end
@interface NGAppliedJobDetails : NGJobDetails
@end
@interface NGAppliedJobDetailModel : JSONModel
@property (nonatomic,strong) NSMutableArray<NGAppliedJobDetails> *jobList;
@property (nonatomic) NSInteger totoalJobsCount;
@end
