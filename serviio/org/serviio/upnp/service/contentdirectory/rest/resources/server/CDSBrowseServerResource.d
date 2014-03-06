module org.serviio.upnp.service.contentdirectory.rest.resources.server.CDSBrowseServerResource;

import java.lang.String;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map:Entry;
import java.util.Set;
import org.restlet.data.Tag;
import org.restlet.representation.Representation;
import org.restlet.resource.ResourceException;
import org.serviio.config.Configuration;
import org.serviio.library.entities.AccessGroup;
import org.serviio.library.local.LibraryManager;
import org.serviio.library.local.OnlineDBIdentifier;
import org.serviio.library.metadata.MediaFileType;
import org.serviio.profile.DeliveryQuality:QualityType;
import org.serviio.profile.Profile;
import org.serviio.profile.ProfileManager;
import org.serviio.restlet.HttpCodeException;
import org.serviio.restlet.ValidationException;
import org.serviio.upnp.service.contentdirectory.BrowseItemsHolder;
import org.serviio.upnp.service.contentdirectory.ContentDirectoryEngine;
import org.serviio.upnp.service.contentdirectory.InvalidBrowseFlagException;
import org.serviio.upnp.service.contentdirectory.ObjectNotFoundException;
import org.serviio.upnp.service.contentdirectory.ObjectType;
import org.serviio.upnp.service.contentdirectory.classes.AudioItem;
import org.serviio.upnp.service.contentdirectory.classes.Container;
import org.serviio.upnp.service.contentdirectory.classes.DirectoryObject;
import org.serviio.upnp.service.contentdirectory.classes.ImageItem;
import org.serviio.upnp.service.contentdirectory.classes.Item;
import org.serviio.upnp.service.contentdirectory.classes.MusicTrack;
import org.serviio.upnp.service.contentdirectory.classes.Resource;
import org.serviio.upnp.service.contentdirectory.classes.Resource:ResourceType;
import org.serviio.upnp.service.contentdirectory.classes.VideoItem;
import org.serviio.upnp.service.contentdirectory.rest.representation.AbstractCDSObjectRepresentation:DirectoryObjectType;
import org.serviio.upnp.service.contentdirectory.rest.representation.BrowseContentDirectoryRepresentation;
import org.serviio.upnp.service.contentdirectory.rest.representation.ContentURLRepresentation;
import org.serviio.upnp.service.contentdirectory.rest.representation.DirectoryObjectRepresentation;
import org.serviio.upnp.service.contentdirectory.rest.representation.OnlineIdentifierRepresentation;
import org.serviio.upnp.service.contentdirectory.rest.resources.CDSBrowseResource;
import org.serviio.upnp.service.contentdirectory.rest.resources.server.AbstractRestrictedCDSServerResource;
import org.serviio.util.HttpUtils;
import org.serviio.util.StringUtils;
import org.slf4j.Logger;

public class CDSBrowseServerResource : AbstractRestrictedCDSServerResource, CDSBrowseResource
{
    private String profileId;
    private String objectId;
    private int startIndex;
    private int count;
    private String browseFlag;
    private ObjectType objectType;
    private bool ignorePresentationSettings;

    public this()
    {
        this.objectType = ObjectType.ALL;
    }

    public BrowseContentDirectoryRepresentation browse()
    {
        Profile rendererProfile = ProfileManager.getProfileById(this.profileId);
        if (rendererProfile is null)
        {
            this.log.warn(String.format("Profile with id %s doesn't exist", cast(Object[])[ this.profileId ]));
            throw new HttpCodeException(400);
        }
        try
        {
            ContentDirectoryEngine engine = ContentDirectoryEngine.getInstance();
            BrowseItemsHolder!(DirectoryObject) itemsHolder = engine.browse(this.objectId, this.objectType, this.browseFlag, "*", this.startIndex, this.count, "", ProfileManager.getProfileById(this.profileId), AccessGroup.ANY, this.ignorePresentationSettings);

            return buildResult(itemsHolder);
        }
        catch (ObjectNotFoundException e)
        {
            this.log.warn(String.format("Object with id %s doesn't exist", cast(Object[])[ this.objectId ]));
            throw new HttpCodeException(404);
        }
        catch (InvalidBrowseFlagException e)
        {
            this.log.warn(e.getMessage());
            throw new ValidationException(700);
        }
        catch (Exception e)
        {
            this.log.warn(String.format("Browse for object id %s failed with exception: %s", cast(Object[])[ this.objectId, e.getMessage() ]), e);
            throw new RuntimeException(e);
        }
    }

