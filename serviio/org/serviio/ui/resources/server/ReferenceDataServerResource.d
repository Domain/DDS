module org.serviio.ui.resources.server.ReferenceDataServerResource;

import java.net.InetAddress;
import java.net.NetworkInterface;
import java.net.SocketException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import org.restlet.data.Status;
import org.restlet.resource.ResourceException;
import org.serviio.db.dao.DAOFactory;
import org.serviio.i18n.Language;
import org.serviio.library.dao.AccessGroupDAO;
import org.serviio.library.entities.AccessGroup;
import org.serviio.library.entities.OnlineRepository:OnlineRepositoryType;
import org.serviio.library.local.metadata.extractor.ExtractorType;
import org.serviio.library.local.metadata.extractor.video.MetadataLanguages;
import org.serviio.library.online.PreferredQuality;
import org.serviio.profile.DeliveryQuality:QualityType;
import org.serviio.profile.Profile;
import org.serviio.profile.ProfileManager;
import org.serviio.restlet.AbstractServerResource;
import org.serviio.ui.representation.ReferenceDataRepresentation;
import org.serviio.ui.resources.ReferenceDataResource;
import org.serviio.upnp.service.contentdirectory.definition.ContainerVisibilityType;
import org.serviio.upnp.service.contentdirectory.definition.i18n.BrowsingCategoriesLanguages;
import org.serviio.util.MultiCastUtils;
import org.serviio.util.NetworkInterfaceComparator;
import org.serviio.util.NicIP;
import org.serviio.util.ObjectValidator;
import org.serviio.util.StringUtils;
import org.slf4j.Logger;

