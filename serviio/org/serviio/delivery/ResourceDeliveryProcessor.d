module org.serviio.delivery.ResourceDeliveryProcessor;

import java.lang;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.Map;
import org.apache.http.ProtocolVersion;
import org.serviio.dlna.MediaFormatProfile;
import org.serviio.dlna.UnsupportedDLNAMediaFileFormatException;
import org.serviio.upnp.protocol.http.transport.InvalidResourceRequestException;
import org.serviio.upnp.protocol.http.transport.RequestedResourceDescriptor;
import org.serviio.upnp.protocol.http.transport.ResourceTransportProtocolHandler;
import org.serviio.upnp.service.contentdirectory.classes.Resource:ResourceType;
import org.serviio.util.ObjectValidator;
import org.serviio.delivery;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public enum HttpMethod
{
    GET,  HEAD
}

public class ResourceDeliveryProcessor
{
    private static Logger log;
    private ResourceRetrievalStrategyFactory resourceRetrievalStrategyFactory;
    private HEADMethodProcessor headMethodProcessor;
    private GETMethodProcessor getMethodProcessor;

    static this()
    {
        log = LoggerFactory.getLogger!(ResourceDeliveryProcessor);
    }

    public this(ResourceRetrievalStrategyFactory resourceRetrievalStrategyFactory)
    {
        headMethodProcessor = new HEADMethodProcessor();
        getMethodProcessor = new GETMethodProcessor();
        this.resourceRetrievalStrategyFactory = resourceRetrievalStrategyFactory;
    }

    public HttpDeliveryContainer deliverContent(String requestUri, HttpMethod method, ProtocolVersion httpVersion, Map!(String, String) requestHeaders, RangeHeaders rangeHeaders, ResourceTransportProtocolHandler protocolHandler, Client client)
    {
        log.debug_(java.lang.String.format("Resource request accepted. Using client '%s'", cast(Object[])[ client ]));
        try
        {
            RequestedResourceDescriptor resourceReq = protocolHandler.getRequestedResourceDescription(requestUri, client);
            log.debug_(java.lang.String.format("Request for resource %s and type '%s' received", cast(Object[])[ resourceReq.getResourceId() !is null ? resourceReq.getResourceId().toString() : resourceReq.getPath(), resourceReq.getResourceType().toString() ]));


            ResourceRetrievalStrategy resourceRetrievalStrategy = this.resourceRetrievalStrategyFactory.instantiateResourceRetrievalStrategy(resourceReq.getResourceType());

            AbstractMethodProcessor processor = null;
            if (method == HttpMethod.GET) {
                processor = this.getMethodProcessor;
            } else if (method == HttpMethod.HEAD) {
                processor = this.headMethodProcessor;
            } else {
                throw new HttpResponseCodeException(405);
            }
            MediaFormatProfile selectedVersion = getSelectedVersion(resourceReq.getTargetProfileName());
            ResourceInfo resourceInfo = resourceRetrievalStrategy.retrieveResourceInfo(resourceReq.getResourceId(), selectedVersion, resourceReq.getQuality(), resourceReq.getPath(), client);
            return processor.handleRequest(resourceRetrievalStrategy, resourceInfo, selectedVersion, resourceReq.getQuality(), resourceReq.getPath(), requestHeaders, rangeHeaders, httpVersion, resourceReq.getProtocolInfoIndex(), client, protocolHandler);
        }
        catch (FileNotFoundException e)
        {
            log.warn(java.lang.String.format("Error while processing resource, sending back 404 error. Message: %s", cast(Object[])[ e.getMessage() ]));
            throw new HttpResponseCodeException(404);
        }
        catch (InvalidResourceRequestException e)
        {
            log.warn("Invalid request, sending back 400 error", e);
            throw new HttpResponseCodeException(400);
        }
        catch (UnsupportedDLNAMediaFileFormatException e)
        {
            log.warn("Invalid request, sending back 500 error", e);
            throw new HttpResponseCodeException(500);
        }
        throw new HttpResponseCodeException(500);
    }

    private MediaFormatProfile getSelectedVersion(String profileName)
    {
        if (ObjectValidator.isNotEmpty(profileName)) {
            try
            {
                return valueOf!MediaFormatProfile(profileName);
            }
            catch (IllegalArgumentException e)
            {
                log.warn(java.lang.String.format("Requested DLNA media format profile %s is not supported, using original profile of the media", cast(Object[])[ profileName ]));
                return cast(MediaFormatProfile)-1;
            }
        }
        return cast(MediaFormatProfile)-1;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.delivery.ResourceDeliveryProcessor
* JD-Core Version:    0.7.0.1
*/