    override protected void doInit()
    {
        super.doInit();
        this.objectId = HttpUtils.urlDecode(cast(String)getRequestAttributes().get("objectId"));
        this.browseFlag = (cast(String)getRequestAttributes().get("browseFlag"));
        this.startIndex = Integer.parseInt(cast(String)getRequestAttributes().get("start"));
        this.count = Integer.parseInt(cast(String)getRequestAttributes().get("count"));
        this.objectType = ObjectType.valueOf(StringUtils.localeSafeToUppercase(cast(String)getRequestAttributes().get("objectType")));
        this.profileId = (cast(String)getRequestAttributes().get("profile"));
        this.ignorePresentationSettings = Boolean.valueOf(getRequestQueryParam("ignorePresentationSettings")).boolValue();
    }

    public Representation handle()
    {
        Representation rep = super.handle();


        rep.setTag(new Tag(LibraryManager.getInstance().getUpdateId(getFileType()).toString(), true));
        return rep;
    }

    private MediaFileType getFileType()
    {
        if (this.objectId.startsWith("A")) {
            return MediaFileType.AUDIO;
        }
        if (this.objectId.startsWith("I")) {
            return MediaFileType.IMAGE;
        }
        return MediaFileType.VIDEO;
    }

    private BrowseContentDirectoryRepresentation buildResult(BrowseItemsHolder!(DirectoryObject) itemsHolder)
    {
        BrowseContentDirectoryRepresentation result = new BrowseContentDirectoryRepresentation();
        List!(DirectoryObjectRepresentation) objects = new ArrayList();
        foreach (DirectoryObject dirObject ; itemsHolder.getItems())
        {
            DirectoryObjectType type = ( cast(Container)dirObject !is null ) ? DirectoryObjectType.CONTAINER : DirectoryObjectType.ITEM;
            DirectoryObjectRepresentation objRep = new DirectoryObjectRepresentation(type, dirObject.getTitle(), dirObject.getId());
            objRep.setParentId(dirObject.getParentID());
            if (objRep.getType() == DirectoryObjectType.CONTAINER)
            {
                Container container = cast(Container)dirObject;
                objRep.setChildCount(container.getChildCount());
                objRep.setThumbnailUrl(getResourceUrl(container.getIcon(), this.profileId));
            }
            else
            {
                Item item = cast(Item)dirObject;
                List!(Resource) resources = getSuitableResources(item);
                if (resources.size() > 0)
                {
                    Resource defaultQualityResource = cast(Resource)resources.get(0);
                    objRep.setThumbnailUrl(getResourceUrl(item.getIcon(), this.profileId));
                    storeContentUrls(objRep, resources);
                    if (( cast(AudioItem)item !is null ))
                    {
                        AudioItem audioItem = cast(AudioItem)item;
                        objRep.setFileType(MediaFileType.AUDIO);
                        objRep.setDescription(audioItem.getDescription());
                        objRep.setGenre(audioItem.getGenre());
                        objRep.setLive(audioItem.getLive());
                        if (( cast(MusicTrack)audioItem !is null ))
                        {
                            MusicTrack musicTrack = cast(MusicTrack)audioItem;
                            objRep.setDate(musicTrack.getDate());
                            objRep.setOriginalTrackNumber(musicTrack.getOriginalTrackNumber());
                            objRep.setArtist(getFirstItemFromArray(musicTrack.getArtist()));
                            objRep.setAlbum(musicTrack.getAlbum());
                            objRep.setDuration(defaultQualityResource.getDuration());
                        }
                    }
                    else if (( cast(VideoItem)item !is null ))
                    {
                        VideoItem videoItem = cast(VideoItem)item;
                        objRep.setFileType(MediaFileType.VIDEO);
                        objRep.setDescription(videoItem.getDescription());
                        objRep.setGenre(videoItem.getGenre());
                        objRep.setDate(videoItem.getDate());
                        objRep.setDuration(defaultQualityResource.getDuration());
                        objRep.setSubtitlesUrl(getResourceUrl(videoItem.getSubtitlesUrlResource(), this.profileId));
                        objRep.setLive(videoItem.getLive());
                        objRep.setContentType(videoItem.getContentType());
                        objRep.setRating(videoItem.getRating());
                        storeOnlineIdentifiers(objRep, videoItem);
                    }
                    else if (( cast(ImageItem)item !is null ))
                    {
                        ImageItem imageItem = cast(ImageItem)item;
                        objRep.setFileType(MediaFileType.IMAGE);
                        objRep.setDescription(imageItem.getDescription());
                        objRep.setDate(imageItem.getDate());
                    }
                }
            }
            objects.add(objRep);
        }
        result.setObjects(objects);
        result.setReturnedSize(Integer.valueOf(itemsHolder.getReturnedSize()));
        result.setTotalMatched(Integer.valueOf(itemsHolder.getTotalMatched()));
        return result;
    }

