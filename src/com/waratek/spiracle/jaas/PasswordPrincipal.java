package com.waratek.spiracle.jaas;

import java.security.Principal;

public class PasswordPrincipal implements Principal {

private String password;

/**
 * @param name
 */
public PasswordPrincipal(String name) {
    this.password = name;
}

@Override
public String getName() {
    return password;
}

@Override
public int hashCode() {
    final int prime = 31;
    int result = 1;
    result = prime * result + ((password == null) ? 0 : password.hashCode());
    return result;
}

@Override
public boolean equals(Object obj) {
    if (this == obj)
        return true;
    if (obj == null)
        return false;
    if (getClass() != obj.getClass())
        return false;
    PasswordPrincipal other = (PasswordPrincipal) obj;
    if (password == null) {
       if (other.password != null)
          return false;
    } else if (!password.equals(other.password))
       return false;
    
    return true;
}

@Override
public String toString() {
    return "PasswordPrincipal [name=" + password + "]";
}

}
