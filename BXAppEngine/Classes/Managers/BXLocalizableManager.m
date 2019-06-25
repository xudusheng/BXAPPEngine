//
//  XDSLocalizableManager.m
//
//  Copyright (c) 2014 xudusheng. All rights reserved.
//

#import "BXLocalizableManager.h"
#import "RegexKitLite.h"

#import "NLEPropertyParser.h"
#import "BXConfigManager.h"


#define kXDSLocalZipDirectory [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, \
NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent: @"Localizable"]

#define kXDSLocalFilePath(localizableName) [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, \
NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent: [NSString stringWithFormat:@"Localizable/%@",(localizableName)]]

static NSString * localizableLocalFilePrefix = nil;
static NSString * noMatchToUseLanguage = nil;

@interface BXLocalizableManager ()

@property (nonatomic, copy) NSString * localizableServerURLString;
@property (nonatomic, copy) XDSLocalizableUpdateFinishedBlock updateFinishedBlock;

@end

@implementation BXLocalizableManager

+ (BXLocalizableManager *)sharedManager
{
    static BXLocalizableManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[[self instanceClass] alloc] init];
    });
    return sharedInstance;
}


#pragma mark - Public methods

- (NSDictionary *)currentLanguageDictionary
{
    if (!_currentLanguageDictionary) {
        _currentLanguageDictionary = [self createCurrentLanguageDictionary];
    }
    return _currentLanguageDictionary;
}

//save and get default language
+ (NSString *)getAppDefaultLanguage
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString* preferredLang = [userDefaults objectForKey:@"CurrentLanguages"];
    
    if (!preferredLang) {
        preferredLang = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0];
    }
    
    return [BXLocalizableManager handleSymbolSubstitutionWithLanguage:preferredLang];
}

+ (void)saveAppDefaultLanguage:(NSString *)item
{
    item = [BXLocalizableManager handleSymbolSubstitutionWithLanguage:item];
    
    BOOL languageChanged = NO;
    if (![[BXLocalizableManager getAppDefaultLanguage] isEqualToString:item]) {
        languageChanged = YES;
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:item forKey:@"CurrentLanguages"];
    [userDefaults synchronize];
    
    if (languageChanged) {
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        if (item) {
            [dic setObject:item forKey:@"language"];
        }
        
        [BXLocalizableManager sharedManager].currentLanguageDictionary = nil;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:XDSAppDefaultLanguageChangedNotification
                                                            object:nil
                                                          userInfo:dic];
    }
}

+ (NSString *)matchSimilarLanguageFileWithSelectedLanuage:(NSString *)language
{
    language = [BXLocalizableManager handleSymbolSubstitutionWithLanguage:language];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentDir = kXDSLocalZipDirectory;
    NSError *error = nil;
    NSArray *fileList = [[NSArray alloc] init];

#if TARGET_OS_TV
    fileList = [XDSLocalizableManager getLocalizableAllKey];
#else
    fileList = [fileManager contentsOfDirectoryAtPath:documentDir error:&error];
#endif
    
    NSMutableSet * localLanguageSet = [NSMutableSet set];
    
    for (NSString * string in fileList) {
        if ([string rangeOfString:@".string"].length > 0) {
            
            NSString * language = [string stringByMatching:@"(?<=localizable_).*(?=.string)"];
            
            if (language.length > 0) {
                [localLanguageSet addObject:language];
            }
        }
    }
    
    NSArray * localPaths = [[NSBundle mainBundle] pathsForResourcesOfType:@"string" inDirectory:nil];
    
    for (NSString * string in localPaths) {
        if ([string rangeOfString:@".string"].length > 0) {
            
            NSString * language = [string stringByMatching:@"(?<=localizable_).*(?=.string)"];
            if (language.length > 0) {
                [localLanguageSet addObject:language];
            }
        }
    }
    
    return [[BXLocalizableManager matchSimilarLanguageWithSelectedLanuage:language localLanguageArray:localLanguageSet.allObjects] lowercaseString];
    
}

