//
//  Recipe.h
//  Nom Nom
//
//  Created by Garrett Votaw on 3/12/18.
//  Copyright © 2018 Garrett Votaw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Recipe : NSObject
@property (nonatomic, strong) NSMutableArray *ingredientLines;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *totalTimeInSeconds;
@property (nonatomic, strong) NSString *imageUrl;
@end
