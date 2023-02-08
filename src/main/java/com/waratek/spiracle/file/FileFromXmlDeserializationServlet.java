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
package com.waratek.spiracle.file;

import com.waratek.spiracle.deserial.FilePath;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.beans.ExceptionListener;
import java.beans.XMLDecoder;
import java.beans.XMLEncoder;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;

/**
 * Servlet for performing read/write operations on a filepath from an XML deserialization source.
 * To achieve this, the filepath is first serialized, then deserialized back out
 */
@WebServlet("/FileFromXmlDeserializationServlet")
public class FileFromXmlDeserializationServlet extends AbstractFileServlet {
	private static final String XML_FILE = "filePath.xml";

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public FileFromXmlDeserializationServlet() {
		super();
	}


	protected void executeRequest(HttpServletRequest request, HttpServletResponse response) throws IOException {
		final String userProvidedPath = request.getParameter("fileXmlDeserializationPath");
		final String deserializedPath = xmlSerializeAndDeserializePath(userProvidedPath);


		performFileAction(request, deserializedPath);
		response.sendRedirect("file.jsp");
	}

	/**
	 * Write path to an XML file, and then deserialize the same path from that file.
	 * If nothing interrupts the process, the input will be the same as the output
	 */
	private String xmlSerializeAndDeserializePath(String path) throws IOException {
		FilePath filePath = new FilePath(path);
		serializeFilePathToXml(filePath);
		return deserializeFilePathFromXml().getPath();
	}

	private static void serializeFilePathToXml (FilePath filePath) throws IOException {
		FileOutputStream fos = new FileOutputStream(XML_FILE);
		XMLEncoder encoder = new XMLEncoder(fos);
		encoder.setExceptionListener(new ExceptionListener() {
			public void exceptionThrown(Exception e) {
				System.out.println("Exception! :"+e.toString());
			}
		});
		encoder.writeObject(filePath);
		encoder.close();
		fos.close();
	}

	private static FilePath deserializeFilePathFromXml() throws IOException {
		FileInputStream fis = new FileInputStream(XML_FILE);
		XMLDecoder decoder = new XMLDecoder(fis);
		FilePath deserializedFilePath = (FilePath) decoder.readObject();
		decoder.close();
		fis.close();
		return deserializedFilePath;
	}

}
