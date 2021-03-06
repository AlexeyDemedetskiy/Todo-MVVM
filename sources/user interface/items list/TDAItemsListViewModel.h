//
//  TDAItemsListViewModel.h
//  ToDo-MVVM
//
//  Created by Алексей Демедецкий on 14.07.15.
//  Copyright (c) 2015 DAloG. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TDANewItemViewModel;
@class TDAItemsList;
@interface TDAItemsListViewModel : NSObject

+ (instancetype)newWithItemList:(TDAItemsList*)itemList;

@property (nonatomic, readonly) NSArray* itemGroups;

@property (nonatomic) BOOL canEditItems;

- (TDANewItemViewModel*)viewModelForNewItem;

@end


@interface TDAItemsListGroupViewModel : NSObject

@property (nonatomic, readonly) NSString* title;
@property (nonatomic, readonly) NSArray* items;

@end

@interface TDAItemsListItemViewModel : NSObject

@property (nonatomic, readonly) BOOL isChecked;
@property (nonatomic, readonly) NSString* title;
@property (nonatomic, readonly) NSString* dueTitle;

- (void)select;

- (void)removeItem;

@end