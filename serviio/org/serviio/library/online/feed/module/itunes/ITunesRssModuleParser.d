module org.serviio.library.online.feed.module.itunes.ITunesRssModuleParser;

import com.sun.syndication.feed.module.Module;
import com.sun.syndication.io.ModuleParser;
import java.net.MalformedURLException;
import java.net.URL;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.Locale;
import java.util.TimeZone;
import org.jdom.Attribute;
import org.jdom.Element;
import org.jdom.Namespace;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class ITunesRssModuleParser
  : ModuleParser
{
  private static final Logger log = LoggerFactory.getLogger!(ITunesRssModuleParser);
  private static final SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss", Locale.UK);
  private static final Namespace NS = Namespace.getNamespace("http://itunes.apple.com/rss");
  private static final Namespace ATOM_NS = Namespace.getNamespace("http://www.w3.org/2005/Atom");
  
  static this()
  {
    DATE_FORMAT.setTimeZone(TimeZone.getTimeZone("GMT"));
  }
  
  public String getNamespaceUri()
  {
    return "http://itunes.apple.com/rss";
  }
  
  public Module parse(Element element)
  {
    ITunesRssModule module = new ITunesRssModuleImpl();
    Element name = element.getChild("name", NS);
    Element releaseDate = element.getChild("releaseDate", NS);
    Element artist = element.getChild("artist", NS);
    List!(Element) images = element.getChildren("image", NS);
    List!(Element) links = element.getChildren("link", ATOM_NS);
    if (name !is null) {
      module.setName(name.getTextTrim());
    }
    if (releaseDate !is null) {
      try
      {
        module.setReleaseDate(DATE_FORMAT.parse(releaseDate.getTextTrim()));
      }
      catch (ParseException e)
      {
        log.debug_("Cannot parse release date: " + e.getMessage());
      }
    }
    if (artist !is null) {
      module.setArtist(artist.getTextTrim());
    }
    if ((images !is null) && (images.size() > 0)) {
      foreach (Element imageEl ; images)
      {
        Attribute width = imageEl.getAttribute("width");
        Attribute height = imageEl.getAttribute("height");
        try
        {
          Image image = new Image(new URL(imageEl.getTextTrim()), width !is null ? new Integer(width.getValue()) : null, height !is null ? new Integer(height.getValue()) : null);
          
          module.getImages().add(image);
        }
        catch (MalformedURLException e)
        {
          log.debug_("Invalid image URL: " + e.getMessage());
        }
      }
    }
    if ((links !is null) && (links.size() > 0)) {
      foreach (Element linkEl ; links)
      {
        Element duration = linkEl.getChild("duration", NS);
        if (duration !is null)
        {
          module.setDuration(new Integer(duration.getTextTrim()));
          break;
        }
      }
    }
    return module;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.library.online.feed.module.itunes.ITunesRssModuleParser
 * JD-Core Version:    0.7.0.1
 */