module org.serviio.library.online.feed.modules.itunes.ITunesRssModuleParser;

import com.sun.syndication.feed.modules.Module;
import com.sun.syndication.io.ModuleParser;
import java.lang.String;
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

public class ITunesRssModuleParser : ModuleParser
{
	private static Logger log;
	private static immutable SimpleDateFormat DATE_FORMAT;
	private static immutable Namespace NS;
	private static immutable Namespace ATOM_NS;

	public String getNamespaceUri()
	{
		return "http://itunes.apple.com/rss";
	}

	public Module parse(Element element)
	{
		ITunesRssModule mod = new ITunesRssModuleImpl();
		Element name = element.getChild("name", NS);
		Element releaseDate = element.getChild("releaseDate", NS);
		Element artist = element.getChild("artist", NS);

		List!(Element) images = element.getChildren("image", NS);

		List!(Element) links = element.getChildren("link", ATOM_NS);

		if (name !is null) {
			mod.setName(name.getTextTrim());
		}
		if (releaseDate !is null) {
			try {
				mod.setReleaseDate(DATE_FORMAT.parse(releaseDate.getTextTrim()));
			}
			catch (ParseException e) {
				log.debug_("Cannot parse release date: " + e.getMessage());
			}
		}
		if (artist !is null) {
			mod.setArtist(artist.getTextTrim());
		}
		if ((images !is null) && (images.size() > 0)) {
			foreach (Element imageEl ; images) {
				Attribute width = imageEl.getAttribute("width");
				Attribute height = imageEl.getAttribute("height");
				try {
					Image image = new Image(new URL(imageEl.getTextTrim()), width !is null ? new Integer(width.getValue()) : null, height !is null ? new Integer(height.getValue()) : null);

					mod.getImages().add(image);
				} catch (MalformedURLException e) {
					log.debug_("Invalid image URL: " + e.getMessage());
				}
			}
		}

		if ((links !is null) && (links.size() > 0)) {
			foreach (Element linkEl ; links) {
				Element duration = linkEl.getChild("duration", NS);
				if (duration !is null) {
					mod.setDuration(new Integer(duration.getTextTrim()));
					break;
				}
			}
		}
		return mod;
	}

	static this()
	{
		log = LoggerFactory.getLogger!(ITunesRssModuleParser)();
		DATE_FORMAT = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss", Locale.UK);
		NS = Namespace.getNamespace("http://itunes.apple.com/rss");
		ATOM_NS = Namespace.getNamespace("http://www.w3.org/2005/Atom");
		DATE_FORMAT.setTimeZone(TimeZone.getTimeZone("GMT"));
	}
}

/* Location:           D:\Program Files\Serviio\lib\serviio.jar
* Qualified Name:     org.serviio.library.online.feed.modules.itunes.ITunesRssModuleParser
* JD-Core Version:    0.6.2
*/