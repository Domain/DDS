module org.serviio.i18n.GetLocalizationMessageBundleControl;

import java.lang.String;
import java.lang.StringBuilder;
import java.util.Locale;
import java.util.ResourceBundle:Control;

public class GetLocalizationMessageBundleControl : Control
{
    public String toBundleName(String baseName, Locale locale)
    {
        if (locale == Locale.ROOT) {
            return baseName;
        }
        String language = locale.getLanguage();
        String country = locale.getCountry();
        String variant = locale.getVariant();
        if ((language == "") && (country == "") && (variant == "")) {
            return baseName;
        }
        StringBuilder sb = new StringBuilder(baseName);
        sb.append('_');
        if (variant != "") {
            sb.append(language).append('-').append(country).append('-').append(variant);
        } else if (country != "") {
            sb.append(language).append('-').append(country);
        } else {
            sb.append(language);
        }
        return sb.toString();
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.i18n.GetLocalizationMessageBundleControl
* JD-Core Version:    0.7.0.1
*/