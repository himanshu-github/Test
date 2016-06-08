//
//  NSString+RemoveAllSpaces.m
//  Naukri
//
//  Created by Arun Kumar on 3/20/14.
//  Copyright (c) 2014 Infoedge. All rights reserved.
//

#import "NSString+Extra.h"
NSString * const USER_PROFILE_PHOTO_NAME = @"profilePhoto.png";


@implementation NSString (Extra)

- (NSString *)stringByCompressingWhitespaceTo:(NSString *)seperator
{
	NSArray *comps = [self componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	NSMutableArray *nonemptyComps = [[NSMutableArray alloc] init] ;
    
	// only copy non-empty entries
	for (NSString *oneComp in comps)
	{
		if (![oneComp isEqualToString:@""])
		{
			[nonemptyComps addObject:oneComp];
		}
        
	}
    
	return [nonemptyComps componentsJoinedByString:seperator];  
}

+ (NSString *)encodeSpecialCharacter:(NSString *)parameterValue
{
    
    NSMutableString *tempstr = [NSMutableString stringWithString:parameterValue];
    
    [tempstr replaceOccurrencesOfString:@"%" withString:@"%25" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [tempstr length])];
    
    [tempstr replaceOccurrencesOfString:@"&" withString:@"%26" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [tempstr length])];
    
    [tempstr replaceOccurrencesOfString:@"$" withString:@"%24" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [tempstr length])];
    
    [tempstr replaceOccurrencesOfString:@"&" withString:@"%26" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [tempstr length])];
    
    [tempstr replaceOccurrencesOfString:@"+" withString:@"%2B" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [tempstr length])];
    
    [tempstr replaceOccurrencesOfString:@"," withString:@"%2C" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [tempstr length])];
    
    [tempstr replaceOccurrencesOfString:@"/" withString:@"%2F" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [tempstr length])];
    
    [tempstr replaceOccurrencesOfString:@":" withString:@"%3A" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [tempstr length])];
    
    [tempstr replaceOccurrencesOfString:@";" withString:@"%3B" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [tempstr length])];
    
    [tempstr replaceOccurrencesOfString:@"=" withString:@"%3D" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [tempstr length])];
    
    [tempstr replaceOccurrencesOfString:@"?" withString:@"%3F" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [tempstr length])];
    
    [tempstr replaceOccurrencesOfString:@"@" withString:@"%40" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [tempstr length])];
    
    [tempstr replaceOccurrencesOfString:@" " withString:@"%20" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [tempstr length])];
    
    [tempstr replaceOccurrencesOfString:@"\t" withString:@"%09" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [tempstr length])];
    
    [tempstr replaceOccurrencesOfString:@"#" withString:@"%23" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [tempstr length])];
    
    [tempstr replaceOccurrencesOfString:@"<" withString:@"%3C" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [tempstr length])];
    
    [tempstr replaceOccurrencesOfString:@">" withString:@"%3E" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [tempstr length])];
    
    [tempstr replaceOccurrencesOfString:@"\"" withString:@"%22" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [tempstr length])];
    
    [tempstr replaceOccurrencesOfString:@"\n" withString:@"%0A" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [tempstr length])];
    
    [tempstr replaceOccurrencesOfString:@"(" withString:@"%28" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [tempstr length])];
    
    [tempstr replaceOccurrencesOfString:@")" withString:@"%29" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [tempstr length])];
    
    [tempstr replaceOccurrencesOfString:@"[" withString:@"%5B" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [tempstr length])];
    
    [tempstr replaceOccurrencesOfString:@"]" withString:@"%5D" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [tempstr length])];
    
    [tempstr replaceOccurrencesOfString:@"{" withString:@"%7B" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [tempstr length])];
    
    [tempstr replaceOccurrencesOfString:@"}" withString:@"%7D" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [tempstr length])];
    
    [tempstr replaceOccurrencesOfString:@"^" withString:@"%5E" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [tempstr length])];
    
    [tempstr replaceOccurrencesOfString:@"'" withString:@"%27" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [tempstr length])];
    
    [tempstr replaceOccurrencesOfString:@"|" withString:@"%7C" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [tempstr length])];
    
    [tempstr replaceOccurrencesOfString:@"~" withString:@"%7E" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [tempstr length])];
    
    [tempstr replaceOccurrencesOfString:@"`" withString:@"%60" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [tempstr length])];
    
    [tempstr replaceOccurrencesOfString:@"\\" withString:@"%5C" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [tempstr length])];
    
    
    return (NSString *)tempstr;
    
}

