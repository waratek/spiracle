package com.waratek.spiracle.jaas;


import java.security.Principal;

public class UserPrincipal implements Principal {

  private String name;
  
  public UserPrincipal(String name) {
    super();
    this.name = name;
  }

  public void setName(String name) {
    this.name = name;
  }

  @Override
  public String getName() {
    return name;
  }

  @Override
  public String toString() {
    return "UserPrincipal [name=" + name + "]";
  }
}