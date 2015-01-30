/*
 *  Copyright 2014 Waratek Ltd.
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */
package com.waratek.spiracle.sql.servlet.util;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;

public class ParameterNullFix {
	private static final Logger logger = Logger.getLogger(ParameterNullFix.class);

	public static Map<String, String> sanitizeNull(List<String> inputList, HttpServletRequest request) {
		Map<String, String> outputMap= new HashMap<String, String>();
		for(String item : inputList) {
			String val = request.getParameter(item);
			if(val == null) {
				logger.info("Expected parameter {" + item + "} is null");
				outputMap.put(item, "");
			} else {
				outputMap.put(item, val);
			}
		}
		return outputMap;
	}
}
