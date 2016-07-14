//
//  DataHandlerTool.h
//  Calaulator_Converter
//
//  Created by Weasley Qi on 16/7/14.
//  Copyright © 2016年 Weasley Qi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataHandlerTool : NSObject

+ (void)dataHandlerWithResponseString:(NSString *)respString;

+ (void)saveToDisk:(NSString *)respString;

+ (NSString *)getDataFromDisk;
@end
