module org.serviio.upnp.service.contentdirectory.definition.StaticDefinitionNode;

import java.lang.String;

public abstract interface StaticDefinitionNode
{
    public abstract String getId();

    public abstract void setId(String paramString);

    public abstract String getTitle();

    public abstract bool isEditable();

    public abstract void setEditable(bool paramBoolean);
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.service.contentdirectory.definition.StaticDefinitionNode
* JD-Core Version:    0.7.0.1
*/