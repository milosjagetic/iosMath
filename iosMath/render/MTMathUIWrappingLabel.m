//
//  MyClass.m
//  
//
//  Created by Milos Jagetic on 06/03/2021.
//

#import "MTMathUIWrappingLabel.h"
#import "MTTypesetter.h"

@interface MTMathList (AddAtoms)
- (void)addAtoms:(NSArray<MTMathAtom *> *)atoms;
@end

@implementation MTMathList (AddAtoms)
- (void)addAtoms:(NSArray<MTMathAtom *> *)atoms
{
    for (MTMathAtom *atom in atoms)
    {
        [self addAtom:atom];
    }
}
@end

@implementation MTMathUIWrappingLabel

- (void)setMathListWrapped:(MTMathList *)mathList
{
    self.mathList = [self wrapList:mathList];
}

- (MTMathList *)wrapList:(MTMathList *)mathList
{
    MTMathList *wrappedList = [MTMathList mathListWithAtomsArray:@[]];
    MTMathList *currentLineList = [MTMathList mathListWithAtomsArray:@[]];
    MTMathTable *table;
    
    for (MTMathAtom *atom in mathList.atoms)
    {
        MTMathList *newList = [MTMathList mathListWithAtomsArray:currentLineList.atoms];
        
        [newList addAtom:atom];
        
        MTMathListDisplay *displayList = [MTTypesetter createLineForMathList:newList font:self.font style:self.labelMode == kMTMathUILabelModeText ? kMTLineStyleText : kMTLineStyleDisplay];
        
        CGFloat newWidth = displayList.width + self.contentInsets.left + self.contentInsets.right;
        NSLog(@"new width: %.0lf my wi %.0lf", newWidth, self.bounds.size.width);
        if (newWidth > self.bounds.size.width)
        {
            //break
            if (!table)
            {
                table = MTMathTable.new;
                [wrappedList addAtom:table];
            }
            
//            if (currentLineList.atoms.count == 1 && [currentLineList.atoms.firstObject isKindOfClass:MTInner.class])
//            {
//                MTInner *wrappedInner = MTInner.new;
//                wrappedInner.innerList = [self wrapList:((MTInner *)currentLineList.atoms.firstObject).innerList];
//                wrappedInner.leftBoundary = ((MTInner *)currentLineList.atoms.firstObject).leftBoundary;
//                wrappedInner.rightBoundary = ((MTInner *)currentLineList.atoms.firstObject).rightBoundary;
//                
//                newList = [MTMathList mathListWithAtoms:wrappedInner, nil];
//            }
            //set the current line, if currentLineList is empty it means that the new atom will occupy a line alone
            MTMathList *cell = currentLineList.atoms.count == 0 ? newList : currentLineList;
            [table setCell:cell forRow:table.numRows column:0];
            
            // currentLineList is not empty -> wrap the new atom to new line
            if (currentLineList.atoms.count > 0)
            {
                currentLineList = [MTMathList mathListWithAtoms:atom, nil];
            }
        }
        else
        {
            [currentLineList addAtom:atom];
        }
    }
    
    if (!table)
        //the expression was never wrapped
        return currentLineList;
    else
    {
        //add last line
        if (currentLineList.atoms.count > 0)
            [table setCell:currentLineList forRow:table.numRows column:0];
        return wrappedList;
    }
}
@end
