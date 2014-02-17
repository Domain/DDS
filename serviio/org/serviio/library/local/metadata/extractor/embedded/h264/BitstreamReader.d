module org.serviio.library.local.metadata.extractor.embedded.h264.BitstreamReader;

import java.io.IOException;

public class BitstreamReader
{
  private BufferWrapper is;
  private int curByte;
  private int nextByte;
  int nBit;
  protected static int bitsRead;
  protected CharCache debugBits = new CharCache(50);
  
  public this(BufferWrapper is)
  {
    this.is = is;
    this.curByte = is.read();
    this.nextByte = is.read();
  }
  
  public int read1Bit()
  {
    if (this.nBit == 8)
    {
      advance();
      if (this.curByte == -1) {
        return -1;
      }
    }
    int res = this.curByte >> 7 - this.nBit & 0x1;
    this.nBit += 1;
    
    this.debugBits.append(res == 0 ? '0' : '1');
    bitsRead += 1;
    
    return res;
  }
  
  public long readNBit(int n)
  {
    if (n > 64) {
      throw new IllegalArgumentException("Can not readByte more then 64 bit");
    }
    long val = 0L;
    for (int i = 0; i < n; i++)
    {
      val <<= 1;
      val |= read1Bit();
    }
    return val;
  }
  
  private void advance()
  {
    this.curByte = this.nextByte;
    this.nextByte = this.is.read();
    this.nBit = 0;
  }
  
  public int readByte()
  {
    if (this.nBit > 0) {
      advance();
    }
    int res = this.curByte;
    
    advance();
    
    return res;
  }
  
  public bool moreRBSPData()
  {
    if (this.nBit == 8) {
      advance();
    }
    int tail = 1 << 8 - this.nBit - 1;
    int mask = (tail << 1) - 1;
    bool hasTail = (this.curByte & mask) == tail;
    
    return (this.curByte != -1) && ((this.nextByte != -1) || (!hasTail));
  }
  
  public long getBitPosition()
  {
    return bitsRead * 8 + this.nBit % 8;
  }
  
  public long readRemainingByte()
  {
    return readNBit(8 - this.nBit);
  }
  
  public int peakNextBits(int n)
  {
    if (n > 8) {
      throw new IllegalArgumentException("N should be less then 8");
    }
    if (this.nBit == 8)
    {
      advance();
      if (this.curByte == -1) {
        return -1;
      }
    }
    int[] bits = new int[16 - this.nBit];
    
    int cnt = 0;
    for (int i = this.nBit; i < 8; i++) {
      bits[(cnt++)] = (this.curByte >> 7 - i & 0x1);
    }
    for (int i = 0; i < 8; i++) {
      bits[(cnt++)] = (this.nextByte >> 7 - i & 0x1);
    }
    int result = 0;
    for (int i = 0; i < n; i++)
    {
      result <<= 1;
      result |= bits[i];
    }
    return result;
  }
  
  public bool isByteAligned()
  {
    return this.nBit % 8 == 0;
  }
  
  public void close()
  {}
  
  public int getCurBit()
  {
    return this.nBit;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.library.local.metadata.extractor.embedded.h264.BitstreamReader
 * JD-Core Version:    0.7.0.1
 */