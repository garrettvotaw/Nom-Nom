//
//  RecipeCell.m
//  Nom Nom
//
//  Created by Garrett Votaw on 3/10/18.
//  Copyright © 2018 Garrett Votaw. All rights reserved.
//

#import "RecipeCell.h"

@implementation RecipeCell

- (void)setUrlString:(NSString *)urlString {
    _urlString = urlString;
    [self downloadImageWithURL:urlString];
}

- (void)downloadImageWithURL:(NSString*)urlString {
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {

        NSData *data = [NSData dataWithContentsOfURL:location];
        UIImage *image = [UIImage imageWithData:data];

        dispatch_async(dispatch_get_main_queue(), ^{
            self.image.image = image;
        });

    }];
    [task resume];
}

@end
