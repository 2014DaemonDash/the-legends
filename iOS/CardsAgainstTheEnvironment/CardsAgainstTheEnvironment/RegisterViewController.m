//
//  RegisterViewController.m
//  CardsAgainstTheEnvironment
//
//  Created by Dominic Ong on 9/13/14.
//  Copyright (c) 2014 Dominic Ong. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) UIAlertView *alert;
@property (strong, nonatomic) UITapGestureRecognizer *tap;
@end

@implementation RegisterViewController{
    PFUser *currentUser;
}

-(void)viewDidLoad{
    _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [_tap setEnabled:YES];
    [self.view addGestureRecognizer:_tap];
}

-(void)hideKeyboard{
    [_usernameField resignFirstResponder];
    [_passwordField resignFirstResponder];
    [_emailField resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if([textField isEqual:_usernameField]){
        [_usernameField resignFirstResponder];
        [_passwordField becomeFirstResponder];
    }else if([textField isEqual:_passwordField]){
        [_passwordField resignFirstResponder];
        [_emailField becomeFirstResponder];
    }else{
        [_emailField resignFirstResponder];
        [self hideKeyboard];
    }
    return YES;
}

- (IBAction)signup:(id)sender {
    PFUser *newUser = [PFUser user];
    newUser.username = _usernameField.text;
    newUser.password = _passwordField.text;
    newUser.email = _emailField.text;
    newUser[@"rooms"] = @[];
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(!error){
            NSLog(@"Signup successful");
            currentUser = newUser;
            _alert = [[UIAlertView alloc] initWithTitle:@"Yay!" message:@"You have succesfully signed up for Cards Against The Environment. Please login now." delegate:nil cancelButtonTitle:@"Thanks" otherButtonTitles: nil];
            [_alert show];
            [_emailField setText:@""];
            //[self hideKeyboard];
            //[self performSelector:@selector(login:) withObject:sender];
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            NSLog(@"Error signing up: %@",[error description]);
            _alert = [[UIAlertView alloc] initWithTitle:@"Error Signing Up" message:@"Error msg" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
            [_alert show];
        }
    }];
}
- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
