//
//  ViewController.m
//  CardsAgainstTheEnvironment
//
//  Created by Dominic Ong on 9/13/14.
//  Copyright (c) 2014 Dominic Ong. All rights reserved.
//

#import "ViewController.h"
#import "RoomsViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (strong, nonatomic) UIAlertView *alert;
@property (strong, nonatomic) UITapGestureRecognizer *tap;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titlePositionConstraint;
@end

@implementation ViewController{
    PFUser *currentUser;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [_tap setEnabled:YES];
    [self.view addGestureRecognizer:_tap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)animateTextField:(UITextField *)textfield up:(BOOL)up{
    int movementDistance = -120;
    
    int movement = (up ? -movementDistance : movementDistance);
    [UIView animateWithDuration:1.0f animations:^{
        _titlePositionConstraint.constant = _titlePositionConstraint.constant + movement;
    }];
}


-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [self animateTextField:textField up:YES];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self animateTextField:textField up:NO];
}

-(void)hideKeyboard{
    [_usernameField resignFirstResponder];
    [_passwordField resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if([textField isEqual:_usernameField]){
        [_usernameField resignFirstResponder];
        [_passwordField becomeFirstResponder];
    }else{
        [_passwordField resignFirstResponder];
        [self performSelector:@selector(login:) withObject:self];
    }
    return YES;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"Login"]){
        RoomsViewController *vc = (RoomsViewController *)[[[segue destinationViewController] viewControllers] objectAtIndex:0];
        vc.user = currentUser;
    }
}

- (IBAction)login:(id)sender {
    [_loginButton setEnabled:NO];
    [self hideKeyboard];
    [_activityView startAnimating];
    [PFUser logInWithUsernameInBackground:_usernameField.text password:_passwordField.text block:^(PFUser *user, NSError *error) {
        if(!error){
            [_activityView stopAnimating];
            [_loginButton setEnabled:YES];
            NSLog(@"Login successful");
            [_usernameField setText:@""];
            [_passwordField setText:@""];
            currentUser = user;
            [self performSegueWithIdentifier:@"Login" sender:self];
        }else{
            [_loginButton setEnabled:YES];
            [_activityView stopAnimating];
            NSLog(@"Error logging in: %@", [error description]);
            if([[error description] rangeOfString:@"Invalid login credentials"].location != NSNotFound){
                _alert = [[UIAlertView alloc] initWithTitle:@"Login Error" message:@"Invalid credentials" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [_alert show];
            }
        }
    }];
}


@end
