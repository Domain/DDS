module org.serviio.upnp.service.contentdirectory.SearchCriteria;

import java.lang.String;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.serviio.upnp.service.contentdirectory.classes.ClassProperties;
import org.serviio.util.ObjectValidator;

public class SearchCriteria
{
    private static Pattern parserPattern = Pattern.compile("\\(?([\\w:]+)\\s*=\\s*(?<!\\\\)\"(.*?)(?<!\\\\)\"\\)?");
    private Map!(ClassProperties, String) crit = new HashMap();

    public static SearchCriteria parse(String criteria)
    {
        if (ObjectValidator.isNotEmpty(criteria))
        {
            SearchCriteria sc = new SearchCriteria();
            Matcher m = parserPattern.matcher(criteria.trim());
            while ((m.find()) && (m.groupCount() == 2))
            {
                ClassProperties cp = ClassProperties.getByFilterName(m.group(1));
                if (cp !is null) {
                    sc.crit.put(cp, normalizeSearchValue(m.group(2)));
                } else {
                    throw new RuntimeException("Cannot parse search criteria, unknown class property: " + m.group(1));
                }
            }
            return sc;
        }
        return null;
    }

    public Map!(ClassProperties, String) getMap()
    {
        return Collections.unmodifiableMap(this.crit);
    }

    private static String normalizeSearchValue(String value)
    {
        return value.replaceAll("\\\\\"", "\"");
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.service.contentdirectory.SearchCriteria
* JD-Core Version:    0.7.0.1
*/