public class ReferenceDataServerResource
  : AbstractServerResource
  , ReferenceDataResource
{
  private String name;
  
  public ReferenceDataRepresentation load()
  {
    return getData();
  }
  
  protected void doInit()
  {
    this.name = (cast(String)getRequestAttributes().get("name"));
  }
  
  private ReferenceDataRepresentation getData()
  {
    if (ObjectValidator.isEmpty(this.name))
    {
      setStatus(Status.CLIENT_ERROR_BAD_REQUEST);
    }
    else
    {
      if (this.name.equalsIgnoreCase("cpu-cores")) {
        return new ReferenceDataRepresentation("numberOfCPUCores", String.valueOf(getNumberOfCPUCores()));
      }
      if (this.name.equalsIgnoreCase("profiles")) {
        return getProfiles();
      }
      if (this.name.equalsIgnoreCase("metadataLanguages")) {
        return getMetadataLanguages();
      }
      if (this.name.equalsIgnoreCase("browsingCategoriesLanguages")) {
        return getBrowsingCategoriesLanguages();
      }
      if (this.name.equalsIgnoreCase("descriptiveMetadataExtractors")) {
        return getDescriptionMetadataExtractors();
      }
      if (this.name.equalsIgnoreCase("categoryVisibilityTypes")) {
        return getCategoryVisibilityTypes();
      }
      if (this.name.equalsIgnoreCase("onlineRepositoryTypes")) {
        return getOnlineRepositoryTypes();
      }
      if (this.name.equalsIgnoreCase("onlineContentQualities")) {
        return getOnlineContentQualities();
      }
      if (this.name.equalsIgnoreCase("accessGroups")) {
        return getAccessGroups();
      }
      if (this.name.equalsIgnoreCase("remoteDeliveryQualities")) {
        return getRemoteDeliveryQualities();
      }
      if (this.name.equalsIgnoreCase("networkInterfaces")) {
        return getNetworkInterfaces();
      }
      setStatus(Status.CLIENT_ERROR_BAD_REQUEST);
    }
    return null;
  }
  
  private int getNumberOfCPUCores()
  {
    return Runtime.getRuntime().availableProcessors();
  }
  
  private ReferenceDataRepresentation getProfiles()
  {
    ReferenceDataRepresentation rep = new ReferenceDataRepresentation();
    List!(Profile) allProfiles = ProfileManager.getAllSelectableProfiles();
    Collections.sort(allProfiles);
    foreach (Profile pd ; allProfiles) {
      rep.addValue(pd.getId(), pd.getName());
    }
    return rep;
  }
  
  private ReferenceDataRepresentation getMetadataLanguages()
  {
    ReferenceDataRepresentation rep = new ReferenceDataRepresentation();
    foreach (Language l ; MetadataLanguages.getLanguages()) {
      rep.addValue(l.getCode(), l.getName());
    }
    return rep;
  }
  
  private ReferenceDataRepresentation getBrowsingCategoriesLanguages()
  {
    ReferenceDataRepresentation rep = new ReferenceDataRepresentation();
    foreach (Language l ; BrowsingCategoriesLanguages.getLanguages()) {
      rep.addValue(l.getCode(), l.getName());
    }
    return rep;
  }
  
  private ReferenceDataRepresentation getDescriptionMetadataExtractors()
  {
    ReferenceDataRepresentation rep = new ReferenceDataRepresentation();
    rep.addValue("NONE", "No descriptive metadata");
    rep.addValue(ExtractorType.ONLINE_VIDEO_SOURCES.toString(), "Online metadata sources");
    rep.addValue(ExtractorType.SWISSCENTER.toString(), "Swisscenter");
    rep.addValue(ExtractorType.XBMC.toString(), "XBMC .nfo files");
    rep.addValue(ExtractorType.MYMOVIES.toString(), "MyMovies");
    return rep;
  }
  
  private ReferenceDataRepresentation getCategoryVisibilityTypes()
  {
    ReferenceDataRepresentation rep = new ReferenceDataRepresentation();
    rep.addValue(ContainerVisibilityType.DISPLAYED.toString(), "Display category");
    rep.addValue(ContainerVisibilityType.CONTENT_DISPLAYED.toString(), "Display content only");
    rep.addValue(ContainerVisibilityType.DISABLED.toString(), "Disabled");
    return rep;
  }
  
  private ReferenceDataRepresentation getOnlineRepositoryTypes()
  {
    ReferenceDataRepresentation rep = new ReferenceDataRepresentation();
    rep.addValue(OnlineRepositoryType.FEED.toString(), "RSS/Atom feed");
    rep.addValue(OnlineRepositoryType.LIVE_STREAM.toString(), "Live stream");
    rep.addValue(OnlineRepositoryType.WEB_RESOURCE.toString(), "Web Resource");
    return rep;
  }
  
  private ReferenceDataRepresentation getOnlineContentQualities()
  {
    ReferenceDataRepresentation rep = new ReferenceDataRepresentation();
    rep.addValue(PreferredQuality.LOW.toString(), "Low");
    rep.addValue(PreferredQuality.MEDIUM.toString(), "Medium");
    rep.addValue(PreferredQuality.HIGH.toString(), "High");
    return rep;
  }
  
  private ReferenceDataRepresentation getRemoteDeliveryQualities()
  {
    ReferenceDataRepresentation rep = new ReferenceDataRepresentation();
    rep.addValue(QualityType.LOW.toString(), "Low");
    rep.addValue(QualityType.MEDIUM.toString(), "Medium");
    rep.addValue(QualityType.ORIGINAL.toString(), "High");
    return rep;
  }
  
  private ReferenceDataRepresentation getAccessGroups()
  {
    ReferenceDataRepresentation rep = new ReferenceDataRepresentation();
    List!(AccessGroup) groups = DAOFactory.getAccessGroupDAO().findAll();
    foreach (AccessGroup group ; groups) {
      rep.addValue(group.getId().toString(), group.getName());
    }
    return rep;
  }
  
  private ReferenceDataRepresentation getNetworkInterfaces()
  {
    ReferenceDataRepresentation rep = new ReferenceDataRepresentation();
    try
    {
      List!(NetworkInterface) nics = new ArrayList(MultiCastUtils.findAllAvailableInterfaces());
      Collections.sort(nics, new NetworkInterfaceComparator());
      for (i = nics.iterator(); i.hasNext();)
      {
        nic = cast(NetworkInterface)i.next();
        List!(NicIP) ips = MultiCastUtils.findIPAddresses(nic);
        foreach (NicIP ip ; ips) {
          if (ObjectValidator.isNotEmpty(ip.getNicName())) {
            rep.addValue(ip.nameWithIndex(), String.format("%s (%s)", cast(Object[])[ ip.getIp().getHostAddress(), StringUtils.trimWithEllipsis(nic.getDisplayName(), 40) ]));
          }
        }
      }
    }
    catch (SocketException e)
    {
      Iterator i;
      NetworkInterface nic;
      this.log.warn("Could not get list of all available NICs", e);
    }
    return rep;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.ui.resources.server.ReferenceDataServerResource
 * JD-Core Version:    0.7.0.1
 */