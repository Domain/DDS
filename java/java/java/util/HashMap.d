module java.util.HashMap;

import java.lang;
import java.util.Map;
import java.util.Collection;
import java.util.Set;
import java.util.HashSet;
import java.util.ArrayList;

version(Tango){
    static import tango.util.container.HashMap;
    private struct ObjRef(T) {
        T obj;
        static ObjRef opCall( T obj ){
            ObjRef res;
            res.obj = obj;
            return res;
        }
        public hash_t toHash(){
            return obj is null ? 0 : obj.toHash();
        }
        override public equals_t opEquals( ObjRef other ){
            return obj is null ? other.obj is null : obj.opEquals( other.obj );
        }
        override public equals_t opEquals( Object other ){
            return obj is null ? other is null : obj.opEquals( other );
        }
    }
} else { // Phobos
}

class HashMap(K, V) : Map!(K, V) {
    // The HashMap  class is roughly equivalent to Hashtable, except that it is unsynchronized and permits nulls.
    version(Tango){
        alias tango.util.container.HashMap.HashMap!(ObjRef!K,ObjRef!V) MapType;
    } else { // Phobos
        alias V[K] MapType;
    }
    
    private MapType map;

    public this(){
        version(Tango){
            map = new MapType();
        } else { // Phobos
        }
    }
    public this(int initialCapacity){
        this();
    }
    public this(int initialCapacity, float loadFactor){
        version(Tango){
            map = new MapType(loadFactor);
        } else { // Phobos
            implMissingInPhobos();
        }
    }
    public this(Map!(K, V) m){
        this();
        putAll(m);
    }
    public void clear(){
        version(Tango){
            map.clear();
        } else { // Phobos
            implMissingInPhobos();
        }
    }
    public bool containsKey(K key){
        version(Tango){
            ObjRef v;
            ObjRef keyr = ObjRef(key);
            return map.get(keyr, v );
        } else { // Phobos
            implMissingInPhobos();
            return false;
        }
    }
    //public bool containsKey(String key){
    //    return containsKey(stringcast(key));
    //}
    public bool containsValue(V value){
        version(Tango){
            ObjRef valuer = ObjRef(value);
            return map.contains(valuer);
        } else { // Phobos
            implMissingInPhobos();
            return false;
        }
    }
    public Set!(Entry!(K, V))  entrySet(){
        version(Tango){
            HashSet!(Entry!(K, V)) res = new HashSet!(Entry!(K, V))();
            foreach( k, v; map ){
                res.add( new MapEntry(this,k.obj));
            }
            return res;
        } else { // Phobos
            implMissingInPhobos();
            return null;
        }
    }
    public override equals_t opEquals(Object o){
        version(Tango){
            if( auto other = cast(HashMap) o ){
                if( other.size() !is size() ){
                    return false;
                }
                foreach( k, v; map ){
                    auto vo = other.get(k.obj);
                    if( v != vo ){
                        return false;
                    }
                }
                return true;
            }
            return false;
        } else { // Phobos
            implMissingInPhobos();
            return false;
        }
    }
    public V get(K key){
        version(Tango){
            ObjRef!K keyr = ObjRef!K(key);
            if( auto v = keyr in map ){
                return (*v).obj;
            }
            return null;
        } else { // Phobos
            implMissingInPhobos();
            return null;
        }
    }
    //public Object get(String key){
    //    return get(stringcast(key));
    //}
    public override hash_t toHash(){
        return super.toHash();
    }
    public bool isEmpty(){
        version(Tango){
            return map.isEmpty();
        } else { // Phobos
            implMissingInPhobos();
            return false;
        }
    }
    public Set!K    keySet(){
        version(Tango){
            HashSet!K res = new HashSet!K();
            foreach( k, v; map ){
                res.add(k.obj);
            }
            return res;
        } else { // Phobos
            implMissingInPhobos();
            return null;
        }
    }
    public V put(K key, V value){
        version(Tango){
            ObjRef valuer = ObjRef(value);
            ObjRef keyr = ObjRef(key);
            V res = null;
            if( auto vold = keyr in map ){
                res = (*vold).obj;
            }
            map[ keyr ] = valuer;
            return res;
        } else { // Phobos
            implMissingInPhobos();
            return null;
        }
    }
    //public Object put(String key, Object value){
    //    return put( stringcast(key), value );
    //}
    //public Object put(Object key, String value){
    //    return put( key, stringcast(value) );
    //}
    //public Object put(String key, String value){
    //    return put( stringcast(key), stringcast(value) );
    //}
    public void   putAll(Map!(K, V) t){
        version(Tango){
            foreach( k, v; t ){
                map[ObjRef(k)] = ObjRef(v);
            }
        } else { // Phobos
            implMissingInPhobos();
        }
    }
    public V remove(K key){
        version(Tango){
            ObjRef!K keyr = ObjRef!K(key);
            if( auto v = keyr in map ){
                Object res = (*v).obj;
                map.removeKey(keyr);
                return res;
            }
            return null;
        } else { // Phobos
            implMissingInPhobos();
            return null;
        }
    }
    //public Object remove(String key){
    //    return remove(stringcast(key));
    //}
    public int    size(){
        version(Tango){
            return map.size();
        } else { // Phobos
            implMissingInPhobos();
            return 0;
        }
    }
    public Collection!V values(){
        version(Tango){
            ArrayList!V res = new ArrayList!V( size() );
            foreach( k, v; map ){
                res.add( v.obj );
            }
            return res;
        } else { // Phobos
            implMissingInPhobos();
            return null;
        }
    }

    public int opApply (int delegate(ref V value) dg){
        version(Tango){
            int ldg( ref ObjRef!V or ){
                return dg( or.obj );
            }
            return map.opApply( &ldg );
        } else { // Phobos
            implMissingInPhobos();
            return 0;
        }
    }
    public int opApply (int delegate(ref K key, ref V value) dg){
        version(Tango){
            int ldg( ref ObjRef!K key, ref ObjRef!V value ){
                return dg( key.obj, value.obj );
            }
            return map.opApply( &ldg );
        } else { // Phobos
            implMissingInPhobos();
            return 0;
        }
    }

}

