module java.util.regex.PatternSyntaxException;

import java.lang;


class PatternSyntaxException : IllegalArgumentException {
    this(String desc, String regex, int index) {
        super(desc);
    }
}

