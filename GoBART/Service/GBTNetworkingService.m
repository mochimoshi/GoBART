//
//  GBTNetworkingService.m
//  GoBART
//
//  Created by Tim Hsieh on 2/6/15.
//  Copyright (c) 2015 Chromatiqa. All rights reserved.
//

#import "GBTNetworkingService.h"

#import <AFNetworking/AFNetworking.h>

@interface GBTNetworkingService ()

@property (strong, nonatomic) NSMutableArray *XMLTripArray;
@property (strong, nonatomic) NSMutableDictionary *XMLAttributeDictionary;
@property (strong, nonatomic) NSMutableDictionary *response;
@property (strong, nonatomic) NSString *elementName;
@property (strong, nonatomic) NSMutableString *outstring;

@end

@implementation GBTNetworkingService

static NSString *kRoutesBaseURL = @"http://api.bart.gov/api/sched.aspx?cmd=arrive&date=now&key=MW9S-E7SL-26DU-VV8V";

+ (instancetype)sharedNetworkingService {
    
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (void)getRoutesWithOrig:(NSString *)orig dest:(NSString *)dest {
    NSString *routeURL = [NSString stringWithFormat:@"%@%@%@%@%@", kRoutesBaseURL, @"&orig=", orig, @"&dest=", dest];
    NSURL *url = [NSURL URLWithString:routeURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    if (!request) {
        NSLog(@"nil");
    }

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
    if (!operation.responseSerializer) {
        NSLog(@"nil");
    }

    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSXMLParser *XMLParser = (NSXMLParser *)responseObject;
        [XMLParser setShouldProcessNamespaces:YES];
        XMLParser.delegate = self;
        [XMLParser parse];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    [operation start];
}

- (void)parserDidStartDocument:(NSXMLParser *)parser {
    self.XMLTripArray = [NSMutableArray array];
    self.XMLAttributeDictionary = [NSMutableDictionary dictionary];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    self.elementName = qName;
    if ([qName isEqualToString:@"trip"]) {
        NSLog(@"%@: departure:%@ arrival %@", qName, attributeDict[@"origTimeMin"], attributeDict[@"destTimeMin"]);
    } else if ([qName isEqualToString:@"leg"]) {
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (!self.elementName) return;
    [self.outstring appendFormat:@"%@", string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([qName isEqualToString:@"schedule"]) {
        
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    return;
}

@end
