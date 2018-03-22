//
//  CollectionViewController.m
//  Nom Nom
//
//  Created by Garrett Votaw on 3/10/18.
//  Copyright © 2018 Garrett Votaw. All rights reserved.
//

#import "CollectionViewController.h"
#import "RecipeViewController.h"

@interface CollectionViewController ()
@property (nonatomic, strong) NSArray *images;
@property (strong, nonatomic) NSArray *mealArray;
@property (strong, nonatomic) Meal *selectedMeal;
@end

@implementation CollectionViewController

static NSString * const reuseIdentifier = @"RecipeCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getJSON: @"Pizza"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    RecipeViewController *vc = [segue destinationViewController];
    // Pass the selected object to the new view controller.
    vc.recipeID = self.selectedMeal.recipeID;
}



- (void)getJSON:(NSString*)query {
    //NSURL *url = [[NSURL alloc] initWithString:@"https://api.yummly.com/v1/api/recipes?_app_id=03d6fe64&_app_key=4d3a030938daf76d8eb2fbc37a76f97e&requirePictures=true&maxResult=50&start=0&q=pizza"];
    NSString *urlString = @"https://api.yummly.com";
    NSURLComponents *components = [[NSURLComponents alloc] initWithString:urlString];
    components.path = @"/v1/api/recipes";
    components.queryItems = @[[[NSURLQueryItem alloc] initWithName:@"_app_id" value:@"03d6fe64"], [[NSURLQueryItem alloc] initWithName:@"_app_key" value:@"4d3a030938daf76d8eb2fbc37a76f97e"],
        [[NSURLQueryItem alloc] initWithName:@"q" value:query],
        [[NSURLQueryItem alloc] initWithName:@"requirePictures" value:@"true"],
        [[NSURLQueryItem alloc] initWithName:@"maxResult" value:@"50"]];
    NSLog(@"%@", components.URL);
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithURL:components.URL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"%@", error);
        NSLog(@"%@", response);
        if (data != nil) {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
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
                self.mealArray = meals;
                [self.collectionView reloadData];
            });
        }
    }];
    [task resume];
}


#pragma mark <UICollectionViewDataSource>
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RecipeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    Meal *meal = [self.mealArray objectAtIndex:indexPath.row];
    NSLog(@"%@", self.selectedMeal);
    cell.label.text = meal.name;
    cell.urlString = meal.imageURL;
    // Configure the cell
    
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.mealArray.count;
}


#pragma mark <UICollectionViewDelegate>

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Meal *meal = [self.mealArray objectAtIndex:indexPath.row];
    self.selectedMeal = meal;
    [self performSegueWithIdentifier:@"showDetail" sender:nil];
}



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
