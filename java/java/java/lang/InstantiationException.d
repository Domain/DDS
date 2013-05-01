module java.lang.InstantiationException;

import java.lang.String;

class InstantiationException: Exception {
    this() {
    }
    this( String e ){
        super(e);
    }
}