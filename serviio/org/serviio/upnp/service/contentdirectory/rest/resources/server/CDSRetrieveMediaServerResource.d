module org.serviio.upnp.service.contentdirectory.rest.resources.server.CDSRetrieveMediaServerResource;

import java.lang;
import java.io.IOException;
import java.util.Arrays;
import java.util.Map;
import org.apache.http.HttpVersion;
import org.restlet.Request;
import org.restlet.Response;
import org.restlet.data.CacheDirective;
import org.restlet.data.ClientInfo;
import org.restlet.data.MediaType;
import org.restlet.data.Protocol;
import org.restlet.data.Range;
import org.restlet.data.Reference;
import org.restlet.data.ServerInfo;
import org.restlet.data.Status;
import org.restlet.representation.Representation;
import org.restlet.representation.StreamRepresentation;
import org.serviio.delivery.Client;
import org.serviio.delivery.HttpDeliveryContainer;
import org.serviio.delivery.HttpResponseCodeException;
import org.serviio.delivery.RangeHeaders;
import org.serviio.delivery.RangeHeaders:RangeDefinition;
import org.serviio.delivery.RangeHeaders:RangeUnit;
import org.serviio.delivery.ResourceDeliveryProcessor;
import org.serviio.delivery.ResourceDeliveryProcessor:HttpMethod;
import org.serviio.delivery.ResourceRetrievalStrategyFactory;
import org.serviio.profile.Profile;
import org.serviio.profile.ProfileManager;
import org.serviio.restlet.HttpCodeException;
import org.serviio.upnp.protocol.http.transport.CDSProtocolHandler;
import org.serviio.upnp.service.contentdirectory.classes.Resource:ResourceType;
import org.serviio.upnp.service.contentdirectory.rest.representation.ClosingInputRepresentation;
import org.serviio.upnp.service.contentdirectory.rest.resources.CDSRetrieveMediaResource;
import org.serviio.upnp.service.contentdirectory.rest.resources.server.AbstractRestrictedCDSServerResource;
import org.serviio.util.HttpUtils;
import org.serviio.util.ObjectValidator;
import org.slf4j.Logger;

public class CDSRetrieveMediaServerResource : AbstractRestrictedCDSServerResource, CDSRetrieveMediaResource
{
    private static immutable int CACHE_SECONDS = 36000;
    public static immutable String RESOURCE_CONTEXT = "/resource";
    private static immutable String PARAM_CLIENT_ID = "clientId";
    private static ResourceRetrievalStrategyFactory resourceRetrievalStrategyFactory = new ResourceRetrievalStrategyFactory();
    private Profile profile;

    public StreamRepresentation deliver()
    {
        Request request = getRequest();
        this.log.debug_(request.toString() + ", headers = " + HttpUtils.headersToString(getRequestHeaders(getRequest())));
        ResourceDeliveryProcessor processor = new ResourceDeliveryProcessor(resourceRetrievalStrategyFactory);

        storeProfileFromPath();
        String normalizedPath = request.getOriginalRef().getPath();
        try
        {
            Map!(String, String) requestHeaders = getRequestHeaders(request);
            HttpDeliveryContainer container = processor.deliverContent(normalizedPath, HttpMethod.GET, getProtocol().getVersion().equals("1.1") ? HttpVersion.HTTP_1_1 : HttpVersion.HTTP_1_0, requestHeaders, parseRequestRangeHeaders(requestHeaders, request), new CDSProtocolHandler(), getClient(requestHeaders));


            ClosingInputRepresentation rep = new ClosingInputRepresentation(container.getContentStream(), getMediaType(container.getResponseHeaders()), getFullStreamSize(container), getDeliveredStreamSize(container), getRequest());

            getResponse().setEntity(rep);
            getResponse().setDimensions(null);
            if (container.isPartialContent()) {
                setRange(container.getResponseHeaders());
            }
            if (!container.isTranscoded()) {
                getResponse().getServerInfo().setAcceptingRanges(true);
            }
            getResponse().setStatus(container.isPartialContent() ? Status.SUCCESS_PARTIAL_CONTENT : Status.SUCCESS_OK);
            if (normalizedPath.indexOf(ResourceType.COVER_IMAGE.toString()) > -1) {
                getResponse().setCacheDirectives(Arrays.asList(cast(CacheDirective[])[ new CacheDirective(String.format("private, max-age=%s", [ Integer.valueOf(36000) ])) ]));
                                                 }
                return rep;
            }
            catch (HttpResponseCodeException e)
            {
                throw new HttpCodeException(e.getHttpCode(), e.getMessage(), e.getCause());
            }
        }

