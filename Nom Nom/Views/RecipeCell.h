//
//  RecipeCell.h
//  Nom Nom
//
//  Created by Garrett Votaw on 3/10/18.
//  Copyright © 2018 Garrett Votaw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecipeCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) NSString *urlString;

@end
