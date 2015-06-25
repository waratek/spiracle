package com.waratek.spiracle.jaas;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.security.auth.Subject;
import javax.security.auth.callback.Callback;
import javax.security.auth.callback.CallbackHandler;
import javax.security.auth.callback.NameCallback;
import javax.security.auth.callback.PasswordCallback;
import javax.security.auth.callback.UnsupportedCallbackException;
import javax.security.auth.login.LoginException;
import javax.security.auth.spi.LoginModule;
import javax.security.auth.login.FailedLoginException;

public class SpiracleLoginModule implements LoginModule {

  private CallbackHandler handler;
  private Subject subject;
  private UserPrincipal userPrincipal;
  private RolePrincipal rolePrincipal;
  private PasswordPrincipal passwordPrincipal;
  
  private String username;
  private String password;
  
  private List<String> userGroups;
  
  private Map sharedState;
  private Map options;
  private boolean debug = false;
  
  private boolean succeeded = false;
  private boolean commitSucceeded = false;
  
  /**
   * The default login module constructor.
   */
  public SpiracleLoginModule()
  {
      this.debug = false;
      this.succeeded = false;
      this.commitSucceeded = false;
      this.username = null;
      this.password = null;
      this.userPrincipal = null;
      this.passwordPrincipal = null;
      this.rolePrincipal = null;
      this.userGroups = null;
  }

  
  @Override
  public void initialize(Subject subject,
      CallbackHandler callbackHandler,
      Map<String, ?> sharedState,
      Map<String, ?> options) {

    this.handler = callbackHandler;
    this.subject = subject;
    this.options = options;
    this.sharedState = sharedState;
  }

  @Override
  public boolean login() throws LoginException {

    Callback[] callbacks = new Callback[2];
    callbacks[0] = new NameCallback("login");
    callbacks[1] = new PasswordCallback("password", true);

    try {
      handler.handle(callbacks);
      this.username = ((NameCallback) callbacks[0]).getName();
      this.password = String.valueOf(((PasswordCallback) callbacks[1]).getPassword());

      if (username == null || password == null) {
          System.out.println("Callback handler does not return login data properly");
          return false;
      }
      
      ((PasswordCallback)callbacks[1]).clearPassword();
      callbacks[0] = null;
      callbacks[1] = null;
      
      // Here we validate the credentials against some
      // authentication/authorization provider.
      // For simplicity we are just checking if 
      // user is "user123" and password is "pass123"
      if (username != null &&
              username.equals("waratek") &&
          password != null &&
          password.equals("warat3k")) {

        // We store the username and roles
        // fetched from the credentials provider
        // to be used later in commit() method.
        // For simplicity we hard coded the
        // "admin" role
        this.userGroups = new ArrayList<String>();
        this.userGroups.add("admin");
        this.succeeded = true;
      }
      else
      {
          this.username = null;
          this.password = null;
          this.succeeded = false;
          throw new FailedLoginException("Invalid username or password");
      }

    } catch (IOException e) {
      throw new LoginException(e.getMessage());
    } catch (UnsupportedCallbackException e) {
      throw new LoginException(e.getMessage());
    }

    return succeeded;
  }

  @Override
  public boolean commit() throws LoginException {

      if (succeeded == false) {
          return false;
      } else { 
          
    userPrincipal = new UserPrincipal(username);
    if (!subject.getPrincipals().contains(userPrincipal)) {
        subject.getPrincipals().add(userPrincipal);
    }
    
    passwordPrincipal = new PasswordPrincipal(password); 
    if (!subject.getPrincipals().contains(passwordPrincipal)) {
        subject.getPrincipals().add(passwordPrincipal);
    }

    for (String role: userGroups) {
        RolePrincipal rolePrincipal = new RolePrincipal(role);
        if (!subject.getPrincipals().contains(rolePrincipal)) {
            subject.getPrincipals().add(rolePrincipal); 
        }
    }
    
    commitSucceeded = true;
    return true;
      }
  }

  @Override
  public boolean abort() throws LoginException {
     if (succeeded == false) {
         return false;
     } else if (succeeded == true && commitSucceeded == false) {
         succeeded = false;
         username = null;
         if (password != null) {
             password = null;
         }
         userPrincipal = null;
     } else {
         logout();
     }
     return true;
  }
  
  @Override
  public boolean logout() throws LoginException {
    subject.getPrincipals().remove(userPrincipal);
    subject.getPrincipals().remove(rolePrincipal);
    subject.getPrincipals().clear();
    succeeded = false;
    succeeded = commitSucceeded;
    username = null;
    password = null;
    userPrincipal = null;
    return true;
  }

}