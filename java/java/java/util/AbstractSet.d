module java.util.AbstractSet;

import java.lang;
import java.util.Set;
import java.util.Collection;
import java.util.Iterator;
import java.util.AbstractCollection;

abstract class AbstractSet(T) : AbstractCollection!T, Set!T {
    this(){
    }
    override equals_t         opEquals(Object o){
        implMissing( __FILE__, __LINE__ );
        return 0;
    }
    override hash_t      toHash(){
        implMissingSafe( __FILE__, __LINE__ );
        return 0;
    }
    override public bool     add(T o){ return super.add(o); }
    //public bool     add(String o){ return super.add(stringcast(o)); }
    override public bool     addAll(Collection!T c){ return super.addAll(c); }
    override public void     clear(){ super.clear(); }
    override public bool     contains(T o){ return super.contains(o); }
    //public bool     contains(String o){ return super.contains(stringcast(o)); }
    override public bool     containsAll(Collection!T c){ return super.containsAll(c); }


    override public bool     isEmpty(){ return super.isEmpty(); }
    //public Iterator iterator(){ return super.iterator(); }
    override public bool     remove(T o){ return super.remove(o); }
    //public bool     remove(String o){ return super.remove(o); }
    override public bool     removeAll(Collection!T c){ return super.removeAll(c); }
    override public bool     retainAll(Collection!T c){ return super.retainAll(c); }
    //public int      size(){ return super.size(); }
    override public T[] toArray(){ return super.toArray(); }
    override public T[] toArray(T[] a){ return super.toArray(a); }
    override public String   toString(){ return super.toString(); }

    // only for D
    public int opApply (int delegate(ref T value) dg){
        auto it = iterator();
        while( it.hasNext() ){
            auto v = it.next();
            int res = dg( v );
            if( res ) return res;
        }
        return 0;
    }
}

