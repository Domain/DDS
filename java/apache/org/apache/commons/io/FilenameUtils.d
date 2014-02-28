module org.apache.commons.io.FilenameUtils;

import java.lang.String;

import std.path;

public class FilenameUtils 
{
	public static String normalize(String path) 
    {
		return buildNormalizedPath(path);
	}

    public static String gatName(String fullName) 
    {
        return baseName(fullName);
    }
}