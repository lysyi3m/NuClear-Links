//
//  RulesViewController.m
//  NuClear Links
//
//  Created by Dmitry Afanasyev on 02/10/2017.
//  Copyright © 2017 Dmitrii Afanasev. All rights reserved.
//

#import "RulesViewController.h"
#import "Rule.h"
#import "RulePredicateEditorViewController.h"
#import "BrowserPopUpButton.h"
#import <shared/shared.h>

@interface RulesViewController ()

@property (strong) IBOutlet NSArrayController *arrayController;

- (IBAction)rulesControlClicked:(id)sender;

@end


@implementation RulesViewController

#pragma mark - Actions

- (IBAction)rulesControlClicked:(id)sender {
  // BUG: Array Controller does not propagate changes to UserDefaulsController automatically
  [[NSUserDefaults appGroupUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:_arrayController.arrangedObjects] forKey:@"rules"];
}


- (IBAction)duplicateButtonClicked:(NSButton *)sender {
  
  Rule *selectedObject = _arrayController.selectedObjects.firstObject;
  Rule *newRule = [selectedObject copy];
  newRule.title = [NSString stringWithFormat:@"%@ copy", newRule.title];
  [_arrayController insertObject:newRule atArrangedObjectIndex:_arrayController.selectionIndex + 1];
  [_arrayController setSelectedObjects:@[newRule]];
}

- (IBAction)removeButtonClicked:(id)sender {
  NSAlert *alert = [[NSAlert alloc] init];
  alert.messageText = @"Are you sure?";
  [alert addButtonWithTitle:@"OK"];
  [alert addButtonWithTitle:@"Cancel"];
  NSModalResponse response = [alert runModal];
  
  if (response == NSAlertFirstButtonReturn) {
    [_arrayController removeObject:_arrayController.selectedObjects.firstObject];
  }
}

- (IBAction)tableViewDoubleClicked:(NSTableView *)sender {
  if (_arrayController.selectedObjects.firstObject) {
    [self performSegueWithIdentifier:@"showRulePredicateEditorViewControllerSegue" sender:self];
  }
}

# pragma mark - NSSeguePerforming

- (void)prepareForSegue:(NSStoryboardSegue *)segue sender:(id)sender {
  RulePredicateEditorViewController *rulePredicateEditorViewController = (RulePredicateEditorViewController *)segue.destinationController;
  Rule *selectedRule = _arrayController.selectedObjects.firstObject;
  [rulePredicateEditorViewController.objectController setContent:[selectedRule copy]];
  rulePredicateEditorViewController.objectIndex = _arrayController.selectionIndex;
}

@end