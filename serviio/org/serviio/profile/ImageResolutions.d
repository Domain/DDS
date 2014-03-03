module org.serviio.profile.ImageResolutions;

import java.lang;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.serviio.util.Tupple;

public class ImageResolutions
{
    private static Pattern pattern = Pattern.compile("^(\\d+)x(\\d+)$", 2);
    private Tupple!(Integer, Integer) large;
    private Tupple!(Integer, Integer) medium;
    private Tupple!(Integer, Integer) small;

    public this(String large, String medium, String small)
    {
        this.large = resolution(large);
        this.medium = resolution(medium);
        this.small = resolution(small);
    }

    public Tupple!(Integer, Integer) getLarge()
    {
        return this.large;
    }

    public Tupple!(Integer, Integer) getMedium()
    {
        return this.medium;
    }

    public Tupple!(Integer, Integer) getSmall()
    {
        return this.small;
    }

    private Tupple!(Integer, Integer) resolution(String value)
    {
        Matcher m = pattern.matcher(value);
        if ((m.matches()) && (m.groupCount() == 2)) {
            return new Tupple(Integer.valueOf(m.group(1)), Integer.valueOf(m.group(2)));
        }
        throw new IllegalArgumentException(String.format("Cannot parse image resolution '%s'", cast(Object[])[ value ]));
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.profile.ImageResolutions
* JD-Core Version:    0.7.0.1
*/