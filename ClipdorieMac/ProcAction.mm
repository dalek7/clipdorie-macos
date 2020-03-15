//
//  ProcAction.cpp
//  ClipdorieMac
//
//  Created by Seung-Chan on 6/23/14.
//  Coffee Bean @Migeum
//

#import "ProcAction.h"


@implementation ProcAction


#pragma mark -
#pragma mark Access

static ProcAction* _sharedInstance;

+ (ProcAction *) sharedInstance
{
	if (!_sharedInstance)
	{
		_sharedInstance = [[ProcAction alloc] init];
	}
    
	return _sharedInstance;
}

-(void) Test
{
    
    NSLog(@"MERONG");
}


#pragma mark -
#pragma mark Clipboard

+(NSString*) GetText{
	
	NSPasteboard *pasteBoard = [NSPasteboard generalPasteboard];
	return [pasteBoard stringForType:NSStringPboardType];
	
	
}

+(void) PasteText:(NSString *)string
{
	
	//NSString *string = @"String to be copied";
	NSPasteboard *pasteBoard = [NSPasteboard generalPasteboard];
	[pasteBoard declareTypes:[NSArray arrayWithObjects:NSStringPboardType, nil] owner:nil];
	[pasteBoard setString:string forType:NSStringPboardType];
	
}

+(void) CDTextWork
{
    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
    NSArray *classes = [NSArray arrayWithObject:[NSURL class]];
    
    NSDictionary *options = [NSDictionary dictionaryWithObject:
                             [NSNumber numberWithBool:YES] forKey:NSPasteboardURLReadingFileURLsOnlyKey];
    
    NSArray *fileURLs =
    [pasteboard readObjectsForClasses:classes options:options];
    
    int size = [fileURLs count];
    NSLog(@"there are %d objects in the array", size);
    
    if(size>0)
    {//
        NSString *str1 =  [[NSString alloc] initWithString:[[fileURLs objectAtIndex:0] path]];
        //NSArray *chunks = [str1 componentsSeparatedByString: @"/"];
        //NSString *lastOne = [chunks objectAtIndex:[chunks count]-1] ;
        //NSLog(@"%@", lastOne);
        
        BOOL isDir;
        [[NSFileManager defaultManager] fileExistsAtPath:str1 isDirectory:&isDir];
        
        if (isDir)
        {
            [self PasteText:str1];
            NSLog(@"%@ is a directory", str1);
        }
        else
        {//stringByDeletingLastPathComponent
            NSString *directory = [str1 stringByDeletingLastPathComponent];
            [self PasteText:directory];
            NSLog(@"%@ is a file in the %@", str1, directory);
        }
        
        //[self PasteText:[fileURLs objectAtIndex:0]];
        
    }
    else
    {
        
        NSString* str = [self GetText];
        
        //Trimming white spaces
        NSString *trimStr = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        [self PasteText:trimStr];
        NSLog(@"%@",str);
	}

    
}

// Remove returns
+(void) CDTextWork2
{
    NSString* str = [self GetText];
    
    // Removing new line characters
    NSString *str2 = [[str componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@" "];
    
    //Trimming white spaces
    NSString *trimStr = [str2 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    [self PasteText:trimStr];
    NSLog(@"%@",str);

}


// Make it lowercase
+(void) CDTextWork3
{
    NSString* str = [self GetText];
    
    // Removing new line characters
    NSString *str2 = [str lowercaseString];
    
    //Trimming white spaces
    NSString *trimStr = [str2 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    [self PasteText:trimStr];
    NSLog(@"%@",str);

}

// Make it uppercase
+(void) CDTextWork4
{
    NSString* str = [self GetText];
    
    // Removing new line characters
    NSString *str2 = [str uppercaseString];
    
    //Trimming white spaces
    NSString *trimStr = [str2 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    [self PasteText:trimStr];
    NSLog(@"%@",str);

}
@end
