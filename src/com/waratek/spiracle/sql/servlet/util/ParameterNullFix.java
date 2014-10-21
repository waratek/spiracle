package com.waratek.spiracle.sql.servlet.util;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

public class ParameterNullFix {
    
    public static Map<String, String> sanitizeNull(List<String> inputList, HttpServletRequest request) {
        Map<String, String> outputMap= new HashMap<String, String>();
        for(String item : inputList) {
            String val = request.getParameter(item);
            if(val == null) {
                outputMap.put(item, "");
            } else {
                outputMap.put(item, val);
            }
        }
        return outputMap;       
    }
}
