//
//  SQLFeedResourceRepositoryConstants.m
//  RSSReader
//
//  Created by Dzmitry Noska on 10/4/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SQLFeedResourceRepositoryConstants.h"

NSString* const INSERT_FEEDRESOURCE_SQL = @"INSERT INTO FeedResource (ID, name, url) VALUES (\"%@\", \"%@\", \"%@\")";
NSString* const DELETE_FEEDRESOURCE_SQL = @"DELETE FROM FeedResource WHERE FeedResource.id = \"%@\"";
NSString* const SELECT_FEEDRESOURSE_BY_URL = @"SELECT fr.ID, fr.name, fr.url FROM FeedResource AS fr WHERE fr.url = \"%@\"";
const char* SELECT_FEEDRESOURCE_SQL = "SELECT ID, name, url FROM FeedResource";
