module org.serviio.library.local.EnumMapConverter;

import std.conv;

import java.util.HashMap;
import java.util.Map;
import org.serviio.util.CollectionUtils;
import org.serviio.util.ObjectValidator;
import org.serviio.util.StringUtils;

public class EnumMapConverter(E)
{
    public Map!(E, String) convert(String identifiersCSV)
    {
        Map!(E, String) result = new HashMap();
        if (ObjectValidator.isNotEmpty(identifiersCSV))
        {
            String[] identifiers = identifiersCSV.split(",");
            foreach (String identifier ; identifiers)
            {
                String[] entries = identifier.split("=");
                result.put(enumValue(StringUtils.localeSafeToUppercase(entries[0].trim())), entries[1].trim());
            }
        }
        return result;
    }

    public String parseToString(Map!(E, String) map)
    {
        return CollectionUtils.mapToCSV(map, ",", true);
    }

    protected E enumValue(String paramString)
    {
        return to!E(paramString);
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.local.EnumMapConverter
* JD-Core Version:    0.7.0.1
*/