module org.apache.commons.io.FilenameUtils;

import java.lang.String;

import std.path;

public class FilenameUtils 
{
	public static String normalize(String path) 
    {
		return buildNormalizedPath(path);
	}

    public static String getName(String fullName) 
    {
        return baseName(fullName);
    }

    public static String getBaseName(String fullName) 
    {
        return fullName.baseName().stripExtension();
    }
}