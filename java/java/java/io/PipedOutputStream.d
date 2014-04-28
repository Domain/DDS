module java.io.PipedOutputStream;

public import java.io.OutputStream;
import java.lang;

public class PipedOutputStream : OutputStream
{
	public this()
	{
		implMissing();
	}

    override public void write(int b)
    {
        implMissing();
    }

    alias OutputStream.write write;
}