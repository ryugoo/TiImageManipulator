/**
 * Your Copyright Here
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */
#import "NetImthinkerTiImagemanipulatorModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"
#import "TiBlob.h"
#import "UIImage+Alpha.h"
#import <CoreImage/CoreImage.h>

@implementation NetImthinkerTiImagemanipulatorModule

#pragma mark Internal

- (id)moduleGUID
{
    return @"b00f4f2a-07e1-4f2e-8cb2-da8d2c34653d";
}

- (NSString*)moduleId
{
    return @"net.imthinker.ti.imagemanipulator";
}

- (void)dealloc
{
    // [super dealloc];
}

#pragma mark Lifecycle

- (void)startup
{
    [super startup];
    NSLog(@"[INFO] %@ loaded", self);
}

- (void)shutdown:(id)sender
{
    [super shutdown:sender];
}

#pragma mark Internal Memory Management

- (void)didReceiveMemoryWarning:(NSNotification*)notification
{
    [super didReceiveMemoryWarning:notification];
}

#pragma mark Methods

- (TiBlob*)resizeImage:(id)args
{
    ENSURE_SINGLE_ARG(args, NSDictionary);

    // Flag
    BOOL keepAspect = [TiUtils boolValue:args[@"keepAspect"]
                                     def:NO];
    BOOL isRetina = [TiUtils isRetinaDisplay];

    // Create CoreImage
    TiBlob* baseBlob = args[@"image"];
    UIImage* baseImage = [baseBlob image];
    UIGraphicsBeginImageContext(baseImage.size);
    [baseImage drawInRect:CGRectMake(0, 0, baseImage.size.width, baseImage.size.height)];
    baseImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CIImage* convertedImage = [[CIImage alloc] initWithCGImage:[baseImage CGImage]];

    // Store original MIMEType
    NSString* originalMIMEType = [baseBlob mimeType];
    NSLog(@"[DEBUG] Input file MIMEType is => %@", originalMIMEType);

    // Width and Height
    CGFloat targetWidth = [TiUtils floatValue:args[@"width"]];
    CGFloat targetHeight = [TiUtils floatValue:args[@"height"]];
    CGFloat baseWidth = baseImage.size.width;
    CGFloat baseHeight = baseImage.size.height;

    // Processing
    UIImage* proceedImage;
    CIImage* proceedCIImage;
    CGFloat targetScale, targetWidthScale, targetHeightScale;
    if (keepAspect) {
        targetScale = baseWidth < baseHeight ? targetWidth / baseWidth : targetHeight / baseHeight;
        proceedCIImage = [convertedImage imageByApplyingTransform:CGAffineTransformMakeScale(targetScale, targetScale)];
    } else {
        targetWidthScale = targetWidth / baseWidth;
        targetHeightScale = targetHeight / baseHeight;
        proceedCIImage = [convertedImage imageByApplyingTransform:CGAffineTransformMakeScale(targetWidthScale, targetHeightScale)];
    }
    CIContext* ciContext = [CIContext contextWithOptions:@{
                                                             kCIContextUseSoftwareRenderer : @NO
                                                         }];
    CGImageRef imageRef = [ciContext createCGImage:proceedCIImage
                                          fromRect:[proceedCIImage extent]];
    proceedImage = [UIImage imageWithCGImage:imageRef
                                       scale:1.0f
                                 orientation:UIImageOrientationUp];
    CGImageRelease(imageRef);

    // Make blob
    NSString* mimeType;
    NSData* convertedData;
    if ([originalMIMEType isEqualToString:@"image/jpeg"]) {
        mimeType = [originalMIMEType copy];
        convertedData = UIImageJPEGRepresentation(proceedImage, 0.85f);
    } else if ([UIImageAlpha hasAlpha:proceedImage]) {
        mimeType = @"image/png";
        convertedData = UIImagePNGRepresentation(proceedImage);
    } else {
        mimeType = @"image/jpeg";
        convertedData = UIImageJPEGRepresentation(proceedImage, 0.85f);
    }
    TiBlob* convertedBlob = [[TiBlob alloc] initWithData:convertedData
                                                mimetype:mimeType];
    return convertedBlob;
}

@end
