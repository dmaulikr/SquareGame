//
//  MainViewController.m
//  TEST_CubesGame
//
//  Created by AbsolutRenal on 01/08/2014.
//  Copyright (c) 2014 AbsolutRenal. All rights reserved.
//

#import "MainViewController.h"
#import "LevelViewController.h"

@interface MainViewController (){
    BOOL _ready;
    NSString *_levelsFile;
    NSArray *_levelsDescription;
    NSDictionary *_colors;
    int _currentLevel;
    NSArray *_levelNames;
}

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSDictionary *tmpDict = [NSDictionary dictionaryWithContentsOfFile:[self levelsFile]];
    _levelsDescription = tmpDict[@"levels"];
    _colors = tmpDict[@"colors"];
    _currentLevel = [self lastLevel];
    
    [self openLevelsVC];
}

- (void)openLevelsVC{
    LevelViewController *levelsVC = [[LevelViewController alloc] initWithCurrentLevel:_currentLevel withNbLevel:(int)_levelsDescription.count withLastCompleted:_currentLevel];
    levelsVC.delegate = self;
    levelsVC.levelNames = [self levelNames];
    [self showViewController:levelsVC];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showViewController:(UIViewController *)child{
//    [child willMoveToParentViewController:self];
    
    child.view.frame = self.container.frame;
    child.view.alpha = 0;
    [self.container addSubview:child.view];
    [self addChildViewController:child];
    
    [UIView animateWithDuration:.6 animations:^{
        child.view.alpha = 1;
    } completion:^(BOOL finished) {
        _ready = YES;
    }];
    
    [child didMoveToParentViewController:self];
}

- (NSString *)levelsFile{
    if(!_levelsFile){
        _levelsFile = [[NSBundle mainBundle] pathForResource:@"levels" ofType:@"plist"];
    }
    return _levelsFile;
}

- (int)lastLevel{
    int nb = (int)_levelsDescription.count;
    int i;
    BOOL completed;
    
    for (i = 0; i < nb; i++) {
//        NSLog(@"i:%d, COMPLETED:%@", i, _levelsDescription[i][@"completed"]);
        completed = [_levelsDescription[i][@"completed"]  isEqual:@1];
        if(!completed){
            return i;
        }
    }
    return i;
}

- (NSArray *)levelNames{
    if(!_levelNames){
        NSMutableArray *levels = [[NSMutableArray alloc] initWithCapacity:_levelsDescription.count];
        int nb = (int)_levelsDescription.count;
        for (int i = 0; i < nb; i++) {
            levels[i] = _levelsDescription[i][@"name"];
        }
        
        _levelNames = [[NSArray alloc] initWithArray:levels];
    }
    
    return _levelNames;
}

- (void)launchLevel:(int)level{
    _currentLevel = level;
    
    
}

@end
