//
//  TDAItemsListViewController.m
//  ToDo-MVVM
//
//  Created by Алексей Демедецкий on 10.07.15.
//  Copyright (c) 2015 DAloG. All rights reserved.
//

#import "TDAItemsListViewController.h"
#import "TDAItemsListViewModel.h"

#import "TDANewItemViewController.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
@interface TDAItemsListViewController ()

@end

@interface TDAItemsListItemCell : UITableViewCell

@property (nonatomic, strong) TDAItemsListItemViewModel* viewModel;

@end

@implementation TDAItemsListItemCell

- (void)prepareForReuse
{
    self.viewModel = nil;
}

- (void)setupBindings
{
    RAC(self, textLabel.text) = RACObserve(self, viewModel.title);
    RAC(self, detailTextLabel.text) = RACObserve(self, viewModel.dueTitle);
    RAC(self, imageView.hidden) = [[RACObserve(self, viewModel.isChecked) ignore:nil] not];
}

- (void)awakeFromNib
{
    [self setupBindings];
    [super awakeFromNib];
}

@end

@interface TDAItemsListViewController ()

@property (nonatomic) IBOutlet UIBarButtonItem* editItem;
@property (nonatomic) IBOutlet UIBarButtonItem* doneItem;

@end

@implementation TDAItemsListViewController

- (IBAction)editItems:(UIBarButtonItem*)item
{
    [self.tableView setEditing:YES animated:YES];
    [self.navigationItem setLeftBarButtonItem:self.doneItem animated:YES];
}

- (IBAction)doneEditing:(UIBarButtonItem*)item
{
    [self.tableView setEditing:NO animated:YES];
    [self.navigationItem setLeftBarButtonItem:self.editItem animated:YES];
}

- (void)viewDidLoad
{
    [self.tableView rac_liftSelector:@selector(reloadData)
               withSignalOfArguments:[RACObserve(self, viewModel.itemGroups) mapReplace:[RACTuple new]]];
    
    [self.navigationItem setLeftBarButtonItem:self.editItem animated:NO];
    
    RAC(self, editItem.enabled, @NO) = RACObserve(self, viewModel.canEditItems);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.viewModel.itemGroups.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    TDAItemsListGroupViewModel* group = self.viewModel.itemGroups[section];
    return group.title;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    TDAItemsListGroupViewModel* group = self.viewModel.itemGroups[section];
    return group.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TDAItemsListGroupViewModel* group = self.viewModel.itemGroups[indexPath.section];
    TDAItemsListItemViewModel* item = group.items[indexPath.row];
    
    TDAItemsListItemCell* cell = [tableView dequeueReusableCellWithIdentifier:@"com.itemslist.cell" forIndexPath:indexPath];
    cell.viewModel = item;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TDAItemsListGroupViewModel* group = self.viewModel.itemGroups[indexPath.section];
    TDAItemsListItemViewModel* item = group.items[indexPath.row];
    
    if (tableView.editing) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    else {
        [item select];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    TDAItemsListGroupViewModel* group = self.viewModel.itemGroups[indexPath.section];
    TDAItemsListItemViewModel* item = group.items[indexPath.row];
    
    [item removeItem];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"add new item"]) {
        UINavigationController* n = segue.destinationViewController;
        TDANewItemViewController* newItemVC = n.viewControllers.firstObject;
        newItemVC.viewModel = [self.viewModel viewModelForNewItem];
    }
}

@end
