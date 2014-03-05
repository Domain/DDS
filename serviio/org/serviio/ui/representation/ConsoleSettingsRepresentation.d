module org.serviio.ui.representation.ConsoleSettingsRepresentation;

import java.lang;

public class ConsoleSettingsRepresentation
{
    private String language;
    private String securityPin;
    private Boolean checkForUpdates;

    public String getLanguage()
    {
        return this.language;
    }

    public void setLanguage(String language)
    {
        this.language = language;
    }

    public String getSecurityPin()
    {
        return this.securityPin;
    }

    public void setSecurityPin(String securityPin)
    {
        this.securityPin = securityPin;
    }

    public Boolean getCheckForUpdates()
    {
        return this.checkForUpdates;
    }

    public void setCheckForUpdates(Boolean checkForUpdates)
    {
        this.checkForUpdates = checkForUpdates;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.ui.representation.ConsoleSettingsRepresentation
* JD-Core Version:    0.7.0.1
*/