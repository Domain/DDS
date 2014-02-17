module org.serviio.upnp.service.contentdirectory.classes.Person;

public class Person
  : Container
{
  protected String language;
  
  public this(String id, String title)
  {
    super(id, title);
  }
  
  public ObjectClassType getObjectClass()
  {
    return ObjectClassType.PERSON;
  }
  
  public String getLanguage()
  {
    return this.language;
  }
  
  public void setLanguage(String language)
  {
    this.language = language;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.upnp.service.contentdirectory.classes.Person
 * JD-Core Version:    0.7.0.1
 */