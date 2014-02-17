module org.serviio.upnp.protocol.soap.OperationResult;

import java.util.LinkedHashMap;
import java.util.Map;

public class OperationResult
{
  private Map!(String, Object) outputParameters = new LinkedHashMap();
  private InvocationError error;
  
  public this() {}
  
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