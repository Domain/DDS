module org.serviio.util.ObjectValidator;

import java.lang;
import java.util.Collection;

public class ObjectValidator
{
    public static bool isNotEmpty(String string)
    {
        return (string !is null) && (!string.trim().equals(""));
    }

    public static bool isEmpty(String string)
    {
        return (string is null) || (string.trim().equals(""));
    }

    public static bool isNotNullAndPositive(Number number)
    {
        return (number !is null) && (number.doubleValue() > 0.0);
    }

    public static bool isNotNullAndPositiveNumber(Object obj)
    {
        if (( cast(Number)obj !is null )) {
            return (cast(Number)obj).doubleValue() > 0.0;
        }
        return false;
    }

    public static bool isNotNullNorEmpty(T)(Collection!T collection)
    {
        return (collection !is null) && (collection.size() > 0);
    }

    public static bool isNotNullNorEmptyString(Object obj)
    {
        if (obj is null) {
            return false;
        }
        if (( cast(String)obj !is null )) {
            return !"".opEquals(obj);
        }
        return true;
    }

    public static bool isNotNullNorEmpty(Object[] array)
    {
        return (array !is null) && (array.length > 0);
    }

    public static bool isNullOrEmpty(T)(Collection!T collection)
    {
        if (collection is null) {
            return true;
        }
        if (collection.size() == 0) {
            return true;
        }
        return false;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.util.ObjectValidator
* JD-Core Version:    0.7.0.1
*/