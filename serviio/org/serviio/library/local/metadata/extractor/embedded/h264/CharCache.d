module org.serviio.library.local.metadata.extractor.embedded.h264.CharCache;

import java.lang.String;

public class CharCache
{
    private char[] cache;
    private int pos;

    public this(int capacity)
    {
        this.cache = new char[capacity];
    }

    public void append(String str)
    {
        char[] chars = str.toCharArray();
        int available = this.cache.length - this.pos;
        int toWrite = chars.length < available ? chars.length : available;
        System.arraycopy(chars, 0, this.cache, this.pos, toWrite);
        this.pos += toWrite;
    }

    override public String toString()
    {
        return new String(this.cache, 0, this.pos);
    }

    public void clear()
    {
        this.pos = 0;
    }

    public void append(char c)
    {
        if (this.pos < this.cache.length - 1)
        {
            this.cache[this.pos] = c;
            this.pos += 1;
        }
    }

    public int length()
    {
        return this.pos;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.local.metadata.extractor.embedded.h264.CharCache
* JD-Core Version:    0.7.0.1
*/