+ (NSString *)matchSimilarLanguageWithSelectedLanuage:(NSString *)language localLanguageArray:(NSArray *)localLanguageArray
{
    language = [BXLocalizableManager handleSymbolSubstitutionWithLanguage:language];
    
    for (NSString * string in localLanguageArray) {
        NSString * aLanguage = [BXLocalizableManager handleSymbolSubstitutionWithLanguage:string];
        if ([aLanguage isEqualToString:language]) {
            return language;
        }
    }
    
    NSRange range = [language rangeOfString:@"_" options:NSBackwardsSearch];
    
    if (range.length > 0) {
        NSString * similarLanguage = [language substringToIndex:range.location];
        return [BXLocalizableManager matchSimilarLanguageWithSelectedLanuage:similarLanguage localLanguageArray:localLanguageArray];
    }
    
    return nil;
}

+ (NSString *)getSystemLanguage
{
    NSString * preferredLang = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0];
    return [preferredLang lowercaseString];
}

+ (void)setLocalFilePrefix:(NSString *)prefix
{
    localizableLocalFilePrefix = prefix;
}

+ (void)setNoMatchToUseLanguage:(NSString *)language
{
    noMatchToUseLanguage = [self handleSymbolSubstitutionWithLanguage:language];
}

- (void)updateLocalizableFileWithServerURL:(NSString *)url finished:(XDSLocalizableUpdateFinishedBlock)finished
{
    [self updateLocalizableFileWithServerURL:url forLanguage:nil finished:finished];
}

- (void)updateLocalizableFileWithServerURL:(NSString *)url forLanguage:(NSString *)language finished:(XDSLocalizableUpdateFinishedBlock)finished
{
    self.localizableServerURLString = url;
    self.updateFinishedBlock = finished;
    
    NSMutableDictionary * userInfo = [NSMutableDictionary dictionary];
    NSURL * requestURL = [NSURL URLWithString:self.localizableServerURLString];
    if (!language) {
        
        if (noMatchToUseLanguage) {
            
            BOOL configGetDefaultLanguage = [[BXConfigManager sharedManager].configItem isDefaultLanguageValid];
            NSString * defaultLanuage = [BXLocalizableManager handleSymbolSubstitutionWithLanguage:[BXConfigManager sharedManager].configItem.defaultLanguage];
            
            if (!configGetDefaultLanguage || !defaultLanuage) {
                language = [BXLocalizableManager handleSymbolSubstitutionWithLanguage:noMatchToUseLanguage];
            }else {
                language = [BXLocalizableManager handleSymbolSubstitutionWithLanguage:defaultLanuage];
            }
            
        }else {
            
            NSString * fileName = [requestURL lastPathComponent];
            language = [fileName stringByMatching:@"(?<=localization_).*(?=.string)"];
            if (!language || [language isEqualToString:@""]) {
                language = [fileName stringByMatching:@"(?<=localizable_).*(?=.string)"];
            }
            if (!language || [language isEqualToString:@""]) {
                language = [fileName stringByMatching:@".*(?=.string)"];
            }
            language = [BXLocalizableManager handleSymbolSubstitutionWithLanguage:language];
        }
        
    }else {
        language = [BXLocalizableManager handleSymbolSubstitutionWithLanguage:language];
    }
    
    if (language.length > 0) {
        [userInfo setObject:language forKey:@"language"];
    }else {
        [userInfo setObject:noMatchToUseLanguage?noMatchToUseLanguage:@"en" forKey:@"language"];
    }
    
    NSString *localizableFile = [NSString stringWithFormat:@"localizable_%@.string",language];
    NSString *localizableFilePath = kXDSLocalFilePath(localizableFile);
    NSData *stringData = nil;
    NSString *localizationLanguageString = [NSString stringWithContentsOfURL:requestURL encoding:NSUTF8StringEncoding error:nil];
    if (localizationLanguageString.length < 1) {
//        NSString *path = [[NSBundle mainBundle] pathForResource:localizableFile ofType:nil];
//        localizationLanguageString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        NSDictionary * currDict = [self createCurrentLanguageDictionary];
        self.currentLanguageDictionary = currDict;
        if (self.updateFinishedBlock) {
            self.updateFinishedBlock(nil);
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:XDSLocalizableNeedGlobalRefreshNotification object:nil userInfo:nil];

    } else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if ([fileManager fileExistsAtPath:localizableFilePath]) {
                [[localizationLanguageString dataUsingEncoding:NSUTF8StringEncoding] writeToFile:localizableFilePath atomically:YES];
            } else {
                if(![fileManager contentsOfDirectoryAtPath:kXDSLocalZipDirectory error:nil]){
                    [fileManager createDirectoryAtPath:kXDSLocalZipDirectory withIntermediateDirectories:NO attributes:nil error:nil];
                }
                BOOL result = [fileManager createFileAtPath:localizableFilePath contents:[localizationLanguageString dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
            }
            
            NSDictionary * currDict = [self createCurrentLanguageDictionary];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.currentLanguageDictionary = currDict;
                if (self.updateFinishedBlock) {
                    self.updateFinishedBlock(nil);
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:XDSLocalizableNeedGlobalRefreshNotification object:nil userInfo:nil];
            });
        });
    }
}

