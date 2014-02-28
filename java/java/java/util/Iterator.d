module java.util.Iterator;

import java.lang;

interface Iterator(T) {
    public bool hasNext();
    public T next();
    public void  remove();
}


