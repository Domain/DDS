module org.serviio.upnp.service.contentdirectory.definition.i18n.BrowsingCategoriesMessages;

import java.text.MessageFormat;
import java.util.Locale;
import java.util.MissingResourceException;
import java.util.ResourceBundle;
import java.util.ResourceBundle:Control;
import org.serviio.config.Configuration;
import org.serviio.i18n.GetLocalizationMessageBundleControl;
import org.serviio.i18n.Language;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class BrowsingCategoriesMessages
{
    private static final Logger log = LoggerFactory.getLogger!(BrowsingCategoriesMessages);
    private static ResourceBundle selectedRb;
    private static ResourceBundle defaultRb;
    private static Locale defaultLocale = Locale.ENGLISH;
    private static immutable String BUNDLE = "org.serviio.upnp.service.contentdirectory.definition.i18n.browsingCategories";
    private static ResourceBundle.Control control = new GetLocalizationMessageBundleControl();

    static this()
    {
        defaultRb = ResourceBundle.getBundle("org.serviio.upnp.service.contentdirectory.definition.i18n.browsingCategories", defaultLocale, control);
        loadLocale(Language.getLocale(Configuration.getBrowseMenuPreferredLanguage()));
    }

    public static String getMessage(String key, Object[] args...)
    {
        if (selectedRb is null) {
            loadLocale(defaultLocale);
        }
        String result = null;
        try
        {
            result = MessageFormat.format(selectedRb.getString(key), args);
        }
        catch (MissingResourceException e)
        {
            result = MessageFormat.format(defaultRb.getString(key), args);
        }
        return result;
    }

    public static void loadLocale(Locale locale)
    {
        selectedRb = ResourceBundle.getBundle("org.serviio.upnp.service.contentdirectory.definition.i18n.browsingCategories", locale, control);
        log.info(String.format("Loaded browsing categories message bundle for locale: %s", cast(Object[])[ locale.toString() ]));
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.service.contentdirectory.definition.i18n.BrowsingCategoriesMessages
* JD-Core Version:    0.7.0.1
*/