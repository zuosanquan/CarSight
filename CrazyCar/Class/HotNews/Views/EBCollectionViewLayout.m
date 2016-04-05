//
//  EBCollectionViewLayout.m
//  SideMenuDemo
//
//  Created by Edward on 16/2/23.
//  Copyright © 2016年 Edward. All rights reserved.
//

#import "EBCollectionViewLayout.h"

@implementation EBCollectionViewLayout
/*重写layout回调方法**/
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSArray *oldItems = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray *newItems = [[NSMutableArray alloc] initWithArray:oldItems copyItems:YES];
    
    __block UICollectionViewLayoutAttributes *headerAttributes = nil;
    
    [newItems enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UICollectionViewLayoutAttributes *arrtributes = obj;
        
        if ([arrtributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
            headerAttributes = arrtributes;
        }else{
            [self updateCellAttributes:arrtributes withSectionHeader:headerAttributes];
        }
    }];
    return newItems;
}

- (void)updateCellAttributes:(UICollectionViewLayoutAttributes *)attributes withSectionHeader:(UICollectionViewLayoutAttributes *)headerAttributes{
    //第一张的origin.y
    CGFloat minY = CGRectGetMinY(self.collectionView.bounds) + self.collectionView.contentInset.top;
    CGFloat maxY = attributes.frame.origin.y - CGRectGetHeight(headerAttributes.bounds);
   
    CGFloat finalY = MAX(minY, maxY);
    
    CGPoint origin = attributes.frame.origin;
    
    CGFloat deltaY = (finalY - origin.y) / CGRectGetHeight(attributes.frame);
    if (self.firstItemTransform) {
        attributes.transform = CGAffineTransformMakeScale((1- deltaY * self.firstItemTransform), (1 - deltaY * self.firstItemTransform));
    }
    origin.y = finalY;
    attributes.frame = (CGRect){origin, attributes.frame.size};
    attributes.zIndex = attributes.indexPath.row;
}
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}
@end
