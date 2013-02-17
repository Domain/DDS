module java.util.TreeSet;

import java.lang.all;
import java.util.SortedSet;
import java.util.AbstractSet;
import java.util.Collection;
import java.util.Iterator;
import java.util.Comparator;

version(Tango){
    static import tango.util.container.SortedMap;
} else { // Phobos
}

class TreeSet(T) : AbstractSet!T, SortedSet!T {

    version(Tango){
        alias tango.util.container.SortedMap.SortedMap!(T,int) SetType;
        private SetType set;
    } else { // Phobos
    }

    public this(){
        version(Tango){
            set = new SetType();
        } else { // Phobos
            implMissingInPhobos();
        }
    }
    public this(Collection!T c){
        implMissing( __FILE__, __LINE__ );
    }
    public this(Comparator!T c){
        implMissing( __FILE__, __LINE__ );
    }
    public this(SortedSet!T){
        implMissing( __FILE__, __LINE__ );
    }

    override public bool    add(T o){
        version(Tango){
            return set.add(o, 0);
        } else { // Phobos
            implMissingInPhobos();
            return false;
        }
    }
    //public bool    add(String o){
    //    version(Tango){
    //        return add(stringcast(o));
    //    } else { // Phobos
    //        implMissingInPhobos();
    //        return false;
    //    }
    //}
    override public bool    addAll(Collection!T c){
        version(Tango){
            foreach( o; c ){
                add(o);
            }
            return true;
        } else { // Phobos
            implMissingInPhobos();
            return false;
        }
    }
    override public void   clear(){
        version(Tango){
            set.clear();
        } else { // Phobos
            implMissingInPhobos();
        }
    }
    override public bool    contains(T o){
        version(Tango){
            return set.containsKey(o);
        } else { // Phobos
            implMissingInPhobos();
            return false;
        }
    }
    //public bool     contains(String o){
    //    version(Tango){
    //        return contains(stringcast(o));
    //    } else { // Phobos
    //        implMissingInPhobos();
    //        return false;
    //    }
    //}
    override public bool    containsAll(Collection!T c){
        version(Tango){
            foreach( o; c ){
                if( !contains(o) ){
                    return false;
                }
            }
            return true;
        } else { // Phobos
            implMissingInPhobos();
            return false;
        }
    }
    public Comparator!T     comparator(){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    public override equals_t    opEquals(Object o){
        implMissing( __FILE__, __LINE__ );
        return 0;
    }
    public T         first(){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    public override hash_t    toHash(){
        implMissingSafe( __FILE__, __LINE__ );
        return 0;
    }
    public SortedSet!T      headSet(T toElement){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    override public bool    isEmpty(){
        version(Tango){
            return set.isEmpty();
        } else { // Phobos
            implMissingInPhobos();
            return false;
        }
    }
    override public Iterator!T   iterator(){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    public T         last(){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    override public bool    remove(T o){
        implMissing( __FILE__, __LINE__ );
        return false;
    }
    //public bool remove(String key){
    //    version(Tango){
    //        return remove(stringcast(key));
    //    } else { // Phobos
    //        implMissingInPhobos();
    //        return false;
    //    }
    //}
    override public bool    removeAll(Collection!T c){
        implMissing( __FILE__, __LINE__ );
        return false;
    }
    override public bool    retainAll(Collection!T c){
        implMissing( __FILE__, __LINE__ );
        return false;
    }
    override public int    size(){
        version(Tango){
            return set.size();
        } else { // Phobos
            implMissingInPhobos();
            return 0;
        }
    }
    public SortedSet!T      subSet(T fromElement, T toElement){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    public SortedSet!T      tailSet(T fromElement){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    override public T[]   toArray(){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    override public T[]   toArray(T[] a){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    public override String toString(){
        implMissing( __FILE__, __LINE__ );
        return null;
    }


    // only for D
    override public int opApply (int delegate(ref T value) dg){
        version(Tango){
            int localDg( ref Object key, ref int value ){
                return dg( key );
            }
            return set.opApply(&localDg);
        } else { // Phobos
            implMissingInPhobos();
            return 0;
        }
    }
}

