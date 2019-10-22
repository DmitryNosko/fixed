//
//  SQLManagerConstants.m
//  RSSReader
//
//  Created by Dzmitry Noska on 10/4/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SQLManagerConstants.h"

NSString* const SQL_DATA_BASE_NAME = @"rssDataBase.db";
const char* SQL_CREATE_FEEDRESOURCE = "CREATE TABLE IF NOT EXISTS FeedResource (ID TEXT PRIMARY KEY, name TEXT, url TEXT)";
const char* SQL_CREATE_FEEDITEM = "CREATE TABLE IF NOT EXISTS FeedItem (ID TEXT PRIMARY KEY, itemTitle TEXT, link TEXT, pubDate DATETIME, itemDescription TEXT, enclousure TEXT, imageURL TEXT, isFavorite BOOL NOT NULL DEFAULT 0, isReadingInProgress BOOL NOT NULL DEFAULT 0, isReadingComplite BOOL NOT NULL DEFAULT 0, isAvailable BOOL NOT NULL DEFAULT 0, resourceURL TEXT, resourceID INTEGER, FOREIGN KEY (resourceID) REFERENCES FeedResource(id))";
