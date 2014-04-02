/*
* Decompiled with CFR 0_66.
*/
module org.serviio.ApplicationSettings;

import java.lang;
import java.io.InputStream;
import java.util.Properties;

public class ApplicationSettings {
    private static Properties properties;

    static this()
    {
        properties = new Properties();
    }

    public static Properties getProperties() {
        return ApplicationSettings.properties;
    }

    public static String getStringProperty(String name) {
        return cast(String)ApplicationSettings.getProperties().get(name);
    }

    public static Integer getIntegerProperty(String name) {
        String strValue = ApplicationSettings.getStringProperty(name);
        if (strValue is null) return null;
        return Integer.valueOf(strValue);
    }

    static this() {
        try {
            ApplicationSettings.properties.load(ApplicationSettings.class_.getResourceAsStream("/serviio.properties"));
        }
        catch (Exception e) {
            // empty catch block
        }
    }
}

