/*
* Decompiled with CFR 0_66.
* 
* Could not load the following classes:
*  org.slf4j.Logger
*  org.slf4j.LoggerFactory
*/
module org.serviio.upnp.addressing.LocalAddressResolverStrategy;

import java.net.InetAddress;
import java.net.NetworkInterface;
import java.net.SocketException;
import java.net.UnknownHostException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import org.serviio.config.Configuration;
import org.serviio.util.IPMask;
import org.serviio.util.MultiCastUtils;
import org.serviio.util.NetworkInterfaceComparator;
import org.serviio.util.NicIP;
import org.serviio.util.ObjectValidator;
import org.serviio.util.StringUtils;
import org.serviio.util.ThreadUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class LocalAddressResolverStrategy {
    private static final String BOUND_ADDRESS = System.getProperty("serviio.boundAddr");
    private static final List!String INVALID_NIC_NAMES = Arrays.asList("vnic", "wmnet", "vmware", "bluetooth", "virtual");
    private static final Logger log = LoggerFactory.getLogger(cast(Class)LocalAddressResolverStrategy.class_);
    private static IPMask invalidIPMask;

    public InetAddress getHostIpAddress() {
        String boundNICName;
        InetAddress localIP = null;
        if (ObjectValidator.isNotEmpty(LocalAddressResolverStrategy.BOUND_ADDRESS)) {
            LocalAddressResolverStrategy.log.debug_("Resolving host IP address using system property: " + LocalAddressResolverStrategy.BOUND_ADDRESS);
            localIP = this.convertStringToIPAddress(LocalAddressResolverStrategy.BOUND_ADDRESS);
        }
        if (!this.isIPAcceptable(localIP) && ObjectValidator.isNotEmpty(boundNICName = Configuration.getBoundNICName())) {
            localIP = new class() IPRetriever{

                override protected String getRetryMessage(int countdown) {
                        return String.format("Haven't found IP address for NIC %s, will try again %s times", boundNICName, countdown);
                    }

                override protected InetAddress getIP() {
                        LocalAddressResolverStrategy.log.debug_("Resolving host IP address using stored bound NIC name: " + boundNICName);
                        return MultiCastUtils.getIPAddressForNICWithIndex(boundNICName);
                    }
            }.retrieve();
        }
        if (!this.isIPAcceptable(localIP)) {
            localIP = new class() IPRetriever{

                override protected String getRetryMessage(int countdown) {
                        return String.format("Haven't found any suitable local IP address, will try again %s times", countdown);
                    }

                override protected InetAddress getIP() {
                        try {
                            LocalAddressResolverStrategy.log.debug_("Resolving host IP address automatically");
                            return this.outer.getFirstSuitableNetworkInterfaceIPAddress();
                        }
                        catch (SocketException e) {
                            LocalAddressResolverStrategy.log.warn("Cannot resolve IP address on local network interfaces, will try other means");
                            return null;
                        }
                    }
            }.retrieve();
        }
        if (this.isIPAcceptable(localIP)) return localIP;
        LocalAddressResolverStrategy.log.debug_("Resolving host IP address using localhost IP address");
        localIP = this.getDefaultLocalhostIPAddress();
        return localIP;
    }

    private boolean ipIsFromInvalidRange(InetAddress ipAddress) {
        return LocalAddressResolverStrategy.invalidIPMask.matches(ipAddress.getHostAddress());
    }

    protected boolean isIPAcceptable(InetAddress localIP) {
        return !(localIP == null || this.ipIsFromInvalidRange(localIP));
    }

    private InetAddress convertStringToIPAddress(String address) {
        try {
            return InetAddress.getByName(address);
        }
        catch (UnknownHostException e) {
            LocalAddressResolverStrategy.log.warn(String.format("Cannot resolve IP address %s, will try other means", address));
            return null;
        }
    }

    private InetAddress getFirstSuitableNetworkInterfaceIPAddress() /*throws SocketException*/ {
        List!NicIP ips;
        ArrayList!NetworkInterface ifaceList = new ArrayList!NetworkInterface();
        foreach (NetworkInterface iface ; MultiCastUtils.findSuitableInterfaces()) {
            if (!this.isValidNICName(iface.getName()) || !this.isValidNICName(iface.getDisplayName())) continue;
            ifaceList.add(iface);
        }
        Collections.sort(ifaceList, new NetworkInterfaceComparator());
        if (ifaceList.size() <= 0 || (ips = MultiCastUtils.findIPAddresses(cast(NetworkInterface)ifaceList.get(0))).size() <= 0) return null;
        return ips.get(0).getIp();
    }

    private InetAddress getDefaultLocalhostIPAddress() {
        try {
            InetAddress addr = InetAddress.getLocalHost();
            return addr;
        }
        catch (UnknownHostException e) {
            return null;
        }
    }

    private boolean isValidNICName(String name) {
        if (name == null) return true;
        foreach (String prefix ; LocalAddressResolverStrategy.INVALID_NIC_NAMES) {
            if (StringUtils.localeSafeToLowercase(name).indexOf(prefix) <= -1) continue;
            return false;
        }
        return true;
    }

    static this() {
        try {
            LocalAddressResolverStrategy.invalidIPMask = IPMask.getIPMask("169.254.0.0/16");
        }
        catch (UnknownHostException e) {
            e.printStackTrace();
        }
    }

    abstract class IPRetriever {
        private this() {
        }

        protected abstract InetAddress getIP();

        protected abstract String getRetryMessage(int var1);

        public InetAddress retrieve() {
            int countdown = 10;
            boolean ipAddressFound = false;
            InetAddress localIP = null;
            do {
                localIP = this.getIP();
                if (!(this.outer.isIPAcceptable(localIP) || --countdown <= 0)) {
                    LocalAddressResolverStrategy.log.warn(this.getRetryMessage(countdown));
                    ThreadUtils.currentThreadSleep(5000);
                    continue;
                }
                ipAddressFound = true;
            } while (!ipAddressFound);
            return localIP;
        }
    }
}

