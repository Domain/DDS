module org.serviio.upnp.service.connectionmanager.ConnectionManager;

import java.lang;
import java.util.LinkedHashSet;
import java.util.Map;
import java.util.Map:Entry;
import java.util.Set;
import org.serviio.dlna.MediaFormatProfile;
import org.serviio.profile.Profile;
import org.serviio.profile.ProfileManager;
import org.serviio.renderer.entities.Renderer;
import org.serviio.upnp.protocol.soap.InvocationError;
import org.serviio.upnp.protocol.soap.OperationResult;
import org.serviio.upnp.protocol.soap.SOAPParameter;
import org.serviio.upnp.service.Service;
import org.serviio.upnp.service.StateVariable;
import org.serviio.upnp.service.contentdirectory.ProtocolInfo;
import org.serviio.util.CollectionUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class ConnectionManager : Service
{
    private static Logger log = LoggerFactory.getLogger!(ConnectionManager);
    private static immutable int CONNECTION_ID = 0;
    private static immutable String VAR_A_ARG_TYPE_ProtocolInfo = "A_ARG_TYPE_ProtocolInfo";
    private static immutable String VAR_A_ARG_TYPE_ConnectionStatus = "A_ARG_TYPE_ConnectionStatus";
    private static immutable String VAR_SinkProtocolInfo = "SinkProtocolInfo";
    private static immutable String VAR_A_ARG_TYPE_ConnectionID = "A_ARG_TYPE_ConnectionID";
    private static immutable String VAR_SourceProtocolInfo = "SourceProtocolInfo";
    private static immutable String VAR_CurrentConnectionIDs = "CurrentConnectionIDs";
    private static immutable String VAR_A_ARG_TYPE_AVTransportID = "A_ARG_TYPE_AVTransportID";
    private static immutable String VAR_A_ARG_TYPE_RcsID = "A_ARG_TYPE_RcsID";
    private static immutable String VAR_A_ARG_TYPE_ConnectionManager = "A_ARG_TYPE_ConnectionManager";
    private static immutable String VAR_A_ARG_TYPE_Direction = "A_ARG_TYPE_Direction";

    override protected void setupService()
    {
        this.serviceId = "urn:upnp-org:serviceId:ConnectionManager";
        this.serviceType = "urn:schemas-upnp-org:service:ConnectionManager:1";
        setupStateVariables();
    }

    private void setupStateVariables()
    {
        this.stateVariables.add(new StateVariable("A_ARG_TYPE_ProtocolInfo", null));
        this.stateVariables.add(new StateVariable("A_ARG_TYPE_ConnectionStatus", "OK"));
        this.stateVariables.add(new StateVariable("SinkProtocolInfo", null, true, 0));
        this.stateVariables.add(new StateVariable("A_ARG_TYPE_ConnectionID", Integer.valueOf(0)));
        this.stateVariables.add(new StateVariable("SourceProtocolInfo", null, true, 0));
        this.stateVariables.add(new StateVariable("CurrentConnectionIDs", Integer.toString(0), true, 0));
        this.stateVariables.add(new StateVariable("A_ARG_TYPE_AVTransportID", "-1"));
        this.stateVariables.add(new StateVariable("A_ARG_TYPE_RcsID", "-1"));
        this.stateVariables.add(new StateVariable("A_ARG_TYPE_ConnectionManager", null));
        this.stateVariables.add(new StateVariable("A_ARG_TYPE_Direction", "Output"));
    }

    public OperationResult GetProtocolInfo(Renderer renderer)
    {
        Profile rendererProfile = ProfileManager.getProfile(renderer);
        OperationResult result = new OperationResult();
        result.addOutputParameter("Source", getSourceProtocolInfo(rendererProfile));
        result.addOutputParameter("Sink", getStateVariable("SinkProtocolInfo").getValue());
        return result;
    }

    public OperationResult GetCurrentConnectionIDs()
    {
        OperationResult result = new OperationResult();
        result.addOutputParameter("ConnectionIDs", getStateVariable("CurrentConnectionIDs").getValue());
        return result;
    }

    public OperationResult GetCurrentConnectionInfo(/*@SOAPParameter("ConnectionID")*/ Integer connectionId)
    {
        OperationResult result = new OperationResult();
        if ((connectionId is null) || (!connectionId.equals(getStateVariable("A_ARG_TYPE_ConnectionID").getValue())))
        {
            result.setError(InvocationError.CON_MAN_INVALID_CONNECTION_REFERENCE);
        }
        else
        {
            result.addOutputParameter("RcsID", getStateVariable("A_ARG_TYPE_RcsID").getValue());
            result.addOutputParameter("AVTransportID", getStateVariable("A_ARG_TYPE_AVTransportID").getValue());
            result.addOutputParameter("ProtocolInfo", getStateVariable("A_ARG_TYPE_ProtocolInfo").getValue());
            result.addOutputParameter("PeerConnectionManager", getStateVariable("A_ARG_TYPE_ConnectionManager").getValue());
            result.addOutputParameter("PeerConnectionID", getStateVariable("A_ARG_TYPE_ConnectionID").getValue());
            result.addOutputParameter("Direction", getStateVariable("A_ARG_TYPE_Direction").getValue());
            result.addOutputParameter("Status", getStateVariable("A_ARG_TYPE_ConnectionStatus").getValue());
        }
        return result;
    }

    private String getSourceProtocolInfo(Profile profile)
    {
        log.debug_(String.format("Sending protocol info using profile '%s'", cast(Object[])[ profile ]));
        Set!(String) protocolInfos = new LinkedHashSet();
        foreach (Map.Entry!(MediaFormatProfile, ProtocolInfo) entry ; profile.getProtocolInfo().entrySet()) {
            protocolInfos.addAll((cast(ProtocolInfo)entry.getValue()).getProfileProtocolInfo((cast(MediaFormatProfile)entry.getKey()).getFileType()));
        }
        return CollectionUtils.listToCSV(protocolInfos, ",", false);
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.service.connectionmanager.ConnectionManager
* JD-Core Version:    0.7.0.1
*/