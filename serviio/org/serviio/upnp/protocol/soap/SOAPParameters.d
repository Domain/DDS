module org.serviio.upnp.protocol.soap.SOAPParameters;

import java.lang.annotation.Annotation;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Retention(RetentionPolicy.RUNTIME)
@Target({java.lang.annotation.ElementType.PARAMETER})
public @interface SOAPParameters
{
  SOAPParameter[] value();
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.upnp.protocol.soap.SOAPParameters
 * JD-Core Version:    0.7.0.1
 */