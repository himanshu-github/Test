//
//  NSArray+FetchObject.m
//  NaukriGulf
//
//  Created by Arun Kumar on 20/12/13.
//  Copyright (c) 2013 Infoedge. All rights reserved.
//

#import "NSArray+FetchObject.h"

@implementation NSArray (FetchObject)

-(id)fetchObjectAtIndex:(NSInteger)index{
    @try {
        if (index < self.count) {
            return [self objectAtIndex:index];
        }
    }
    @catch (NSException *exception) {
        
        NSString *errorString = [NSString stringWithFormat:@"Fetching %ld index from %@ \n arr count : %lu",(long)index,self,(unsigned long)self.count];
        
       
        IENavigationController*navbAR = (IENavigationController*) APPDELEGATE.container.centerViewController;
        
        NSString *sourceString = [[NSThread callStackSymbols] objectAtIndex:1];
        NSCharacterSet *separatorSet = [NSCharacterSet characterSetWithCharactersInString:@" -[]+?.,"];
        NSMutableArray *array = [NSMutableArray arrayWithArray:[sourceString  componentsSeparatedByCharactersInSet:separatorSet]];
        [array removeObject:@""];
        
        [NGGoogleAnalytics sendExceptionWithDescription:[NSString stringWithFormat:@"NSArray Fetch Object Exception: %@ %@ %@ %@ %@",exception.name, exception.description,errorString,navbAR.topViewController, [NSString stringWithFormat:@"Trace %@ %@",[array objectAtIndex:3],[array objectAtIndex:4] ]] withIsFatal:YES];
        

    }
    
    return nil;
}

- (NSUInteger)indexOfCaseInsensitiveStringObject:(NSString*)paramObject{
    NSInteger itemCount = [self count];
    NSString *paramObjectLowercase = [paramObject lowercaseString];
    NSUInteger itemIndex = NSNotFound;
    for (NSInteger i=0; i<itemCount; i++) {
        if ([paramObjectLowercase isEqualToString:[self fetchObjectAtIndex:i]]) {
            itemIndex = i;
            break;
        }
    }
    return itemIndex;
}
@end
