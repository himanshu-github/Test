//
//  NSString+RemoveAllSpaces.h
//  Naukri
//
//  Created by Arun Kumar on 3/20/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extra)

+ (NSString *)encodeSpecialCharacter:(NSString *)parameterValue;
+(NSString*)convertTimestampToDate:(NSString*)timestamp;
+(NSString*)getStringsFromArray:(NSArray*)arr;
+(NSString*)getStringsFromArrayWithoutSpace:(NSArray*)arr;
+(NSString *) formatSpecialCharacters:(NSString *)string;
+(NSString *)getFormattedMobile:(NSString *)mobileStr;
+(NSString *)getFormattedTelephone:(NSString *)telephoneStr;
+(NSString*) stripWhiteSpaceFromBeginning : (NSString*) str;
+(NSString*)parseExperience:(NSString *)expStr;
+(NSString *)getLabelForID:(NSString *)ID inList:(NSArray *)arr;
+(NSString*)removeCommaFromString:(NSString*)string;
+(NSString *)stripTags:(NSString *)str;
+ (NSString *)stripHTMLTagWithItsValue:(NSString *)str;
+(NSString *)getUniqueDeviceIdentifier;
+(NSString *)getFilteredText :(NSString*) txt;
+(NSString *)tripWhiteSpace:(NSString *)str;
+(NSString *)getProfilePhotoPath;
+(NSString *)getAppVersion;
+ (NSString *)getRequestMethodNameWithType:(NSInteger)type;

-(NSDictionary *)JSONValue;
-(NSString *)stringByCompressingWhitespaceTo:(NSString *)seperator;
-(NSString*)trimCharctersInSet:(NSCharacterSet*)set;
-(NSString*)stringByTrimmingLeadingWhitespace;

@end
