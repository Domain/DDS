module org.serviio.library.local.metadata.extractor.embedded.h264.BufferWrapperImpl;

import java.io.File;
import java.io.IOException;
import java.io.RandomAccessFile;
import java.nio.ByteBuffer;
import java.nio.MappedByteBuffer;
import java.nio.channels.FileChannel;
import java.nio.channels.FileChannel:MapMode;
import java.util.ArrayList;
import java.util.List;
import org.serviio.library.local.metadata.extractor.embedded.h264.AbstractBufferWrapper;
import org.serviio.library.local.metadata.extractor.embedded.h264.BufferWrapper;

public class BufferWrapperImpl : AbstractBufferWrapper
{
    ByteBuffer[] parents;
    int activeParent = 0;

    public this(byte[] bytes)
    {
        this(ByteBuffer.wrap(bytes));
    }

    public this(ByteBuffer parent)
    {
        this.parents = cast(ByteBuffer[])[ parent ];
    }

    public this(ByteBuffer[] parents)
    {
        this.parents = parents;
    }

    public this(List!(ByteBuffer) parents)
    {
        this.parents = (cast(ByteBuffer[])parents.toArray(new ByteBuffer[parents.size()]));
    }

    public this(File file)
    {
        long filelength = file.length();
        int sliceSize = 134217728;

        RandomAccessFile raf = new RandomAccessFile(file, "r");
        ArrayList!(ByteBuffer) buffers = new ArrayList!(ByteBuffer)();
        long i = 0L;
        while (i < filelength) {
            if (filelength - i > sliceSize)
            {
                ByteBuffer bb;
                try
                {
                    bb = raf.getChannel().map(FileChannel.MapMode.READ_ONLY, i, sliceSize);
                }
                catch (IOException e1)
                {
                    try
                    {
                        bb = raf.getChannel().map(FileChannel.MapMode.READ_ONLY, i, sliceSize);
                    }
                    catch (IOException e2)
                    {
                        try
                        {
                            bb = raf.getChannel().map(FileChannel.MapMode.READ_ONLY, i, sliceSize);
                        }
                        catch (IOException e3)
                        {
                            bb = raf.getChannel().map(FileChannel.MapMode.READ_ONLY, i, sliceSize);
                        }
                    }
                }
                buffers.add(bb);
                i += sliceSize;
            }
            else
            {
                buffers.add(raf.getChannel().map(FileChannel.MapMode.READ_ONLY, i, filelength - i).slice());
                i += filelength - i;
            }
        }
        this.parents = (cast(ByteBuffer[])buffers.toArray(new ByteBuffer[buffers.size()]));
        raf.close();
    }

    public long position()
    {
        if (this.activeParent >= 0)
        {
            long pos = 0L;
            for (int i = 0; i < this.activeParent; i++) {
                pos += this.parents[i].limit();
            }
            pos += this.parents[this.activeParent].position();
            return pos;
        }
        return size();
    }

    public void position(long position)
    {
        if (position == size())
        {
            this.activeParent = -1;
        }
        else
        {
            int current = 0;
            while (position >= this.parents[current].limit()) {
                position -= this.parents[(current++)].limit();
            }
            this.parents[current].position(cast(int)position);
            this.activeParent = current;
        }
    }

    public long size()
    {
        long size = 0L;
        foreach (ByteBuffer parent ; this.parents) {
            size += parent.limit();
        }
        return size;
    }

    public long remaining()
    {
        if (this.activeParent == -1) {
            return 0L;
        }
        long remaining = 0L;
        for (int i = this.activeParent; i < this.parents.length; i++) {
            remaining += this.parents[i].remaining();
        }
        return remaining;
    }

    public int read()
    {
        if (this.parents[this.activeParent].remaining() == 0)
        {
            if (this.parents.length > this.activeParent + 1)
            {
                this.activeParent += 1;
                this.parents[this.activeParent].rewind();
                return read();
            }
            return -1;
        }
        int b = this.parents[this.activeParent].get();
        return b < 0 ? b + 256 : b;
    }

    public int read(byte[] b)
    {
        return read(b, 0, b.length);
    }

    public int read(byte[] b, int off, int len)
    {
        if (this.parents[this.activeParent].remaining() >= len)
        {
            this.parents[this.activeParent].get(b, off, len);
            return len;
        }
        int curRemaining = this.parents[this.activeParent].remaining();
        this.parents[this.activeParent].get(b, off, curRemaining);
        this.activeParent += 1;
        this.parents[this.activeParent].rewind();
        return curRemaining + read(b, off + curRemaining, len - curRemaining);
    }

    public BufferWrapper getSegment(long startPos, long length)
    {
        long savePos = position();
        ArrayList!(ByteBuffer) segments = new ArrayList();
        position(startPos);
        while (length > 0L)
        {
            ByteBuffer currentSlice = this.parents[this.activeParent].slice();
            if (currentSlice.remaining() >= length)
            {
                currentSlice.limit(cast(int)length);
                length -= length;
            }
            else
            {
                length -= currentSlice.remaining();
                this.parents[(++this.activeParent)].rewind();
            }
            segments.add(currentSlice);
        }
        position(savePos);
        return new BufferWrapperImpl(cast(ByteBuffer[])segments.toArray(new ByteBuffer[segments.size()]));
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.local.metadata.extractor.embedded.h264.BufferWrapperImpl
* JD-Core Version:    0.7.0.1
*/