        private void storeProfileFromPath()
        {
            String profile = getRequestQueryParam("profile");
            if (ObjectValidator.isNotEmpty(profile))
            {
                this.profile = ProfileManager.getProfileById(profile);
                if (this.profile !is null) {
                    return;
                }
            }
            this.log.warn("Request doesn't include profile id or the profile is invalid");
            throw new HttpCodeException(400);
        }

        private Client getClient(Map!(String, String) requestHeaders)
        {
            String clientId = getRequestQueryParam("clientId");
            if (ObjectValidator.isEmpty(clientId)) {
                clientId = getHeaderStringValue("X-Serviio-ClientId", requestHeaders);
            }
            if (ObjectValidator.isEmpty(clientId)) {
                clientId = getClientInfo().getAddress();
            }
            this.log.debug_(String.format("Creating client with id '%s'", cast(Object[])[ clientId ]));
            Client c = new Client(clientId, this.profile, getHostInfo(true, true, this.profile.getId()));
            c.setExpectsClosedConnection(true);
            c.setSupportsRandomTimeSeek(true);
            return c;
        }

        private void setRange(Map!(String, Object) headers)
        {
            RangeHeaders range = getResponseRangeHeader(headers);
            if (range !is null)
            {
                if (range.hasHeaders(RangeUnit.BYTES)) {
                    getResponse().getEntity().setRange(new Range(range.getStartAsLong(RangeUnit.BYTES).longValue(), range.getEndAsLong(RangeUnit.BYTES).longValue() - range.getStartAsLong(RangeUnit.BYTES).longValue() + 1L));
                }
                if (range.hasHeaders(RangeUnit.SECONDS))
                {
                    Range rangeHeader = new Range(range.getStartAsLong(RangeUnit.SECONDS).longValue(), range.getEndAsLong(RangeUnit.SECONDS).longValue() - range.getStartAsLong(RangeUnit.SECONDS).longValue());
                    rangeHeader.setUnitName("seconds");
                    rangeHeader.setTotalSize(range.getTotal(RangeUnit.SECONDS));
                    getResponse().getEntity().setRange(rangeHeader);
                }
            }
        }

        private RangeHeaders getResponseRangeHeader(Map!(String, Object) headers)
        {
            RangeHeaders range = cast(RangeHeaders)headers.get("Content-Range");
            return range;
        }

        private long getFullStreamSize(HttpDeliveryContainer container)
        {
            RangeHeaders range = getResponseRangeHeader(container.getResponseHeaders());
            if ((container.isPartialContent()) && (range !is null) && (range.hasHeaders(RangeUnit.BYTES))) {
                return range.getTotal(RangeUnit.BYTES).longValue();
            }
            return container.getFileSize().longValue();
        }

        private Long getDeliveredStreamSize(HttpDeliveryContainer container)
        {
            RangeHeaders range = getResponseRangeHeader(container.getResponseHeaders());
            if ((container.isPartialContent()) && (range !is null) && (range.hasHeaders(RangeUnit.BYTES))) {
                return Long.valueOf(range.getEndAsLong(RangeUnit.BYTES).longValue() - range.getStartAsLong(RangeUnit.BYTES).longValue() + 1L);
            }
            return null;
        }

        private MediaType getMediaType(Map!(String, Object) headers)
        {
            String contentType = getHeaderStringValue("Content-Type", headers);
            if (contentType !is null) {
                return new MediaType(contentType);
            }
            return null;
        }

        private RangeHeaders parseRequestRangeHeaders(Map!(String, String) headers, Request request)
        {
            String rangeHeader = cast(String)headers.get("Range");
            String startSecond = getRequestQueryParam("start");
            try
            {
                return RangeHeaders.parseHttpRange(RangeDefinition.CDS, rangeHeader, startSecond);
            }
            catch (NumberFormatException e)
            {
                this.log.debug_("Unsupported range request, sending back 400");
                throw new HttpResponseCodeException(400);
            }
        }
    }


    /* Location:           C:\Users\Main\Downloads\serviio.jar
    * Qualified Name:     org.serviio.upnp.service.contentdirectory.rest.resources.server.CDSRetrieveMediaServerResource
    * JD-Core Version:    0.7.0.1
    */