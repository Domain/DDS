module org.serviio.restlet.ResultRepresentation;

import java.lang;
import com.google.gson.annotations.SerializedName;
import com.thoughtworks.xstream.annotations.XStreamImplicit;
import java.util.List;

public class ResultRepresentation
{
    private Integer errorCode = Integer.valueOf(0);
    //@XStreamImplicit(itemFieldName="parameter")
    //@SerializedName("parameter")
    private List!(String) parameters;

    public this() {}

    public this(Integer errorCode, List!(String) parameters)
    {
        this.errorCode = errorCode;
        this.parameters = parameters;
    }

    public Integer getErrorCode()
    {
        return this.errorCode;
    }

    public void setErrorCode(Integer errorCode)
    {
        this.errorCode = errorCode;
    }

    public List!(String) getParameters()
    {
        return this.parameters;
    }

    public void setParameters(List!(String) parameters)
    {
        this.parameters = parameters;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.restlet.ResultRepresentation
* JD-Core Version:    0.7.0.1
*/