module org.serviio.upnp.discovery.RendererSearchSender;

import java.io.IOException;
import java.net.DatagramPacket;
import java.net.InetAddress;
import java.net.MulticastSocket;
import java.net.SocketTimeoutException;
import java.util.List;
import org.apache.http.Header;
import org.apache.http.HttpException;
import org.apache.http.HttpResponse;
import org.apache.http.StatusLine;
import org.serviio.upnp.Device;
import org.serviio.upnp.protocol.http.HttpMessageParser;
import org.serviio.upnp.protocol.ssdp.SSDPMessageBuilderFactory;
import org.serviio.upnp.protocol.ssdp.SSDPMessageBuilderFactory:SSDPMessageType;
import org.serviio.upnp.protocol.ssdp.SSDPRequestMessageBuilder;
import org.serviio.util.HttpUtils;
import org.serviio.util.MultiCastUtils;
import org.serviio.util.NicIP;
import org.serviio.util.ServiioThreadFactory;
import org.serviio.util.ThreadExecutor;
import org.slf4j.Logger;

public class RendererSearchSender : AbstractSSDPMessageListener
{
    private int mx;
    private int searchSendCount;

    public this(int mx, int searchSendCount)
    {
        this.mx = mx;
        this.searchSendCount = searchSendCount;
    }

    public void searchForRenderers()
    {
        NicIP iface = getBoundNIC();
        this.log.info(String.format("Searching for Renderer devices", new Object[0]));

        Thread t = ServiioThreadFactory.getInstance().newThread(new RendererSearchWorker(iface));
        t.start();
        try
        {
            t.join();
        }
        catch (InterruptedException ignore) {}
        this.log.debug_("Finished searching for Renderer devices");
    }

    private class RendererSearchWorker
        : AbstractSSDPMessageListener
        , Runnable
    {
        private NicIP multicastInterface;

        public this(NicIP multicastInterface)
        {
            this.multicastInterface = multicastInterface;
        }

        public void run()
        {
            try
            {
                sendSearchToSingleInterface(this.multicastInterface);
            }
            catch (IOException e)
            {
                this.log.warn(String.format("Search for Renderers using interface %s failed: %s", cast(Object[])[ MultiCastUtils.getInterfaceName(this.multicastInterface.getNic()), e.getMessage() ]));
            }
        }

        private void sendSearchToSingleInterface(NicIP multicastInterface)
        {
            MulticastSocket socket = null;
            Device device = Device.getInstance();
            InetAddress address = multicastInterface.getIp();
            if (address !is null) {
                try
                {
                    socket = MultiCastUtils.startMultiCastSocketForSending(multicastInterface.getNic(), address, 32);
                    if ((socket !is null) && (socket.isBound()))
                    {
                        this.log.debug_(String.format("Multicasting SSDP M-SEARCH using interface %s and address %s, timeout = %s", cast(Object[])[ MultiCastUtils.getInterfaceName(multicastInterface.getNic()), address.getHostAddress(), Integer.valueOf(socket.getSoTimeout()) ]));


                        List!(String) messages = SSDPMessageBuilderFactory.getInstance().getBuilder(SSDPMessageBuilderFactory.SSDPMessageType.SEARCH).generateSSDPMessages(Integer.valueOf(this.outer.mx), "urn:schemas-upnp-org:device:MediaRenderer:1");

                        this.log.debug_(String.format("Sending %s 'm-search' messages", cast(Object[])[ Integer.valueOf(messages.size()) ]));
                        foreach (String message ; messages) {
                            for (int i = 0; i < this.outer.searchSendCount; i++) {
                                MultiCastUtils.send(message, socket, device.getMulticastGroupAddress());
                            }
                        }
                        waitForResponses(socket, this.outer.mx + 2);
                    }
                    else
                    {
                        this.log.warn("Cannot multicast SSDP M-SEARCH message. Not connected to a socket.");
                    }
                }
                finally
                {
                    MultiCastUtils.stopMultiCastSocket(socket, device.getMulticastGroupAddress(), false);
                }
            }
        }

        private void waitForResponses(MulticastSocket socket, int mx)
        {
            long startTime = System.currentTimeMillis();
            int remainingTimeout = 1;
            while (remainingTimeout > 0)
            {
                remainingTimeout = mx * 1000 - new Long(System.currentTimeMillis() - startTime).intValue();
                if (remainingTimeout > 0) {
                    try
                    {
                        socket.setSoTimeout(remainingTimeout);
                        DatagramPacket receivedPacket = MultiCastUtils.receive(socket);
                        HttpResponse response = HttpMessageParser.parseHttpResponse(MultiCastUtils.getPacketData(receivedPacket));
                        if (response.getStatusLine().getStatusCode() == 200) {
                            processSearchResponse(response, receivedPacket);
                        } else {
                            this.log.debug_("Received HTTP error " + response.getStatusLine().getStatusCode());
                        }
                    }
                    catch (HttpException e)
                    {
                        this.log.debug_("Received message is not HTTP message");
                    }
                    catch (SocketTimeoutException e)
                    {
                        remainingTimeout = -1;
                    }
                    catch (IOException e)
                    {
                        this.log.debug_("Cannot receive HTTP message: " + e.getMessage());
                    }
                }
            }
        }

        private void processSearchResponse(HttpResponse response, DatagramPacket receivedPacket)
        {
            Header headerCacheControl = response.getFirstHeader("CACHE-CONTROL");
            Header headerLocation = response.getFirstHeader("LOCATION");
            Header headerST = response.getFirstHeader("ST");
            Header headerSERVER = response.getFirstHeader("SERVER");
            Header headerUSN = response.getFirstHeader("USN");
            this.log.debug_(String.format("Received search response: location: %s, st: %s", cast(Object[])[ headerLocation.getValue(), headerST.getValue() ]));
            if ((headerST !is null) && (headerST.getValue().equals("urn:schemas-upnp-org:device:MediaRenderer:1")) && (headerUSN !is null) && (headerSERVER !is null)) {
                try
                {
                    String server = headerSERVER.getValue().trim();
                    String deviceUuid = getDeviceUuidFromUSN(headerUSN.getValue());
                    String descriptionURL = headerLocation !is null ? headerLocation.getValue() : null;
                    if (deviceUuid !is null)
                    {
                        int timeToKeep = HttpUtils.getMaxAgeFromHeader(headerCacheControl);
                        String deviceIP = getDeviceIPAddress(descriptionURL, receivedPacket.getSocketAddress());
                        if (this.log.isDebugEnabled()) {
                            this.log.debug_(String.format("Received a valid M-SEARCH response from Renderer %s from address %s", cast(Object[])[ deviceUuid, deviceIP ]));
                        }
                        ThreadExecutor.execute(new RendererSearchResponseProcessor(deviceIP, deviceUuid, server, timeToKeep, descriptionURL));
                    }
                    else
                    {
                        this.log.warn(String.format("Provided USN value is invalid: %s. Will not process the search reply.", cast(Object[])[ headerUSN.getValue() ]));
                    }
                }
                catch (NumberFormatException e)
                {
                    this.log.warn(String.format("Invalid header value: %s. Will not respond to the request.", cast(Object[])[ e.getMessage() ]));
                }
            }
        }
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.discovery.RendererSearchSender
* JD-Core Version:    0.7.0.1
*/