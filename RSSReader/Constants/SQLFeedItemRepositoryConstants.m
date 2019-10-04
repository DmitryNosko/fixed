//
//  SQLFeedItemRepositoryConstants.m
//  RSSReader
//
//  Created by Dzmitry Noska on 10/4/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SQLFeedItemRepositoryConstants.h"
NSString* const INSERT_FEEDITEM = @"INSERT INTO FeedItem (ID, itemTitle, link, pubDate, itemDescription, enclousure, imageURL, isFavorite, isReadingInProgress, isReadingComplite, isAvailable, resourceURL, resourceID) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\")";
NSString* const UPDATE_FEEDITEM = @"UPDATE FeedItem SET isFavorite = \"%@\", isReadingInProgress = \"%@\", isReadingComplite = \"%@\", isAvailable = \"%@\" WHERE ID = \"%@\"";

NSString* const SELECT_FEEDITEM_BY_ID = @"SELECT fi.ID, fi.itemTitle, fi.link, fi.pubDate, fi.itemDescription, fi.enclousure, fi.imageURL, fi.isFavorite, fi.isReadingInProgress, fi.isReadingComplite, fi.isAvailable, fi.resourceURL, fr.ID, fr.name, fr.url FROM FeedItem AS fi JOIN FeedResource AS fr ON fi.resourceID = fr.ID WHERE fi.resourceID = \"%@\" AND fi.isReadingComplite = 0 ORDER BY fi.pubDate DESC";

NSString* const SELECT_NON_COMPLITED_FEEDITEMS_BY_IDS = @"SELECT fi.ID, fi.itemTitle, fi.link, fi.pubDate, fi.itemDescription, fi.enclousure, fi.imageURL, fi.isFavorite, fi.isReadingInProgress, fi.isReadingComplite, fi.isAvailable, fi.resourceURL, fr.ID, fr.name, fr.url FROM FeedItem AS fi JOIN FeedResource AS fr ON fi.resourceID = fr.ID WHERE fi.resourceID IN (%@) AND fi.isReadingComplite = 0 ORDER BY fi.pubDate DESC";

NSString* const SELECT_ALL_FEEDITEMS_BY_IDS = @"SELECT fi.ID, fi.itemTitle, fi.link, fi.pubDate, fi.itemDescription, fi.enclousure, fi.imageURL, fi.isFavorite, fi.isReadingInProgress, fi.isReadingComplite, fi.isAvailable, fi.resourceURL, fr.ID, fr.name, fr.url FROM FeedItem AS fi JOIN FeedResource AS fr ON fi.resourceID = fr.ID WHERE fi.resourceID IN (%@)";

NSString* const SELECT_FAVORITE_FEEDITEM = @"SELECT fi.ID, fi.itemTitle, fi.link, fi.pubDate, fi.itemDescription, fi.enclousure, fi.imageURL, fi.isFavorite, fi.isReadingInProgress, fi.isReadingComplite, fi.isAvailable, fi.resourceURL FROM FeedItem AS fi WHERE fi.resourceID IN (%@) AND fi.isFavorite = 1;";

NSString* const SELECT_FAVORITE_FEEDITEM_URL = @"SELECT fi.link FROM FeedItem AS fi WHERE fi.resourceID IN (%@) AND fi.isFavorite = 1";

NSString* const SELECT_READING_IN_PROGRESS_FEEDITEM_URL = @"SELECT fi.link FROM FeedItem AS fi WHERE fi.resourceID IN (%@) AND fi.isReadingInProgress = 1 AND fi.isReadingComplite = 0";

NSString* const SELECT_READING_COMPLITE_FEEDITEM_URL = @"SELECT fi.link FROM FeedItem AS fi WHERE fi.resourceID IN (%@) AND fi.isReadingComplite = 1";

NSString* const DELETE_FEEDITEM = @"DELETE FROM FeedItem WHERE FeedItem.id = \"%@\"";

NSString* const DELETE_FEEDITEM_BY_RESOURCE_ID = @"DELETE FROM FeedItem WHERE FeedItem.resourceID = \"%@\"";

const char* DELETE_ALL_FEEDITEMS = "DELETE FROM FeedItem";
