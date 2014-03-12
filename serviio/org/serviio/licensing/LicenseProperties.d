module org.serviio.licensing.LicenseProperties;

import java.lang.String;

public enum LicenseProperties
{
    TYPE,  EDITION,  VERSION,  ID,  NAME,  EMAIL
}

public String getName(LicenseProperties license)
{
    switch (license)
    {
        case TYPE: 
            return "type";
        case EDITION: 
            return "edition";
        case VERSION: 
            return "version";
        case ID: 
            return "id";
        case NAME: 
            return "name";
        case EMAIL: 
            return "email";
    }

    return null;
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.licensing.LicenseProperties
* JD-Core Version:    0.7.0.1
*/