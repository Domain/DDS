module org.serviio.util.CollectionUtils;

import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Collections;
import java.util.HashSet;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;
import org.serviio.db.entities.PersistedEntity;

public class CollectionUtils
{
    public static List!(String) csvToList(String value, String separator, bool trim)
    {
        if (ObjectValidator.isEmpty(value)) {
            return Collections.emptyList();
        }
        List!(String) split = Arrays.asList(value.split(separator));
        if (trim)
        {
            List!(String) trimmed = new ArrayList(split.size());
            foreach (String item ; split) {
                trimmed.add(item.trim());
            }
            return trimmed;
        }
        return split;
    }

    public static bool haveSameElements(Collection!(String) c1, Collection!(String) c2)
    {
        if (c1.size() != c2.size()) {
            return false;
        }
        return c1.containsAll(c2);
    }

    public static int findIndexOf(List!(String) col, String item, bool caseSensitive)
    {
        if (caseSensitive) {
            return col.indexOf(item);
        }
        for (int i = 0; i < col.size(); i++) {
            if ((cast(String)col.get(i)).equalsIgnoreCase(item)) {
                return i;
            }
        }
        return -1;
    }

    public static /*!(T)*/ String arrayToCSV(T)(T[] array, String separator)
    {
        StringBuffer sb = new StringBuffer();
        if ((array !is null) && (array.length > 0))
        {
            for (int i = 0; i < array.length - 1; i++) {
                sb.append(array[i].toString()).append(separator);
            }
            sb.append(array[(array.length - 1)]);
        }
        return sb.toString();
    }

    public static String listToCSV(Collection/*!(?)*/ list, String separator, bool trim)
    {
        StringBuffer sb = new StringBuffer();
        if ((list !is null) && (list.size() > 0))
        {
            Iterator/*!(?)*/ i = list.iterator();
            while (i.hasNext())
            {
                String value = i.next().toString();
                sb.append(trim ? value.trim() : value);
                if (i.hasNext()) {
                    sb.append(separator);
                }
            }
        }
        return sb.toString();
    }

    public static String mapToCSV(Map/*!(?, ?)*/ map, String separator, bool trim)
    {
        StringBuffer sb = new StringBuffer();
        bool first;
        if ((map !is null) && (map.size() > 0))
        {
            first = true;
            foreach (Map.Entry/*!(?, ?)*/ entry ; map.entrySet())
            {
                if (!first) {
                    sb.append(separator);
                }
                sb.append(trim ? entry.getKey().toString().trim() : entry.getKey());
                sb.append("=");
                sb.append(trim ? entry.getValue().toString().trim() : entry.getValue());
                first = false;
            }
        }
        return sb.toString();
    }

    public static Map!(String, String) CSVToMap(String value, String separator)
    {
        Map!(String, String) result = new LinkedHashMap();
        if (ObjectValidator.isNotEmpty(value))
        {
            String[] entries = value.split(separator);
            foreach (String entry ; entries)
            {
                String[] values = entry.split("=");
                result.put(values[0], values[1]);
            }
        }
        return result;
    }

    public static Object getFirstItem(Collection/*!(?)*/ collection)
    {
        if ((collection !is null) && (!collection.isEmpty())) {
            return collection.iterator().next();
        }
        return null;
    }

    public static /*!(T)*/ T[] setToArray(T)(Set!(T) set, Class!(T) elementClass)
    {
        if (set !is null)
        {
            T[] array = cast(Object[])Array.newInstance(elementClass, set.size());
            List!(T) list = new ArrayList(set);
            return list.toArray(array);
        }
        return null;
    }

    public static /*!(T)*/ Set!(T) arrayToSet(T)(T[] array)
    {
        if (array !is null)
        {
            Set!(T) set = new HashSet(array.length);
            foreach (T element ; array) {
                set.add(element);
            }
            return set;
        }
        return null;
    }

    public static /*!(T)*/ void addUniqueElementToArray(T)(T[] array, T element, Class!(T) elementClass)
    {
        Set!(T) set = arrayToSet(array);
        set.add(element);
        array = setToArray(set, elementClass);
    }

    public static /*!(T)*/ void removeElementFromArray(T)(T[] array, T element, Class!(T) elementClass)
    {
        Set!(T) set = arrayToSet(array);
        set.remove(element);
        array = setToArray(set, elementClass);
    }

    public static int[] enumSetToOrdinalArray(Set/*!(?)*/ enums)
    {
        int[] result = new int[enums.size()];
        int i = 0;
        foreach (Object element ; enums) {
            result[(i++)] = (cast(Enum)element).ordinal();
        }
        return result;
    }

    public static int[] addUniqueIntToArray(int[] array, int element)
    {
        if (array !is null)
        {
            Set!(Integer) set = new HashSet(array.length);
            foreach (int item ; array) {
                set.add(Integer.valueOf(item));
            }
            set.add(Integer.valueOf(element));
            int[] newArray = new int[set.size()];
            int i = 0;
            for (Iterator i = set.iterator(); i.hasNext();)
            {
                int item = (cast(Integer)i.next()).intValue();
                newArray[(i++)] = item;
            }
            return newArray;
        }
        return null;
    }

    public static int[] removeIntFromArray(int[] array, int element)
    {
        if (array !is null)
        {
            Set!(Integer) set = new HashSet(array.length);
            foreach (int item ; array) {
                set.add(Integer.valueOf(item));
            }
            set.remove(Integer.valueOf(element));
            int[] newArray = new int[set.size()];
            int i = 0;
            for (Iterator i = set.iterator(); i.hasNext();)
            {
                int item = (cast(Integer)i.next()).intValue();
                newArray[(i++)] = item;
            }
            return newArray;
        }
        return null;
    }

    public static bool arrayContainsInt(int[] array, int element)
    {
        foreach (int item ; array) {
            if (item == element) {
                return true;
            }
        }
        return false;
    }

    public static /*!(T)*/ List!(T) getSubList(T)(List!(T) list, int startIndex, int count)
    {
        if (startIndex >= list.size()) {
            return Collections.emptyList();
        }
        int endIndex = startIndex + count;
        if (endIndex > list.size()) {
            endIndex = list.size();
        }
        return list.subList(startIndex, endIndex);
    }

    public static /*!(K, V)*/ Map!(K, V) getSubMap(K, V)(Map!(K, V) map, int startIndex, int count)
    {
        int endIndex = startIndex + count;
        if (endIndex > map.size()) {
            endIndex = map.size();
        }
        Map!(K, V) result = new LinkedHashMap();
        int i = 0;
        foreach (Map.Entry!(K, V) entry ; map.entrySet()) {
            if ((i >= startIndex) && (i < endIndex)) {
                result.put(entry.getKey(), entry.getValue());
            }
        }
        return result;
    }

    public static List!(Long) extractEntityIDs(List/*!(? : PersistedEntity)*/ entities)
    {
        List!(Long) ids = new ArrayList();
        foreach (PersistedEntity entity ; entities) {
            ids.add(entity.getId());
        }
        return ids;
    }

    public static void removeNulls(Collection/*!(?)*/ col)
    {
        col.remove(null);
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.util.CollectionUtils
* JD-Core Version:    0.7.0.1
*/