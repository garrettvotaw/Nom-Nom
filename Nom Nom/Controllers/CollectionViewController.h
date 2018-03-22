//
//  CollectionViewController.h
//  Nom Nom
//
//  Created by Garrett Votaw on 3/10/18.
//  Copyright © 2018 Garrett Votaw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecipeCell.h"
#import "Meal.h"

@interface CollectionViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate>
- (void)getJSON:(NSString*)query;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;


@end
