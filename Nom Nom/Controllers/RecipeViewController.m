//
//  RecipeViewController.m
//  Nom Nom
//
//  Created by Garrett Votaw on 3/12/18.
//  Copyright © 2018 Garrett Votaw. All rights reserved.
//

#import "RecipeViewController.h"
#import "Recipe.h"

@interface RecipeViewController ()
@property (strong, nonatomic) Recipe *recipe;
@end

@implementation RecipeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Recipe ID: %@", self.recipeID);
    [self getJSON];
    self.ingredientsTableView.delegate = self;
    self.ingredientsTableView.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getJSON {
    NSURLComponents *components = [[NSURLComponents alloc] initWithString:@"https://api.yummly.com/v1/api/recipe"];
    NSString *pathWithoutRecipeID = @"/v1/api/recipe/";
    components.path = [pathWithoutRecipeID stringByAppendingString:self.recipeID];
    NSURLQueryItem *appID = [[NSURLQueryItem alloc] initWithName:@"_app_id" value:@"03d6fe64"];
    NSURLQueryItem *appKey = [[NSURLQueryItem alloc] initWithName:@"_app_key" value:@"4d3a030938daf76d8eb2fbc37a76f97e"];
    NSArray *queryItems = @[appID, appKey];
    components.queryItems = queryItems;
    NSLog(@"URL: %@", components.URL);
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *task = [session dataTaskWithURL:components.URL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data != nil) {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSLog(@"JSON: %@", json);
            Recipe *recipe = [[Recipe alloc] init];
            recipe.name = json[@"name"];
            recipe.ingredientLines = json[@"ingredientLines"];
            recipe.totalTimeInSeconds = json[@"cookTime"];
            
            NSArray *imageURLArray = json[@"images"];
            NSDictionary *dict = imageURLArray[0];
            NSString *imageURLString = dict[@"hostedLargeUrl"];
            NSLog(@"%@",imageURLString);
            recipe.imageUrl = imageURLString;
            
            self.recipe = recipe;
            NSLog(@"%@", recipe.totalTimeInSeconds);
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self configureView];
            });
        };
    }];
    [task resume];
}

-(void)configureView {
    self.recipeName.text = self.recipe.name;
    [self.ingredientsTableView reloadData];
    if (self.recipe.totalTimeInSeconds != nil) {
        self.timeLabel.text = [NSString stringWithFormat:@"Cook Time: %@", self.recipe.totalTimeInSeconds];
    } else {
        self.timeLabel.text = @" ";
    }
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:self.recipe.imageUrl];
    NSURLSessionDownloadTask *task = [session downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSData *data = [NSData dataWithContentsOfURL:location];
        UIImage *image = [UIImage imageWithData:data];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.recipeImageView.image = image;
            NSLog(@"Error: %@", error);
        });
        
    }];
    [task resume];
    
    
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ingredientCell"];
    cell.textLabel.text = self.recipe.ingredientLines[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recipe.ingredientLines.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath; {
    return 35;
}


@end
