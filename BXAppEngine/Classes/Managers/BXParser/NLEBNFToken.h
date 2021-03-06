//
// Copyright 2013 Mike Friesen
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import <Foundation/Foundation.h>

@interface NLEBNFToken : NSObject

typedef enum NLEBNFTokenType : NSInteger {
    NLEBNFTokenType_COMMENT,
    NLEBNFTokenType_QUOTED_STRING,
    NLEBNFTokenType_NUMBER,
    NLEBNFTokenType_WORD,
    NLEBNFTokenType_SYMBOL,
    NLEBNFTokenType_WHITESPACE,
    NLEBNFTokenType_WHITESPACE_NEWLINE
} NLEBNFTokenType;

@property (nonatomic, assign) NSInteger identifier;
@property (nonatomic, retain) NSMutableString *stringValue;
@property (nonatomic, assign) NLEBNFTokenType type;
@property (nonatomic, assign) NLEBNFToken *nextToken;

- (id)init;
- (id)initWithValue:(NSString *)value;
- (void)appendValue:(unichar)ch;
- (void)setValueWithString:(NSString *)s;
- (BOOL)isSymbol;
- (BOOL)isWord;
- (BOOL)isQuotedString;
- (BOOL)isNumber;
- (BOOL)isComment;
- (BOOL)isWhitespace;

@end
