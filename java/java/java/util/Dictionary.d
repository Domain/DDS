module java.util.Dictionary;

import java.lang;
import java.util.Enumeration;

class Dictionary(K, V) {
    public this(){
    }
    abstract  Enumeration!V   elements();
    abstract  V get(K key);
    abstract  bool          isEmpty();
    abstract  Enumeration!K   keys();
    abstract  V put(K key, V value);
    abstract  V remove(K key);
    abstract  int   size();
}

