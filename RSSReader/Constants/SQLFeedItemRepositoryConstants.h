//
//  SQLFeedItemRepositoryConstants.h
//  RSSReader
//
//  Created by Dzmitry Noska on 10/4/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#ifndef SQLFeedItemRepositoryConstants_h
#define SQLFeedItemRepositoryConstants_h

extern NSString* const INSERT_FEEDITEM;
extern NSString* const UPDATE_FEEDITEM;
extern NSString* const SELECT_FEEDITEM_BY_ID;
extern NSString* const SELECT_NON_COMPLITED_FEEDITEMS_BY_IDS;
extern NSString* const SELECT_ALL_FEEDITEMS_BY_IDS;
extern NSString* const SELECT_FAVORITE_FEEDITEM;
extern NSString* const SELECT_FAVORITE_FEEDITEM_URL;
extern NSString* const SELECT_READING_IN_PROGRESS_FEEDITEM_URL;
extern NSString* const SELECT_READING_COMPLITE_FEEDITEM_URL;
extern NSString* const DELETE_FEEDITEM;
extern NSString* const DELETE_FEEDITEM_BY_RESOURCE_ID;
extern const char* DELETE_ALL_FEEDITEMS;

#endif /* SQLFeedItemRepositoryConstants_h */