+ (NSString*)convertTimestampToDate:(NSString*)timestamp{
    NSString * timeStampString =timestamp;
    NSTimeInterval _interval=[timeStampString doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    return [NGDateManager stringFromDate:date WithStyle:NSDateFormatterLongStyle];
}

+ (NSString*)getStringsFromArray:(NSArray*)arr{
    NSMutableString *str = [NSMutableString string];
    
    [str appendString:@""];
    
    if (arr.count>0) {
        [str appendString:[arr fetchObjectAtIndex:0]];
    }
    
    for (NSInteger i = 1; i<arr.count; i++) {
        [str appendFormat:@", %@",[arr fetchObjectAtIndex:i]];
    }
    
    return str;
}

+ (NSString*)getStringsFromArrayWithoutSpace:(NSArray*)arr{
    NSMutableString *str = [NSMutableString string];
    
    [str appendString:@""];
    
    if (arr.count>0) {
        
        id obj = [arr fetchObjectAtIndex:0];
        
        if ([obj isKindOfClass:[NSNumber class]]) {
            obj = (NSNumber*)obj;
            [str appendString:[NSString stringWithFormat:@"%d",[obj intValue]]];
        }else
            [str appendString:obj];
    }
    
    for (NSInteger i = 1; i<arr.count; i++) {
        [str appendFormat:@",%@",[arr fetchObjectAtIndex:i]];
    }
    
    return str;
}


+ (NSString *) formatSpecialCharacters:(NSString *)string
{
    NSCharacterSet * invalidNumberSet = [NSCharacterSet characterSetWithCharactersInString:@"£¥€•"];
    
    NSString  * result  = @"";
    NSScanner * scanner = [NSScanner scannerWithString:string];
    NSString  * scannerResult;
    
    [scanner setCharactersToBeSkipped:nil];
    
    while (![scanner isAtEnd])
    {
        if([scanner scanUpToCharactersFromSet:invalidNumberSet intoString:&scannerResult])
        {
            result = [result stringByAppendingString:scannerResult];
        }
        else
        {
            if(![scanner isAtEnd])
            {
                [scanner setScanLocation:[scanner scanLocation]+1];
            }
        }
    }
    
    return result;
}

+ (NSString *)getFormattedMobile:(NSString *)mobileStr{
    NSString *str = @"";
    NSArray *arr = [mobileStr componentsSeparatedByString:@"+"];
    NSString *first = [arr fetchObjectAtIndex:0];
    NSRange range = NSMakeRange(first.length+2, mobileStr.length-first.length-2);
    
    str = [mobileStr stringByReplacingOccurrencesOfString:@"+" withString:@"" options:0 range:range];
    
    str = [str stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    str = [NSString stringWithFormat:@"+%@",str];
    
    return str;
}

+ (NSString *)getFormattedTelephone:(NSString *)telephoneStr{
    NSString *str = @"";
    str = telephoneStr;
    
    return str;
}
+ (NSString *)tripWhiteSpace:(NSString *)str{
    NSString *trimmedStr = @"";
    
    trimmedStr = [str trimCharctersInSet :
                  [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return trimmedStr;
}
+ (NSString*)parseExperience:(NSString *)expStr{
    NSString *finalStr = @"";
    
    NSArray *expArr = [expStr componentsSeparatedByString:@"."];
    
    if (expArr.count==2) {
        finalStr = [NSString stringWithFormat:@"%@ Years %@ Months",[expArr fetchObjectAtIndex:0],[expArr fetchObjectAtIndex:1]];
    }else{
        finalStr = [NSString stringWithFormat:@"%@ Years",[expArr fetchObjectAtIndex:0]];
    }
    
    return finalStr;
}

+ (NSString *)getLabelForID:(NSString *)ID inList:(NSArray *)arr{
    NSString *label = @"";
    
    for (DDBase* obj in arr) {
        if ([ID isEqualToString:[NSString stringWithFormat:@"%d", obj.valueID.intValue]]) {
            label = obj.valueName;
        }
    }
    return label;
}

+ (NSString*)removeCommaFromString:(NSString*)string
{
    //Removing ',' from keywords fields (if exists)
    
    if (string.length>2)
    {
        unichar ch = [string characterAtIndex:string.length-2];
        
        if (ch == ',')
        {
            NSRange range = NSMakeRange(string.length-2, 1);
            string = [string stringByReplacingCharactersInRange:range withString:@""];
        }
        else
        {
            unichar ch = [string characterAtIndex:string.length-1];
            if (ch == ',')
            {
                NSRange range = NSMakeRange(string.length-1, 1);
                string = [string stringByReplacingCharactersInRange:range withString:@""];
            }
        }
    }
    return string;
}



+ (NSString *)stripTags:(NSString *)str
{
    if (str && [str isKindOfClass:[NSString class]]) {
        NSMutableString *newString = [NSMutableString stringWithString:str];
        [newString replaceOccurrencesOfString:@"<" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, newString.length)];
        [newString replaceOccurrencesOfString:@">" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, newString.length)];
        
        return newString;
        
    }
    
    return str;
}
+ (NSString *)stripHTMLTagWithItsValue:(NSString *)str{
    //NOTE:This method removes html tag with all date in it
    //Eg: "hi, this is example <tag />
    //Result: "hi, this is example"
    
    NSMutableString *html = [NSMutableString stringWithCapacity:[str length]];
    
    NSScanner *scanner = [NSScanner scannerWithString:str];
    scanner.charactersToBeSkipped = NULL;
    NSString *tempText = nil;
    
    while (![scanner isAtEnd])
    {
        [scanner scanUpToString:@"<" intoString:&tempText];
        
        if (tempText != nil)
            [html appendString:tempText];
        
        [scanner scanUpToString:@">" intoString:NULL];
        
        if (![scanner isAtEnd])
            [scanner setScanLocation:[scanner scanLocation] + 1];
        
        tempText = nil;
    }
    
    return html;
}

+ (NSString *)getUniqueDeviceIdentifier {
    NSString *systemId = nil;
    // We collect it as long as it is available along with a randomly generated ID.
    // This way, when this becomes unavailable we can map existing users so the
    // new vs returning counts do not break.
    
    systemId = @"ide";//[NSUUID UUID];
    
    return systemId;
}

+ (NSString *)getFilteredText :(NSString*) txt{
    
    if (txt) {
        txt = [NSString stripTags:txt];
        txt = [NSString formatSpecialCharacters:txt];
    }else{
        txt = @"";
    }
    
    return txt;
}
+ (NSString*) stripWhiteSpaceFromBeginning : (NSString*) str {
    NSString *trimmedStr = @"";
    
    trimmedStr = [str trimCharctersInSet :
                  [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return trimmedStr;
    
}


+ (NSString *)getProfilePhotoPath{
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) fetchObjectAtIndex:0];
    NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@",docDir,USER_PROFILE_PHOTO_NAME];
    
    return pngFilePath;
}

+ (NSString *)getAppVersion{
    
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    
}

+(NSString *)getRequestMethodNameWithType:(NSInteger)type{
    NSString *name = @"POST";
    
    NSArray *arr = [NSArray arrayWithObjects:@"GET",@"POST",@"DELETE",@"PATCH",@"PUT", nil];
    
    if (type>=0 && type<arr.count) {
        name = [arr fetchObjectAtIndex:type];
    }
    
    return name;
}

- (NSString*)trimCharctersInSet:(NSCharacterSet*)set{
    
    return [self stringByTrimmingCharactersInSet:set];
}
-(NSDictionary *)JSONValue{
    NSError *error = nil;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    
    if (error) {
        return nil;
    }
    return jsonDict;
}


-(NSString*)stringByTrimmingLeadingWhitespace {
    NSInteger i = 0;
    
    while ((i < [self length])
           && [[NSCharacterSet whitespaceCharacterSet] characterIsMember:[self characterAtIndex:i]]) {
        i++;
    }
    return [self substringFromIndex:i];
}

@end
