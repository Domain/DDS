module org.serviio.restlet.ServiioXstreamRepresentation;

import com.thoughtworks.xstream.XStream;
import com.thoughtworks.xstream.converters.collections.CollectionConverter;
import com.thoughtworks.xstream.mapper.ClassAliasingMapper;
import org.restlet.data.CharacterSet;
import org.restlet.data.MediaType;
import org.restlet.ext.xstream.XstreamRepresentation;
import org.restlet.representation.Representation;
import org.serviio.library.metadata.MediaFileType;
import org.serviio.ui.representation.ActionRepresentation;
import org.serviio.ui.representation.ApplicationRepresentation;
import org.serviio.ui.representation.BrowsingCategory;
import org.serviio.ui.representation.ConsoleSettingsRepresentation;
import org.serviio.ui.representation.DataValue;
import org.serviio.ui.representation.DeliveryRepresentation;
import org.serviio.ui.representation.LibraryStatusRepresentation;
import org.serviio.ui.representation.LicenseRepresentation;
import org.serviio.ui.representation.MetadataRepresentation;
import org.serviio.ui.representation.OnlinePlugin;
import org.serviio.ui.representation.OnlinePluginsRepresentation;
import org.serviio.ui.representation.OnlineRepositoriesBackupRepresentation;
import org.serviio.ui.representation.OnlineRepository;
import org.serviio.ui.representation.OnlineRepositoryBackup;
import org.serviio.ui.representation.PresentationRepresentation;
import org.serviio.ui.representation.ReferenceDataRepresentation;
import org.serviio.ui.representation.RemoteAccessRepresentation;
import org.serviio.ui.representation.RendererRepresentation;
import org.serviio.ui.representation.RepositoryRepresentation;
import org.serviio.ui.representation.ServiceStatusRepresentation;
import org.serviio.ui.representation.SharedFolder;
import org.serviio.ui.representation.StatusRepresentation;
import org.serviio.ui.representation.SubtitlesRepresentation;
import org.serviio.ui.representation.TranscodingRepresentation;
import org.serviio.upnp.service.contentdirectory.rest.representation.BrowseContentDirectoryRepresentation;
import org.serviio.upnp.service.contentdirectory.rest.representation.CategorySearchResultsRepresentation;
import org.serviio.upnp.service.contentdirectory.rest.representation.ContentURLRepresentation;
import org.serviio.upnp.service.contentdirectory.rest.representation.DirectoryObjectRepresentation;
import org.serviio.upnp.service.contentdirectory.rest.representation.OnlineIdentifierRepresentation;
import org.serviio.upnp.service.contentdirectory.rest.representation.SearchResultRepresentation;
import org.serviio.upnp.service.contentdirectory.rest.representation.SearchResultsRepresentation;

public class ServiioXstreamRepresentation(T) : XstreamRepresentation!(T)
{
    public this(T object)
    {
        super(object);
    }

    public this(MediaType mediaType, T object)
    {
        super(mediaType, object);
    }

    public this(Representation representation)
    {
        super(representation);
    }

    public MediaType getMediaType()
    {
        return MediaType.APPLICATION_XML;
    }

    protected XStream createXstream(MediaType arg0)
    {
        XStream xs = super.createXstream(arg0);
        xs.alias_("serviceStatus", ServiceStatusRepresentation.class_);
        xs.alias_("action", ActionRepresentation.class_);
        xs.alias_("application", ApplicationRepresentation.class_);
        xs.alias_("license", LicenseRepresentation.class_);
        xs.alias_("libraryStatus", LibraryStatusRepresentation.class_);
        xs.alias_("metadata", MetadataRepresentation.class_);
        xs.alias_("refdata", ReferenceDataRepresentation.class_);
        xs.alias_("repository", RepositoryRepresentation.class_);
        xs.alias_("result", ResultRepresentation.class_);
        xs.alias_("status", StatusRepresentation.class_);
        xs.alias_("delivery", DeliveryRepresentation.class_);
        xs.alias_("transcoding", TranscodingRepresentation.class_);
        xs.alias_("subtitles", SubtitlesRepresentation.class_);
        xs.alias_("renderer", RendererRepresentation.class_);
        xs.alias_("presentation", PresentationRepresentation.class_);
        xs.alias_("consoleSettings", ConsoleSettingsRepresentation.class_);
        xs.alias_("remoteAccess", RemoteAccessRepresentation.class_);
        xs.alias_("plugins", OnlinePluginsRepresentation.class_);
        xs.alias_("onlineRepositoriesBackup", OnlineRepositoriesBackupRepresentation.class_);

        xs.alias_("item", DataValue.class_);
        xs.alias_("sharedFolder", SharedFolder.class_);
        xs.alias_("fileType", MediaFileType.class_);
        xs.alias_("browsingCategory", BrowsingCategory.class_);
        xs.alias_("onlineRepository", OnlineRepository.class_);
        xs.alias_("onlinePlugin", OnlinePlugin.class_);
        xs.alias_("backupItem", OnlineRepositoryBackup.class_);

        xs.alias_("contentDirectory", BrowseContentDirectoryRepresentation.class_);
        xs.alias_("searchResults", SearchResultsRepresentation.class_);
        xs.alias_("category", CategorySearchResultsRepresentation.class_);
        xs.alias_("object", DirectoryObjectRepresentation.class_);
        xs.alias_("object", SearchResultRepresentation.class_);
        xs.alias_("contentUrl", ContentURLRepresentation.class_);
        xs.alias_("identifier", OnlineIdentifierRepresentation.class_);


        ClassAliasingMapper mapper = new ClassAliasingMapper(xs.getMapper());
        mapper.addClassAlias("id", Long.class_);
        xs.registerLocalConverter(SharedFolder.class_, "accessGroupIds", new CollectionConverter(mapper));
        xs.registerLocalConverter(OnlineRepository.class_, "accessGroupIds", new CollectionConverter(mapper));
        xs.registerLocalConverter(OnlineRepositoryBackup.class_, "accessGroupIds", new CollectionConverter(mapper));

        return xs;
    }

    public CharacterSet getCharacterSet()
    {
        return CharacterSet.UTF_8;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.restlet.ServiioXstreamRepresentation
* JD-Core Version:    0.7.0.1
*/