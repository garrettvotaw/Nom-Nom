//
//  RecipeViewController.h
//  Nom Nom
//
//  Created by Garrett Votaw on 3/12/18.
//  Copyright © 2018 Garrett Votaw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecipeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSString *recipeID;
@property (weak, nonatomic) IBOutlet UIImageView *recipeImageView;
@property (weak, nonatomic) IBOutlet UILabel *recipeName;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UITableView *ingredientsTableView;

@end
