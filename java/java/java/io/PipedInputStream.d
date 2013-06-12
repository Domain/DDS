module java.io.PipedInputStream;

import java.lang.all;
import java.io.InputStream;
import java.io.PipedOutputStream;

public class PipedInputStream : InputStream
{
    private bool closedByWriter = false;
    private bool closedByReader = false;
    private bool connected = false;
    private Thread readSide;
    private Thread writeSide;
    private static const int DEFAULT_PIPE_SIZE = 1024;
    protected static const int PIPE_SIZE = 1024;
    protected byte[] buffer;
    protected int _in = -1;
    protected int _out = 0;

    public this(PipedOutputStream paramPipedOutputStream)
    {
        this(paramPipedOutputStream, 1024);
    }

    public this(PipedOutputStream paramPipedOutputStream, int paramInt)
    {
        initPipe(paramInt);
        connect(paramPipedOutputStream);
    }

    public this()
    {
        initPipe(1024);
    }

    public this(int paramInt)
    {
        initPipe(paramInt);
    }

    private void initPipe(int paramInt)
    {
        if (paramInt <= 0)
            throw new IllegalArgumentException("Pipe Size <= 0");
        this.buffer = new byte[paramInt];
    }

    public void connect(PipedOutputStream paramPipedOutputStream)
    {
        paramPipedOutputStream.connect(this);
    }

    protected /*synchronized*/ void receive(int paramInt)
    {
        checkStateForReceive();
        this.writeSide = Thread.currentThread();
        if (this._in == this._out)
            awaitSpace();
        if (this._in < 0)
        {
            this._in = 0;
            this._out = 0;
        }
        this.buffer[(this._in++)] = (cast(byte)(paramInt & 0xFF));
        if (this._in >= this.buffer.length)
            this._in = 0;
    }

    /*synchronized*/ void receive(byte[] paramArrayOfByte, int paramInt1, int paramInt2)
    {
        checkStateForReceive();
        this.writeSide = Thread.currentThread();
        int i = paramInt2;
        while (i > 0)
        {
            if (this._in == this._out)
                awaitSpace();
            int j = 0;
            if (this._out < this._in)
                j = this.buffer.length - this._in;
            else if (this._in < this._out)
                if (this._in == -1)
                {
                    this._in = (this._out = 0);
                    j = this.buffer.length - this._in;
                }
                else
                {
                    j = this._out - this._in;
                }
            if (j > i)
                j = i;
            assert (j > 0);
            System.arraycopy(paramArrayOfByte, paramInt1, this.buffer, this._in, j);
            i -= j;
            paramInt1 += j;
            this._in += j;
            if (this._in >= this.buffer.length)
                this._in = 0;
        }
    }

    private void checkStateForReceive()
    {
        if (!this.connected)
            throw new IOException("Pipe not connected");
        if ((this.closedByWriter) || (this.closedByReader))
            throw new IOException("Pipe closed");
        if ((this.readSide != null) && (!this.readSide.isAlive()))
            throw new IOException("Read end dead");
    }

    private void awaitSpace()
    {
        while (this._in == this._out)
        {
            checkStateForReceive();
            notifyAll();
            try
            {
                wait(1000L);
            }
            catch (InterruptedException localInterruptedException)
            {
                throw new InterruptedIOException();
            }
        }
    }

    synchronized void receivedLast()
    {
        this.closedByWriter = true;
        notifyAll();
    }

    override public /*synchronized*/ int read()
    {
        if (!this.connected)
            throw new IOException("Pipe not connected");
        if (this.closedByReader)
            throw new IOException("Pipe closed");
        if ((this.writeSide != null) && (!this.writeSide.isAlive()) && (!this.closedByWriter) && (this._in < 0))
            throw new IOException("Write end dead");
        this.readSide = Thread.currentThread();
        int i = 2;
        while (this._in < 0)
        {
            if (this.closedByWriter)
                return -1;
            if ((this.writeSide != null) && (!this.writeSide.isAlive()))
            {
                i--;
                if (i < 0)
                    throw new IOException("Pipe broken");
            }
            notifyAll();
            try
            {
                wait(1000);
            }
            catch (InterruptedException localInterruptedException)
            {
                throw new InterruptedIOException();
            }
        }
        int j = this.buffer[(this._out++)] & 0xFF;
        if (this._out >= this.buffer.length)
            this._out = 0;
        if (this._in == this._out)
            this._in = -1;
        return j;
    }

    override public /*synchronized*/ int read(byte[] paramArrayOfByte, int paramInt1, int paramInt2)
    {
        if (paramArrayOfByte == null)
            throw new NullPointerException();
        if ((paramInt1 < 0) || (paramInt2 < 0) || (paramInt2 > paramArrayOfByte.length - paramInt1))
            throw new IndexOutOfBoundsException();
        if (paramInt2 == 0)
            return 0;
        int i = read();
        if (i < 0)
            return -1;
        paramArrayOfByte[paramInt1] = (cast(byte)i);
        int j = 1;
        while ((this._in >= 0) && (paramInt2 > 1))
        {
            int k;
            if (this._in > this._out)
                k = Math.min(this.buffer.length - this._out, this._in - this._out);
            else
                k = this.buffer.length - this._out;
            if (k > paramInt2 - 1)
                k = paramInt2 - 1;
            System.arraycopy(this.buffer, this._out, paramArrayOfByte, paramInt1 + j, k);
            this._out += k;
            j += k;
            paramInt2 -= k;
            if (this._out >= this.buffer.length)
                this._out = 0;
            if (this._in == this._out)
                this._in = -1;
        }
        return j;
    }

    override public /*synchronized*/ int available()
    {
        if (this._in < 0)
            return 0;
        if (this._in == this._out)
            return this.buffer.length;
        if (this._in > this._out)
            return this._in - this._out;
        return this._in + this.buffer.length - this._out;
    }

    override public void close()
    {
        this.closedByReader = true;
        synchronized (this)
        {
            this._in = -1;
        }
    }
}

/* Location:           D:\Program Files\Java\jre6\lib\rt.jar
* Qualified Name:     java.io.PipedInputStream
* JD-Core Version:    0.6.2
*/