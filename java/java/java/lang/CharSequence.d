module java.lang.CharSequence;

import java.lang.String;

interface CharSequence {
    char         charAt(int index);
    int          length();
    CharSequence subSequence(int start, int end);
    String       toString();
}
