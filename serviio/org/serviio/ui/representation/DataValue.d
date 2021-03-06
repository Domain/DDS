module org.serviio.ui.representation.DataValue;

import java.lang.String;

public class DataValue
{
    private String name;
    private String value;

    public this() {}

    public this(String name, String value)
    {
        this.name = name;
        this.value = value;
    }

    public String getName()
    {
        return this.name;
    }

    public void setName(String name)
    {
        this.name = name;
    }

    public String getValue()
    {
        return this.value;
    }

    public void setValue(String value)
    {
        this.value = value;
    }

    override public String toString()
    {
        return this.value;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.ui.representation.DataValue
* JD-Core Version:    0.7.0.1
*/