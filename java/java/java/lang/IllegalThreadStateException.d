module java.lang.IllegalThreadStateException;

import java.lang.String;
import java.lang.IllegalArgumentException;

/**
* Thrown to indicate that a thread is not in an appropriate state
* for the requested operation. See, for example, the
* <code>suspend</code> and <code>resume</code> methods in class
* <code>Thread</code>.
*
* @author  unascribed
* @see     java.lang.Thread#resume()
* @see     java.lang.Thread#suspend()
* @since   JDK1.0
*/
public class IllegalThreadStateException : IllegalArgumentException {
    private static enum serialVersionUID = -7626246362397460174L;

    /**
    * Constructs an <code>IllegalThreadStateException</code> with no
    * detail message.
    */
    public this() {
        super();
    }

    /**
    * Constructs an <code>IllegalThreadStateException</code> with the
    * specified detail message.
    *
    * @param   s   the detail message.
    */
    public this(String s) {
        super(s);
    }
}