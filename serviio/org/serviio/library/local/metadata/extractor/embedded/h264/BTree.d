module org.serviio.library.local.metadata.extractor.embedded.h264.BTree;

import java.lang.String;

public class BTree
{
    private BTree zero;
    private BTree one;
    private Object value;

    public void addString(String path, Object value)
    {
        if (path.length() == 0)
        {
            this.value = value;
            return;
        }
        char charAt = path.charAt(0);
        BTree branch;
        if (charAt == '0')
        {
            if (this.zero is null) {
                this.zero = new BTree();
            }
            branch = this.zero;
        }
        else
        {
            if (this.one is null) {
                this.one = new BTree();
            }
            branch = this.one;
        }
        branch.addString(path.substring(1), value);
    }

    public BTree down(int b)
    {
        if (b == 0) {
            return this.zero;
        }
        return this.one;
    }

    public Object getValue()
    {
        return this.value;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.local.metadata.extractor.embedded.h264.BTree
* JD-Core Version:    0.7.0.1
*/