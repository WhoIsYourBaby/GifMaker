/*
 * The MIT License (MIT)
 *
 * Copyright (c) 2012-2013 Adam Debono. All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#import "UIViewController+ADFlipTransition.h"

#import <objc/runtime.h>

@implementation UIViewController (ADFlipTransition)

#pragma mark - Setters

@dynamic presentedFlipTransition;
@dynamic presentingFlipTransition;

static NSString *const kPresentedFlipTransitionKey = @"kPresentedFlipTransition";
static NSString *const kPresentingFlipTransitionKey = @"kPresentingFlipTransition";

- (ADFlipTransition *)presentedFlipTransition {
	return objc_getAssociatedObject(self, (__bridge const void *)kPresentedFlipTransitionKey);
}

- (void)setPresentedFlipTransition:(ADFlipTransition *)presentedFlipTransition {
	objc_setAssociatedObject(self, (__bridge const void *)kPresentedFlipTransitionKey, presentedFlipTransition, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (ADFlipTransition *)presentingFlipTransition {
	return objc_getAssociatedObject(self, (__bridge const void *)kPresentingFlipTransitionKey);
}

- (void)setPresentingFlipTransition:(ADFlipTransition *)presentingFlipTransition {
	objc_setAssociatedObject(self, (__bridge const void *)kPresentingFlipTransitionKey, presentingFlipTransition, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Performing

- (void)flipToViewController:(UIViewController *)destinationViewController fromView:(UIView *)sourceView withCompletion:(void (^)(void))completion {
	[self flipToViewController:destinationViewController fromView:sourceView withSourceSnapshotImage:nil andDestinationSnapshot:nil withCompletion:completion];
}

- (void)flipToViewController:(UIViewController *)destinationViewController fromView:(UIView *)sourceView withSourceSnapshotImage:(UIImage *)sourceSnapshot andDestinationSnapshot:(UIImage *)destinationSnapshot withCompletion:(void (^)(void))completion {
	[self flipToViewController:destinationViewController fromView:sourceView asChildWithSize:CGSizeZero withSourceSnapshotImage:sourceSnapshot andDestinationSnapshot:destinationSnapshot withCompletion:completion];
}

- (void)flipToViewController:(UIViewController *)destinationViewController fromView:(UIView *)sourceView asChildWithSize:(CGSize)destinationSize withCompletion:(void (^)(void))completion {
	[self flipToViewController:destinationViewController fromView:sourceView asChildWithSize:destinationSize withSourceSnapshotImage:nil andDestinationSnapshot:nil withCompletion:completion];
}

- (void)flipToViewController:(UIViewController *)destinationViewController fromView:(UIView *)sourceView asChildWithSize:(CGSize)destinationSize withSourceSnapshotImage:(UIImage *)sourceSnapshot andDestinationSnapshot:(UIImage *)destinationSnapshot withCompletion:(void (^)(void))completion {
	ADFlipTransition *transition = [[ADFlipTransition alloc] init];
	[transition setSourceView:sourceView inViewController:self withSnapshotImage:sourceSnapshot];
	[transition setDestinationViewController:destinationViewController asChildWithSize:destinationSize withSnapshotImage:destinationSnapshot];
	
	[self setPresentedFlipTransition:transition];
	[destinationViewController setPresentingFlipTransition:transition];
	
	[transition performWithCompletion:completion];
}

- (void)dismissFlipWithCompletion:(void (^)(void))completion {
	if ([self getPresentingFlipTransition]) {
		[[self getPresentingFlipTransition] reverseWithCompletion:completion];
	} else {
		NSLog(@"View wasn't presented by a flip transition");
	}
}

- (void)dismissFlipToIndexPath:(NSIndexPath *)indexPath withCompletion:(void (^)(void))completion {
	[[self getPresentingFlipTransition] updateIndexPath:indexPath];
	[self dismissFlipWithCompletion:completion];
}

- (ADFlipTransition *)getPresentingFlipTransition {
	UIViewController *vc = self;
	while (![vc presentingFlipTransition] && [vc parentViewController]) {
		vc = [vc parentViewController];
	}
	
	return [vc presentingFlipTransition];
}

@end
