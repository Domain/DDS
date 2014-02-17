module org.serviio.upnp.protocol.soap.InvocationError;

public enum InvocationError
{
  INVALID_ACTION,  INVALID_ARGS,  INVALID_VAR,  ACTION_FAILED,  CON_MAN_INVALID_CONNECTION_REFERENCE,  CON_MAN_NO_SUCH_OBJECT,  CON_MAN_NO_SUCH_CONTAINER;
  
  private this() {}
  
  public abstract int getCode();
  
  public abstract String getDescription();
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.upnp.protocol.soap.InvocationError
 * JD-Core Version:    0.7.0.1
 */