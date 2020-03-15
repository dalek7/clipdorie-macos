//
//  ProcAction.h
//  ClipdorieMac
//
//  Created by Seung-Chan on 6/23/14.
//
//

@interface ProcAction : NSObject{
    
    
    
    
}


+(NSString*) GetText;
+(void) PasteText:(NSString *)string;

+(void) CDTextWork;


+ (ProcAction *) sharedInstance;
-(void) Test;


@end