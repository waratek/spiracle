package com.waratek.spiracle.network;

import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;

public class ServerSocketThread extends Thread {

    private ServerSocket s;
    public ServerSocketThread(int port) throws IOException {
        super();            
        s = new ServerSocket(port);         
    }

    public String toString() {
        return s.toString();
    }

    public void run() {
        Socket sock = null;
        do {
            try {
                sock = s.accept();              
                while(!this.isInterrupted()) {
                }
            } catch (IOException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
        } while(!this.isInterrupted());
        try {
            sock.close();
            s.close();          
        } catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }
}
