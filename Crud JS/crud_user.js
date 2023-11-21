////////// Signing Up ////////////
(async () => {
    const user = new Parse.User();
    user.set('username', 'A string');
    user.set('email', 'A string');
    user.set('password', '#Password123');
  
    try {
      let userResult = await user.signUp();
      console.log('User signed up', userResult);
    } catch (error) {
      console.error('Error while signing up user', error);
    }
  })();
  //////////// Logging In ////////////////////////
  (async () => {
    try {
      // Pass the username and password to logIn function
      let user = await Parse.User.logIn('newUserName','#Password123');
      // Do stuff after successful login
      console.log('Logged in user', user);
    } catch (error) {
      console.error('Error while logging in user', error);
    }
  })();

  ///////////////// Requesting Password Reset ////////////////
  (async () => {
    try {
      // Pass the username and password to logIn function
      let result = await Parse.User.requestPasswordReset("email@example.com");
      // Password reset request was sent successfully
      console.log('Reset password email sent successfully');
    } catch (error) {
      console.error('Error while creating request to reset user password', error);
    }
  })();

  //////////////////////Reading Users/////////////////
  (async () => {
    const User = new Parse.User();
    const query = new Parse.Query(User);
  
    try {
      let user = await query.get('hEPjkt4epS');
      console.log('User found', user);
    } catch (error) {
      console.error('Error while fetching user', error);
    }
  })();

  ////////////////////Update User/////////////////////
  (async () => {
    const User = new Parse.User();
    const query = new Parse.Query(User);
  
    try {
      // Finds the user by its ID
      let user = await query.get('hEPjkt4epS');
      // Updates the data we want
      user.set('username', 'A string');
      user.set('email', 'A string');
      try {
        // Saves the user with the updated data
        let response = await user.save();
        console.log('Updated user', response);
      } catch (error) {
        console.error('Error while updating user', error);
      }
    } catch (error) {
      console.error('Error while retrieving user', error);
    }
  })();

  ////////////////////////Deleting Users////////////////////
  (async () => {
    const User = new Parse.User();
    const query = new Parse.Query(User);
  
    try {
      // Finds the user by its ID
      let user = await query.get('FD2UCUD3t0');
      try {
        // Invokes the "destroy" method to delete the user
        let response = await user.destroy();
        console.log('Deleted user', response);
      } catch (error) {
        console.error('Error while deleting user', error);
      }
    } catch (error) {
      console.error('Error while retrieving user', error);
    }
  })();
  //////////////////////Logging Out///////////////////
  (async () => {
    // Checks if the user is logged in
    const currentUser = Parse.User.current();
    if (currentUser) {
      // Logs out the current user
      await Parse.User.logOut();
      console.log('User logged out');
    } else {
      console.log('No user logged in');
    }
  })();