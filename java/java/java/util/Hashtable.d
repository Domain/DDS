module java.util.Hashtable;

import java.lang.all;
import java.util.Dictionary;
import java.util.Map;
import java.util.Map : Entry;
import java.util.Enumeration;
import java.util.Collection;
import java.util.Set;

// no nulls
// synchronized
class Hashtable(K, V) : Dictionary!(K, V), Map!(K, V) {
    V[K] map;

    // The HashMap  class is roughly equivalent to Hashtable, except that it is unsynchronized and permits nulls.
    public this(){
    }
    public this(int initialCapacity){
        implMissing( __FILE__, __LINE__ );
    }
    public this(int initialCapacity, float loadFactor){
        implMissing( __FILE__, __LINE__ );
    }
    public this(Map!(K, V) t){
        implMissing( __FILE__, __LINE__ );
    }

    class ObjectEnumeration(T) : Enumeration!T {
        T[] values;
        int index = 0;
        this( T[] values ){
            this.values = values;
        }
        public bool hasMoreElements(){
            return index < values.length;
        }
        public T nextElement(){
            T res = values[index];
            index++;
            return res;
        }
    }

    override Enumeration!V  elements(){
        return new ObjectEnumeration!V( map.values );
    }
    override Enumeration!K        keys() {
        return new ObjectEnumeration!K( map.keys );
    }
    public void clear(){
        synchronized map = null;
    }
    public bool containsKey(K key){
        synchronized {
            if( auto v = key in map ){
                return true;
            }
            return false;
        }
    }
    public bool containsValue(V value){
        synchronized {
             foreach( k, v; map ){
                 if( v == value ){
                     return true;
                 }
             }
             return false;
        }
    }
    public Set!(Entry!(K, V))  entrySet(){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    override public equals_t opEquals(Object o){
        implMissing( __FILE__, __LINE__ );
        return 0;
    }
    override public V get(K key){
        synchronized {
            if( auto v = key in map ){
                return *v;
            }
            return null;
        }
    }
    override public hash_t toHash(){
        implMissingSafe( __FILE__, __LINE__ );
        return 0;
    }
    override public bool isEmpty(){
        synchronized return map.length is 0;
    }
    override public Set!K    keySet(){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    override public V put(K key, V value){
        synchronized {
            V res = null;
            if( auto v = key in map ){
                res = *v;
            }
            map[ key ] = value;
            return res;
        }
    }
//     public Object put(String key, Object value)
//     public Object put(Object key, String value)
//     public Object put(String key, String value)
    override public void   putAll(Map!(K, V) t){
        synchronized
        implMissing( __FILE__, __LINE__ );
    }
    override public V remove(K key){
        synchronized
        implMissing( __FILE__, __LINE__ );
        return null;
    }
//     public Object remove(String key)
    override public int    size(){
        synchronized return map.length;
    }
    override public Collection!V values(){
        implMissing( __FILE__, __LINE__ );
        return null;
    }

    // only for D
    public int opApply (int delegate(ref V value) dg){
        implMissing( __FILE__, __LINE__ );
        return 0;
    }
    public int opApply (int delegate(ref K key, ref V value) dg){
        implMissing( __FILE__, __LINE__ );
        return 0;
    }

}

