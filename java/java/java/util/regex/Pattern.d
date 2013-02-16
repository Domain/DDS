module java.util.regex.Pattern;

import java.lang.all;
import java.util.regex.Matcher;

class Pattern {
    public static const int UNIX_LINES = 1;
    public static const int CASE_INSENSITIVE = 2;
    public static const int COMMENTS = 4;
    public static const int MULTILINE = 8;
    public static const int LITERAL = 16;
    public static const int DOTALL = 32;
    public static const int UNICODE_CASE = 64;
    public static const int CANON_EQ = 128;

    public String pattern(){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    public int flags(){
        implMissing( __FILE__, __LINE__ );
        return 0;
    }
    public static Pattern compile(String regex){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    public static Pattern compile(String regex, int flags){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    public Matcher matcher(CharSequence input){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
    public Matcher matcher(String input){
        implMissing( __FILE__, __LINE__ );
        return null;
    }
}

