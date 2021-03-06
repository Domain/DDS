module org.serviio.upnp.protocol.soap.OperationResult;

import java.lang.String;
import java.util.LinkedHashMap;
import java.util.Map;
import org.serviio.upnp.protocol.soap.InvocationError;

public class OperationResult
{
    private Map!(String, Object) outputParameters;
    private InvocationError error;

    public this() 
    {
        outputParameters = new LinkedHashMap!(String, Object)();
    }

    public this(InvocationError error)
    {
        this.error = error;
    }

    public void addOutputParameter(String name, Object value)
    {
        this.outputParameters.put(name, value);
    }

    public Map!(String, Object) getOutputParameters()
    {
        return this.outputParameters;
    }

    public InvocationError getError()
    {
        return this.error;
    }

    public void setError(InvocationError error)
    {
        this.error = error;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.protocol.soap.OperationResult
* JD-Core Version:    0.7.0.1
*/