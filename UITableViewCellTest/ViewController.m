//
//  ViewController.m
//  UITableViewCellTest
//
//  Created by Gareth Bestor on 8/04/16.
//  Copyright © 2016 Xiphware. All rights reserved.
//

#import "ViewController.h"

// ENABLE OR DISABLE THESE COMPILER DIRECTIVES TO TRY DIFFERENT PERMUTATIONS
#define USESTYLESPECIFICSUBCLASSES // otherwise use generic UITableViewCell for everything
#define USESTYLESPECIFICIDS // otherwise use generic "Cell" reuseIdentifier [USESTYLESPECIFICSUBCLASSES implies USESTYLESPECIFICIDS]
#define DEQUEUECELLS // otherwise re-alloc new cell every time
#define USENUMBEROFLINESZERO // use numberOfLines=0 if more than 1 line, otherwise numberOfLines = actual number of lines

#ifdef USESTYLESPECIFICSUBCLASSES
@interface UITableViewCellDefault : UITableViewCell
@end
@implementation UITableViewCellDefault
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    return [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
}
@end

@interface UITableViewCellValue1 : UITableViewCell
@end
@implementation UITableViewCellValue1
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    return [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
}
@end

@interface UITableViewCellValue2 : UITableViewCell
@end
@implementation UITableViewCellValue2
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    return [super initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:reuseIdentifier];
}
@end

@interface UITableViewCellSubtitle : UITableViewCell
@end
@implementation UITableViewCellSubtitle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    return [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
}
@end
#endif

@implementation ViewController

NSInteger linesOfText = 1;
NSInteger linesOfDetail = 1;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.;
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem.alloc initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                        target:self
                                                                                        action:@selector(addText)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem.alloc initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                         target:self
                                                                                         action:@selector(addDetail)];

#ifdef DEQUEUECELLS
 #ifdef USESTYLESPECIFICSUBCLASSES
    [self.tableView registerClass:UITableViewCellDefault.class forCellReuseIdentifier:@"DefaultCell"];
    [self.tableView registerClass:UITableViewCellValue1.class forCellReuseIdentifier:@"Value1Cell"];
    [self.tableView registerClass:UITableViewCellValue2.class forCellReuseIdentifier:@"Value2Cell"];
    [self.tableView registerClass:UITableViewCellSubtitle.class forCellReuseIdentifier:@"SubtitleCell"];
 #elif defined(USESTYLESPECIFICIDS)
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"DefaultCell"];
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"Value1Cell"];
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"Value2Cell"];
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"SubtitleCell"];
 #else
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"Cell"];
 #endif
#endif
    
    UILabel *header = UILabel.new;
#ifdef USESTYLESPECIFICSUBCLASSES
    header.text = @"SUBCLASS=Y ";
#elif defined(USESTYLESPECIFICIDS)
    header.text = @"STYLEID=Y ";
#else
    header.text = @"STYLEID=N ";
#endif
#ifdef DEQUEUECELLS
    header.text = [header.text stringByAppendingString:@"DEQUEUE=Y "];
#else
    header.text = [header.text stringByAppendingString:@"DEQUEUE=N "];
#endif
#ifdef USENUMBEROFLINESZERO
    header.text = [header.text stringByAppendingString:@"NOL0=Y"];
#else
    header.text = [header.text stringByAppendingString:@"NOL0=N"];
#endif
    header.textAlignment = NSTextAlignmentCenter;
    header.textColor = UIColor.redColor;
    [header sizeToFit];
    self.tableView.tableHeaderView = header;
}

- (void)addText
{
    linesOfText++;
    [self.tableView reloadData];
}

- (void)addDetail
{
    linesOfDetail++;
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    self.title = [NSString stringWithFormat:@"Text=%ld : Detail=%ld", linesOfText, linesOfDetail];
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier = nil;
    
#ifdef DEQUEUECELLS
 #if defined(USESTYLESPECIFICSUBCLASSES) || defined(USESTYLESPECIFICIDS)
    switch (indexPath.section) {
        case 1: reuseIdentifier = @"Value1Cell"; break;
        case 2: reuseIdentifier = @"Value2Cell"; break;
        case 3: reuseIdentifier = @"SubtitleCell"; break;
        default: reuseIdentifier = @"DefaultCell"; // 0
    }
 #else
    reuseIdentifier = @"Cell";
 #endif
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier]; // init'd with [cell initWithStyle:UITableViewCellStyleDefault ...]
#else
    UITableViewCell *cell;
 #ifdef USESTYLESPECIFICSUBCLASSES
    switch (indexPath.section) {
        case 1: cell = UITableViewCellValue1.alloc; break;
        case 2: cell = UITableViewCellValue2.alloc; break;
        case 3: cell = UITableViewCellSubtitle.alloc; break;
        default: cell = UITableViewCellDefault.alloc; // 0
    }
 #else
    cell = UITableViewCell.alloc;
 #endif
#endif
    
    switch (indexPath.section) {
        case 1: cell = [cell initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier]; break;
        case 2: cell = [cell initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:reuseIdentifier]; break;
        case 3: cell = [cell initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier]; break;
        default: cell = [cell initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]; // 0
    }

    cell.textLabel.text = @"Text1";
    for (int i=2; i<=linesOfText; i++)
        cell.textLabel.text = [cell.textLabel.text stringByAppendingFormat:@"\nText%d",i];
    cell.detailTextLabel.text = @"Detail1";
    for (int i=2; i<=linesOfDetail; i++)
        cell.detailTextLabel.text = [cell.detailTextLabel.text stringByAppendingFormat:@"\nDetail%d",i];

    cell.textLabel.numberOfLines = linesOfText;
    cell.detailTextLabel.numberOfLines = linesOfDetail;
#ifdef USENUMBEROFLINESZERO
    if (linesOfText > 1) cell.textLabel.numberOfLines = 0;
    if (linesOfDetail > 1) cell.detailTextLabel.numberOfLines = 0;
#endif
                        
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 1: return @"Value1";
        case 2: return @"Value2";
        case 3: return @"Subtitle";
        default: return @"Default"; // 0
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@ cell height = %.2f", [self tableView:tableView titleForHeaderInSection:indexPath.section], CGRectGetHeight(cell.frame));
}

@end
