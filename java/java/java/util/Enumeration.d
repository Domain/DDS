module java.util.Enumeration;

import java.lang;

interface Enumeration(T) {
    public bool hasMoreElements();
    public T nextElement();
}