- (NSString *)localizableString:(NSString *)key
{
    return [self localizableString:key placeholder:nil exactMatch:NO];
}

- (NSString *)localizableString:(NSString *)key placeholder:(NSString *)placeholder
{
    return [self localizableString:key placeholder:placeholder exactMatch:NO];
}

- (NSString *)localizableString:(NSString *)key placeholder:(NSString *)placeholder exactMatch:(BOOL)exactMatch
{
    NSString * xdkey = @"@xdkey/";
    if ([key hasPrefix:xdkey]) {
        key = [key substringFromIndex:xdkey.length];
    }
    
    NSString *localizableString = [self.currentLanguageDictionary valueForKey:key];
    
    if (!exactMatch) {
        if (placeholder) {
            return localizableString?localizableString:placeholder;
        }else {
            return localizableString?localizableString:key;
        }
    }else {
        if (placeholder) {
            return localizableString?localizableString:placeholder;
        }else {
            return localizableString;
        }
    }
}

- (void)updateLocalizableFileWithData:(NSData *)data finished:(XDSLocalizableUpdateFinishedBlock)finished
{    
    self.updateFinishedBlock = finished;
    
    NSString * languageString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NLEPropertyParser *propertyParser = [[NLEPropertyParser alloc] init];
    NSMutableDictionary *dict = [propertyParser parse:languageString];
    
    self.currentLanguageDictionary = dict;
    
    if (self.updateFinishedBlock) {
        self.updateFinishedBlock(nil);
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:XDSLocalizableNeedGlobalRefreshNotification object:nil userInfo:nil];
}

- (void)updateLocalizableFileWithData:(NSData *)data forLanguage:(NSString *)language finished:(XDSLocalizableUpdateFinishedBlock)finished
{
    self.updateFinishedBlock = finished;
    language = [BXLocalizableManager handleSymbolSubstitutionWithLanguage:language];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *localizableFile = [NSString stringWithFormat:@"localizable_%@.string",language];
        [data writeToFile:kXDSLocalFilePath(localizableFile) atomically:YES];
        
        NSDictionary * currDict = [self createCurrentLanguageDictionary];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.currentLanguageDictionary = currDict;
            
            if (self.updateFinishedBlock) {
                self.updateFinishedBlock(nil);
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:XDSLocalizableNeedGlobalRefreshNotification object:nil userInfo:nil];
            
        });
    });
}

#pragma mark - Private methods

+ (NSString *)handleSymbolSubstitutionWithLanguage:(NSString *)language
{
    return [[language lowercaseString] stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
}

- (NSString *)string:(NSString *)string byReplacingSpecifiedItem:(NSDictionary *)dic
{
    __block NSString *newString = string;
    [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        newString = [newString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"${%@}",key] withString:obj];
    }];
    
    return newString;
}

- (NSDictionary *)localDicForAtPath:(NSString *)path
{
    if (!path) return nil;
    
    NSData *data = [NSData dataWithContentsOfFile: path];
    NSString *s = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    if (!s || s.length == 0) {
        return  nil;
    }
    
    NLEPropertyParser *propertyParser = [[NLEPropertyParser alloc] init];
    NSMutableDictionary *dict = [propertyParser parse:s];
    
    return dict;
    
}