    private void storeContentUrls(DirectoryObjectRepresentation objRep, List!(Resource) resources)
    {
        List!(ContentURLRepresentation) urls = new ArrayList();
        QualityType preferredQualityType = findPreferredQualityType(resources);
        bool defaultQualityApplied = false;
        foreach (Resource resource ; resources)
        {
            ContentURLRepresentation urlRepresentation = new ContentURLRepresentation(resource.getQuality(), getResourceUrl(resource, this.profileId));
            urlRepresentation.setResolution(resource.getResolution());
            urlRepresentation.setTranscoded(resource.isTranscoded());
            urlRepresentation.setFileSize(resource.getSize());
            if ((!defaultQualityApplied) && (resource.getQuality() == preferredQualityType))
            {
                urlRepresentation.setPreferred(Boolean.valueOf(true));
                defaultQualityApplied = true;
            }
            urls.add(urlRepresentation);
        }
        objRep.setContentUrls(urls);
    }

    private void storeOnlineIdentifiers(DirectoryObjectRepresentation objRep, VideoItem videoItem)
    {
        if ((videoItem.getOnlineIdentifiers() !is null) && (videoItem.getOnlineIdentifiers().size() > 0))
        {
            List!(OnlineIdentifierRepresentation) reps = new ArrayList();
            foreach (Map.Entry!(OnlineDBIdentifier, String) entry ; videoItem.getOnlineIdentifiers().entrySet()) {
                reps.add(new OnlineIdentifierRepresentation((cast(OnlineDBIdentifier)entry.getKey()).toString(), cast(String)entry.getValue()));
            }
            objRep.setOnlineIdentifiers(reps);
        }
    }

    private QualityType findPreferredQualityType(List!(Resource) resources)
    {
        QualityType preferredQuality = Configuration.getRemotePreferredDeliveryQuality();
        Set!(QualityType) availableQualities = getResourceQualities(resources);
        if (availableQualities.contains(preferredQuality)) {
            return preferredQuality;
        }
        if (preferredQuality == QualityType.LOW) {
            return findAlternativeQuality(availableQualities, QualityType.MEDIUM, QualityType.ORIGINAL);
        }
        if (preferredQuality == QualityType.MEDIUM) {
            return findAlternativeQuality(availableQualities, QualityType.LOW, QualityType.ORIGINAL);
        }
        return findAlternativeQuality(availableQualities, QualityType.MEDIUM, QualityType.LOW);
    }

    private QualityType findAlternativeQuality(Set!(QualityType) availableQualities, QualityType firstChoice, QualityType fallbackChoice)
    {
        if (availableQualities.contains(firstChoice)) {
            return firstChoice;
        }
        return fallbackChoice;
    }

    private Set!(QualityType) getResourceQualities(List!(Resource) resources)
    {
        Set!(QualityType) qualities = new HashSet();
        foreach (Resource res ; resources) {
            qualities.add(res.getQuality());
        }
        return qualities;
    }

    private String getFirstItemFromArray(String[] array)
    {
        if ((array !is null) && (array.length > 0)) {
            return array[0];
        }
        return null;
    }

    private List!(Resource) getSuitableResources(Item item)
    {
        List!(Resource) resources = new ArrayList();
        foreach (Resource res ; item.getResources()) {
            if (((res.getResourceType() == ResourceType.MEDIA_ITEM) || (res.getResourceType() == ResourceType.MANIFEST)) && (res.getProtocolInfoIndex().intValue() == 0)) {
                resources.add(res);
            }
        }
        Collections.sort(resources, new ResourceComparator(null));

        Set!(QualityType) foundQualities = new HashSet();
        Iterator!(Resource) it = resources.iterator();
        while (it.hasNext())
        {
            Resource r = cast(Resource)it.next();
            if (foundQualities.contains(r.getQuality())) {
                it.remove();
            } else {
                foundQualities.add(r.getQuality());
            }
        }
        return resources;
    }

    private class ResourceComparator
        : Comparator!(Resource)
    {
        private this() {}

        public int compare(Resource o1, Resource o2)
        {
            if (o1.getQuality() == o2.getQuality())
            {
                if (o1.getProtocolInfo().indexOf("CI=1") == -1) {
                    return -1;
                }
                return 1;
            }
            return new Integer(o1.getQuality().ordinal()).compareTo(new Integer(o2.getQuality().ordinal()));
        }
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.service.contentdirectory.rest.resources.server.CDSBrowseServerResource
* JD-Core Version:    0.7.0.1
*/