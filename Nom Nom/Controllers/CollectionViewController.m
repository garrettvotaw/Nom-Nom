//
//  CollectionViewController.m
//  Nom Nom
//
//  Created by Garrett Votaw on 3/10/18.
//  Copyright © 2018 Garrett Votaw. All rights reserved.
//

#import "CollectionViewController.h"

@interface CollectionViewController ()
@property (nonatomic, strong) NSArray *images;
@property (strong, nonatomic) NSArray *mealArrayTaco;
@end

@implementation CollectionViewController

static NSString * const reuseIdentifier = @"RecipeCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getJSON];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)getJSON {
    NSURL *url = [[NSURL alloc] initWithString:@"https://api.yummly.com/v1/api/recipes?_app_id=03d6fe64&_app_key=4d3a030938daf76d8eb2fbc37a76f97e&requirePictures=true&maxResult=50&start=0&q=pizza"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data != nil) {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSLog(@"%@", json);
            NSArray *mealArray = json[@"matches"];
            NSMutableArray *meals = [[NSMutableArray alloc] init];
            for (NSDictionary *meal in mealArray) {
                Meal *tastyMeal = [[Meal alloc] init];
                tastyMeal.name = meal[@"recipeName"];
                tastyMeal.recipeID = meal[@"id"];
                NSArray *imageURLs = meal[@"smallImageUrls"];
                tastyMeal.imageURL = [imageURLs objectAtIndex:0];
                [meals addObject:tastyMeal];
            };
            dispatch_sync(dispatch_get_main_queue(), ^{
                self.mealArrayTaco = meals;
                [self.collectionView reloadData];
            });
        };
    }];
    [task resume];
}


#pragma mark <UICollectionViewDataSource>
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RecipeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    Meal *meal = [self.mealArrayTaco objectAtIndex:indexPath.row];
    
    cell.label.text = meal.name;
    cell.urlString = meal.imageURL;
    // Configure the cell
    
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.mealArrayTaco.count;
}


#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
