//
//  LevelViewController.m
//  TEST_CubesGame
//
//  Created by AbsolutRenal on 01/08/2014.
//  Copyright (c) 2014 AbsolutRenal. All rights reserved.
//

#import "LevelViewController.h"
#import "LevelNumberView.h"
#import "UIColor+FlatUI.h"
#import "UIFont+FlatUI.h"

@interface LevelViewController (){
    int _currentLevel;
    int _nbLevels;
    int _lastLevel;
    
    int _maxRows;
    int _nbLevelByPage;
    int _startLevel;
    
    NSMutableArray *_levelButtons;
}

@property (strong, nonatomic)FUIButton *nextButton;
@property (strong, nonatomic)FUIButton *prevButton;

@end

@implementation LevelViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (instancetype)initWithCurrentLevel:(int)current withNbLevel:(int)nb withLastCompleted:(int)last{
    
    self = [super init];
    
    if(self){
        _currentLevel = current;
        _nbLevels = nb;
        _lastLevel = last;
        _maxRows = 4;
        _levelButtons = [[NSMutableArray alloc] init];
        _nbLevelByPage = 0;
    }
    
//    NSLog(@"current:%d, nb:%d, last:%d", current, nb, last);
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    NSLog(@"LEVELS NAMES:%@", self.levelNames);
    
    
}

- (void)clearLevelButtons{
    for (LevelNumberView *button in _levelButtons) {
        [button removeFromSuperview];
    }
    
    _levelButtons = [[NSMutableArray alloc] init];
}

- (void)showNextLevels:(id)sender{
//    NSLog(@"NEXT");
    _startLevel += _nbLevelByPage;
    [self populateFromLevel:_startLevel];
}

- (void)showPreviousLevels:(id)sender{
//    NSLog(@"PREVIOUS");
    _startLevel -= _nbLevelByPage;
    [self populateFromLevel:_startLevel];
}

- (void)configureView{
    self.nextButton = [[FUIButton alloc] init];
    [self.nextButton setTitle:@"NEXT >" forState:UIControlStateNormal];
    [self.nextButton setTitle:@"NEXT >" forState:UIControlStateHighlighted];
    self.nextButton.buttonColor = [UIColor turquoiseColor];
    self.nextButton.shadowColor = [UIColor greenSeaColor];
    self.nextButton.shadowHeight = 3.0f;
    self.nextButton.cornerRadius = 6.0f;
    self.nextButton.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    [self.nextButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [self.nextButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    self.nextButton.imageEdgeInsets = UIEdgeInsetsMake(-10, -10, -10, -10);
//    [self.nextButton.titleLabel sizeToFit];
    [self.nextButton sizeToFit];
    self.nextButton.frame = CGRectMake(self.view.frame.size.width - self.nextButton.frame.size.width - 20, self.view.frame.size.height - self.nextButton.frame.size.height - 20, self.nextButton.frame.size.width, self.nextButton.frame.size.height);
    [self.view addSubview:self.nextButton];
    [self.nextButton addTarget:self action:@selector(showNextLevels:) forControlEvents:UIControlEventTouchUpInside];
    
//    self.prevButton = [[FUIButton alloc] initWithFrame:CGRectMake(10, self.view.frame.size.height - 40, 70, 30)];
    self.prevButton = [[FUIButton alloc] init];
    [self.prevButton setTitle:@"< PREVIOUS" forState:UIControlStateNormal];
    [self.prevButton setTitle:@"< PREVIOUS" forState:UIControlStateHighlighted];
    self.prevButton.buttonColor = [UIColor turquoiseColor];
    self.prevButton.shadowColor = [UIColor greenSeaColor];
    self.prevButton.shadowHeight = 3.0f;
    self.prevButton.cornerRadius = 6.0f;
    self.prevButton.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    [self.prevButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [self.prevButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateHighlighted];
    self.prevButton.titleEdgeInsets = UIEdgeInsetsMake(-10, -10, -10, -10);
//    [self.prevButton.titleLabel sizeToFit];
    [self.prevButton sizeToFit];
    self.prevButton.frame = CGRectMake(20, self.view.frame.size.height - self.prevButton.frame.size.height - 20, self.prevButton.frame.size.width, self.prevButton.frame.size.height);
    [self.view addSubview:self.prevButton];
    [self.prevButton addTarget:self action:@selector(showPreviousLevels:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)populateFromLevel:(int)startLevel{
    [self clearLevelButtons];
    
    _startLevel = startLevel;
    if(startLevel == 0)
        self.prevButton.hidden = YES;
    else
        self.prevButton.hidden = NO;
    
    self.nextButton.hidden = YES;
    
    CGFloat w = 40.0;
    CGFloat h = 40.0;
    int minOffset = 20;
    double offset = 0.0;
    double startOffsetY = 0.0;
    LevelNumberView *level;
    int nbColumns = 0;
    int nbRows = 0;
    int currentRow;
    
    for (int i = startLevel; i < _nbLevels; i++) {
        if(i == startLevel){
            nbColumns = floor(self.view.bounds.size.width / ((w + minOffset) + minOffset));
            offset = (self.view.bounds.size.width - (w * nbColumns)) / (nbColumns +1);
            
            nbRows = floor(self.view.bounds.size.height / ((h + offset) + offset));
            startOffsetY = (self.view.bounds.size.height - (nbRows * (h + offset) - offset)) * .5;
//            NSLog(@"HEIGHT:%f / OFFSET_Y:%f", self.view.bounds.size.height, startOffsetY);
            
//            NSLog(@"NB COLUMNS:%d, NB ROWS:%d, OFFSET:%f", nbColumns, nbRows, offset);
        }
        
        currentRow = floor((i - startLevel) / nbColumns);
        
        if(currentRow >= nbRows){
            if(_nbLevelByPage == 0)
                _nbLevelByPage = i;
//            NSLog(@"NB:%d", _nbLevelByPage);
            
            self.nextButton.hidden = NO;
            return;
        }
        
//        NSLog(@"i:%d", i);
        
        level = [LevelNumberView presentInViewController:self];
        [_levelButtons addObject:level];
        level.frame = CGRectMake(offset + ((i - startLevel) % nbColumns) * (w + offset), startOffsetY + (currentRow * (h + offset)), w, h);
        
        if(i <= _lastLevel){
            [level.label setTitle:[NSString stringWithFormat:@"%d", i+1] forState:UIControlStateNormal];
            [level.label setTitle:[NSString stringWithFormat:@"%d", i+1] forState:UIControlStateHighlighted];
            
            if(i == _currentLevel){
                [level.label setTitleColor:[UIColor sunflowerColor] forState:UIControlStateNormal];
                [level.label setTitleColor:[UIColor sunflowerColor] forState:UIControlStateHighlighted];
            }
        } else {
            [level.label setTitle:@"." forState:UIControlStateNormal];
            [level.label setTitle:@"." forState:UIControlStateHighlighted];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    _startLevel = 0;
    [self configureView];
    [self populateFromLevel:_startLevel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)selectLevel:(int)nb{
    NSLog(@"SELECT LEVEL %d", nb);
    
    [self.delegate launchLevel:nb];
}

@end
