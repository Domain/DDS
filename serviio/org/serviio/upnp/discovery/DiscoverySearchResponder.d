module org.serviio.upnp.discovery.DiscoverySearchResponder;

import java.lang;
import java.io.IOException;
import java.net.DatagramSocket;
import java.net.SocketAddress;
import java.net.SocketTimeoutException;
import java.util.List;
import org.serviio.upnp.protocol.ssdp.SSDPMessageBuilder;
import org.serviio.upnp.protocol.ssdp.SearchResponseMessageBuilder;
import org.serviio.util.MultiCastUtils;
import org.serviio.util.NumberUtils;
import org.serviio.util.ThreadUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class DiscoverySearchResponder : Runnable
{
    private static Logger log;
    private static immutable int MAX_MX = 120;
    private int advertisementDuration;
    private SocketAddress sourceAddress;
    private int timeToRespond;
    private String searchTarget;

    static this()
    {
        log = LoggerFactory.getLogger!(DiscoverySearchResponder);
    }

    public this(SocketAddress sourceAddress, int advertisementDuration, int timeToRespond, String searchTarget)
    {
        this.advertisementDuration = advertisementDuration;
        this.sourceAddress = sourceAddress;
        this.timeToRespond = timeToRespond;
        this.searchTarget = searchTarget;
    }

    public void run()
    {
        if ((this.timeToRespond >= 1) && 
            (this.searchTarget !is null))
        {
            List!(String) messages = generateMessages();
            if (messages.size() > 0)
            {
                log.debug_(java.lang.String.format("Sending %s M-SEARCH response message(s) to %s", cast(Object[])[ Integer.valueOf(messages.size()), this.sourceAddress ]));

                sendReply(messages);
            }
        }
    }

    protected List!(String) generateMessages()
    {
        SSDPMessageBuilder builder = new SearchResponseMessageBuilder();
        return builder.generateSSDPMessages(Integer.valueOf(this.advertisementDuration), this.searchTarget);
    }

    private void sendReply(List!(String) messages)
    {
        DatagramSocket socket = null;
        int messageTimeout = getTimeToRespond(messages);
        try
        {
            socket = MultiCastUtils.startUniCastSocket();
            if ((socket !is null) && (socket.isBound())) {
                foreach (String message ; messages)
                {
                    ThreadUtils.currentThreadSleep(NumberUtils.getRandomInInterval(0, messageTimeout * 1000));

                    MultiCastUtils.send(message, socket, this.sourceAddress);
                }
            } else {
                log.warn("Cannot respond to SSDP M-SEARCH message. Not connected to a socket.");
            }
        }
        catch (SocketTimeoutException ex)
        {
            log.debug_("Socket timed out: " ~ ex.getMessage() ~ ", response will not be sent");
        }
        catch (IOException e)
        {
            log.warn("Problem during DiscoverySearchResponder, response will not be sent", e);
        }
        catch (Exception e)
        {
            log.error("Fatal error during DiscoverySearchResponder, response will not be sent", e);
        }
        finally
        {
            if (socket !is null) {
                socket.close();
            }
        }
    }

    private int getTimeToRespond(List!(String) messages)
    {
        if (this.timeToRespond > 120) {
            this.timeToRespond = 120;
        }
        int mx = this.timeToRespond / messages.size();
        return mx;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.discovery.DiscoverySearchResponder
* JD-Core Version:    0.7.0.1
*/