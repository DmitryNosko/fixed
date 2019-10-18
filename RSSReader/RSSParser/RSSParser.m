//
//  RSSParser.m
//  RSSReader
//
//  Created by Dzmitry Noska on 8/30/19.
//  Copyright © 2019 Dzmitry Noska. All rights reserved.
//

#import "RSSParser.h"
#import <UIKit/UIKit.h>
#import "RSSParserConstants.h"
#import "NSString+NSStringDateCategory.h"

@interface RSSParser () <NSXMLParserDelegate>
@property (strong, nonatomic) NSString* element;
@property (strong, nonatomic) FeedItem* feedItem;
@property (strong, nonatomic) NSXMLParser* parser;
@property (strong, nonatomic) NSURL* resourceURL;
@end

@implementation RSSParser

#pragma mark - ParserMethods

- (void) rssParseWithURL:(NSURL*) url {
    self.resourceURL = url;
    
    self.parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    [self.parser setDelegate:self];
    [self.parser setShouldResolveExternalEntities:NO];
    
    UIApplication* app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = YES;
    
    __weak RSSParser* weakSelf = self;
    NSThread* thread = [[NSThread alloc] initWithBlock:^{
        [weakSelf.parser parse];
    }];
    [thread start];
}

#pragma mark - NSXMLParserDelegate

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict {
    
    self.element = elementName;
    if ([self.element isEqualToString:RSS_TAG]) {
        self.feedItem = [[FeedItem alloc] init];
    }
    if ([self.element isEqualToString:ITEM_TAG]) {
        self.feedItem = [[FeedItem alloc] init];
    } else if ([self.element isEqualToString:ENCLOUSURE_TAG]) {
        self.feedItem.imageURL = [attributeDict objectForKey:URL_TAG];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:ITEM_TAG]) {
        if (self.feedItem != nil) {
            self.feedItem.itemDescription = [self.feedItem correctDescription:self.feedItem.itemDescription];
            self.feedItem.resourceURL = self.resourceURL;
            self.feedItemDownloadedHandler(self.feedItem);
        }
        self.feedItem = nil;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    NSString *trimmed = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (![trimmed isEqualToString:END_OF_STRING]) {
        if ([self.element isEqualToString:TITLE_TAG]) {
            self.feedItem.itemTitle = string;
        } else if ([self.element isEqualToString:LINK_TAG]) {
            [self.feedItem.link appendString:string];
        } else if ([self.element isEqualToString:PUBDATE_TAG]) {
            self.feedItem.pubDate = [string toDate];
        } else if ([self.element isEqualToString:DESCRIPTION_TAG]) {
            [self.feedItem.itemDescription appendString:string];
        }
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.parserDidEndDocumentHandler();
    });
}

@end
