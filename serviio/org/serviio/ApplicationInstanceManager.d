module org.serviio.ApplicationInstanceManager;

import java.lang.String;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.Reader;
import java.net.InetAddress;
import java.net.ServerSocket;
import java.net.Socket;
import java.net.UnknownHostException;
import org.serviio.ApplicationInstanceListener;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class ApplicationInstanceManager {
    private static Logger log;
    private static ApplicationInstanceListener subListener;
    public static immutable int SINGLE_INSTANCE_NETWORK_SOCKET = 44331;
    public static immutable String SINGLE_INSTANCE_SHARED_KEY = "$$NewInstance$$\n";
    public static immutable String CLOSE_INSTANCE_SHARED_KEY = "$$CloseInstance$$\n";
    private static ServerSocket socket;

    static this()
    {
        log = LoggerFactory.getLogger!ApplicationInstanceManager();
    }

    public static bool registerInstance(bool stopInstance) {
        bool returnValueOnError = true;
        try {
            ApplicationInstanceManager.socket = new ServerSocket(44331, 10, InetAddress.getLocalHost());
            ApplicationInstanceManager.log.debug_("Listening for application instances on socket 44331");
            Thread instanceListenerThread = new class(new class() Runnable {

                public void run() {
                        boolean socketClosed = false;
                        while (!socketClosed) {
                            if (ApplicationInstanceManager.socket.isClosed()) {
                                socketClosed = true;
                                continue;
                            }
                            try {
                                Socket client = ApplicationInstanceManager.socket.accept();
                                BufferedReader input = new BufferedReader(new InputStreamReader(client.getInputStream()));
                                String message = input.readLine();
                                if ("$$NewInstance$$\n".trim().equals(message.trim())) {
                                    ApplicationInstanceManager.log.debug_("Shared key matched - new application instance found");
                                    ApplicationInstanceManager.fireNewInstance(false);
                                } else if ("$$CloseInstance$$\n".trim().equals(message.trim())) {
                                    ApplicationInstanceManager.log.debug_("Close key matched - close request found");
                                    ApplicationInstanceManager.fireNewInstance(true);
                                }
                                input.close();
                                client.close();
                            }
                            catch (IOException e) {
                                socketClosed = true;
                            }
                        }
                    }
            }, "Instance checker"){};
            instanceListenerThread.setDaemon(true);
            instanceListenerThread.start();
        }
        catch (UnknownHostException e) {
            ApplicationInstanceManager.log.error(e.getMessage(), cast(Throwable)e);
            return returnValueOnError;
        }
        catch (IOException e) {
            try {
                Socket clientSocket = new Socket(InetAddress.getLocalHost(), 44331);
                OutputStream output = clientSocket.getOutputStream();
                if (stopInstance) {
                    ApplicationInstanceManager.log.debug_("Notifying first instance to stop.");
                    output.write("$$CloseInstance$$\n".getBytes());
                } else {
                    ApplicationInstanceManager.log.debug_("Port is already taken. Notifying first instance.");
                    output.write("$$NewInstance$$\n".getBytes());
                }
                output.close();
                clientSocket.close();
                ApplicationInstanceManager.log.debug_("Successfully notified first instance.");
                return false;
            }
            catch (UnknownHostException e1) {
                ApplicationInstanceManager.log.error(e.getMessage(), cast(Throwable)e);
                return returnValueOnError;
            }
            catch (IOException e1) {
                ApplicationInstanceManager.log.error("Error connecting to local port for single instance notification");
                ApplicationInstanceManager.log.error(e1.getMessage(), cast(Throwable)e1);
                return returnValueOnError;
            }
        }
        return true;
    }

    public static void stopInstance() {
        try {
            if (ApplicationInstanceManager.socket is null) return;
            ApplicationInstanceManager.socket.close();
        }
        catch (IOException e) {
            // empty catch block
        }
    }

    public static void setApplicationInstanceListener(ApplicationInstanceListener listener) {
        ApplicationInstanceManager.subListener = listener;
    }

    private static void fireNewInstance(bool closeRequest) {
        if (ApplicationInstanceManager.subListener is null) return;
        ApplicationInstanceManager.subListener.newInstanceCreated(closeRequest);
    }

}

