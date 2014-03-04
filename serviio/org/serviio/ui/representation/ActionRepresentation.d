module org.serviio.ui.representation.ActionRepresentation;

import java.lang.String;
import com.google.gson.annotations.SerializedName;
import com.thoughtworks.xstream.annotations.XStreamImplicit;
import java.util.ArrayList;
import java.util.List;

public class ActionRepresentation
{
    private String name;
    @XStreamImplicit(itemFieldName="parameter")
    @SerializedName("parameter")
    private List!(String) parameters = new ArrayList();

    public String getName()
    {
        return this.name;
    }

    public void setName(String name)
    {
        this.name = name;
    }

    public List!(String) getParameters()
    {
        return this.parameters;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.ui.representation.ActionRepresentation
* JD-Core Version:    0.7.0.1
*/