- (NSDictionary *)createCurrentLanguageDictionary
{
    NSString * language = [BXLocalizableManager matchSimilarLanguageFileWithSelectedLanuage:[BXLocalizableManager getAppDefaultLanguage]];
    
    if (!language) {
        language = [BXLocalizableManager getAppDefaultLanguage];
    }
    
    NSDictionary * languageDic = nil;
    
    if (language) {
        languageDic = [self createLanguageDictionaryWithLanguage:language];
    }
    
    if (!languageDic) {
        languageDic = [self createLanguageDictionaryWithLanguage:noMatchToUseLanguage?noMatchToUseLanguage:@"en"];
    }
    
    return languageDic;
}

- (NSDictionary *)localDicForAtPathFormTV:(NSString *)path
{
    if (!path) return nil;
    
    NSData *data = [BXLocalizableManager getLocalizable:path];
    NSString *s = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    if (!s || s.length == 0) {
        return  nil;
    }
    
    NLEPropertyParser *propertyParser = [[NLEPropertyParser alloc] init];
    NSMutableDictionary *dict = [propertyParser parse:s];
    
    return dict;
    
}

- (NSDictionary *)createLanguageDictionaryWithLanguage:(NSString *)language
{
    NSDictionary * resultDictionary = nil;
    language = [BXLocalizableManager handleSymbolSubstitutionWithLanguage:language];
    @try {
        //get default language
        NSString *localizableFile = [NSString stringWithFormat:@"localizable_%@.string",language];
        NSDictionary *localizableDic =  [self localDicForAtPath:kXDSLocalFilePath(localizableFile)];

        NSString * defalutPath = [BXLocalizableManager getSimilarLocalLanguagePathWithSelectedLanuage:language];
         
        NSDictionary *defaultDic = [self localDicForAtPath:defalutPath];
        
        if ([localizableDic count] > 0 && [defaultDic count] > 0) {
            NSMutableDictionary *currDict = [NSMutableDictionary dictionaryWithDictionary:defaultDic];
            [currDict addEntriesFromDictionary:localizableDic];
            resultDictionary = currDict;
        }else if ([localizableDic count] > 0){
            resultDictionary = localizableDic;
        }else if ([defaultDic count] > 0) {
            resultDictionary = defaultDic;
        }else {
            
        }
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    return resultDictionary;
}

+ (NSString *)getSimilarLocalLanguagePathWithSelectedLanuage:(NSString *)language
{
    language = [BXLocalizableManager handleSymbolSubstitutionWithLanguage:language];
    
    NSString * bundleFilePrefix = localizableLocalFilePrefix.length > 0 ? localizableLocalFilePrefix : @"localizable";
    
    NSString * defalutPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@_%@",bundleFilePrefix,language] ofType:@"string"];
    
    if (defalutPath.length) {
        
        return defalutPath;
        
    }else {
        
        NSRange range = [language rangeOfString:@"_" options:NSBackwardsSearch];
        
        if (range.length > 0) {
            NSString * similarLanguage = [language substringToIndex:range.location];
            return [BXLocalizableManager getSimilarLocalLanguagePathWithSelectedLanuage:similarLanguage];
        }else {
            return nil;
        }
        
    }
}



#pragma mark - NSUserDefaults methods
//localizable file
+ (NSData *)getLocalizable:(NSString *)language
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData * data;
    data = [userDefaults objectForKey:language];
    return data;
}

+ (void)saveLocalizable:(NSString *)language data:(NSData *)item
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:item forKey:language];
    [userDefaults synchronize];
}

+ (NSArray *)getLocalizableAllKey
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSMutableArray *currArray = [NSMutableArray array];
    
    for (NSString *item in userDefaults.dictionaryRepresentation.allKeys) {
        if ([item isKindOfClass:[NSString class]] && [item hasPrefix:@"XDSTV_"] && [item hasSuffix:@".string"]) {
            NSString *language = [item stringByReplacingOccurrencesOfString:@"XDSTV_" withString:@""];
            [currArray addObject:language];
        }
    }
    
    return currArray;
}


@end

NSString * const XDSLocalizableNeedGlobalRefreshNotification = @"XDSLocalizableNeedGlobalRefreshNotification";
NSString * const XDSAppDefaultLanguageChangedNotification = @"XDSAppDefaultLanguageChangedNotification";
