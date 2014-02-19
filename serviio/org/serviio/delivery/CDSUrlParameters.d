module org.serviio.delivery.CDSUrlParameters;

import org.serviio.util.StringUtils;

public class CDSUrlParameters
: URLParameters
{
    public static immutable String AUTH_PARAM_NAME = "authToken";
    public static immutable String PROFILE_PARAM_NAME = "profile";
    public static immutable String IGNORE_PRESENTATION_SETTINGS_PARAM_NAME = "ignorePresentationSettings";
    private static immutable String sharedSecurityToken = "";
    private final bool useSharedSecurity;
    private immutable String profileId;

    public this(bool useSharedSecurity, String profileId)
    {
        this.useSharedSecurity = useSharedSecurity;
        this.profileId = profileId;
    }

    public static String getSharedSecurityToken()
    {
        return sharedSecurityToken;
    }

    public String get()
    {
        StringBuffer sb = new StringBuffer();
        if (this.profileId !is null) {
            sb.append("profile").append("=").append(this.profileId);
        }
        if (this.useSharedSecurity) {
            sb.append("&").append("authToken").append("=").append(sharedSecurityToken);
        }
        return sb.toString();
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.delivery.CDSUrlParameters
* JD-Core Version:    0.7.0.1
*/