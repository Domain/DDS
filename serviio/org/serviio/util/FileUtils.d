module org.serviio.util.FileUtils;

import java.lang.String;
import java.lang.Class;
import java.io.BufferedWriter;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.net.URL;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import org.apache.commons.io.FilenameUtils;

public class FileUtils
{
    public static bool fileExists(String filePath)
    {
        File f = new File(filePath);
        return f.exists();
    }

    public static String getProperFilePath(File file)
    {
        return file.getAbsolutePath();
    }

    public static Date getLastModifiedDate(File file)
    {
        Calendar calendar = new GregorianCalendar();
        calendar.setTimeInMillis(file.lastModified());
        calendar.set(14, 0);
        return calendar.getTime();
    }

    public static String getFileExtension(File file)
    {
        return getFileExtension(file.getName());
    }

    public static String getFileExtension(String fileName)
    {
        int dotPos = fileName.lastIndexOf(".");
        return fileName.substring(dotPos + 1);
    }

    public static String getFileExtension(URL url)
    {
        if (url !is null)
        {
            int dotPos = url.getPath().lastIndexOf(".");
            if (dotPos > -1) {
                return url.getPath().substring(dotPos + 1);
            }
        }
        return null;
    }

    public static String getFileNameWithoutExtension(File file)
    {
        int dotPos = file.getName().lastIndexOf(".");
        if (dotPos > -1) {
            return file.getName().substring(0, dotPos);
        }
        return file.getName();
    }

    public static String[] splitFilePathToDriveAndRest(String filePath)
    {
        String drive = filePath.substring(0, filePath.indexOf(':') + 1);
        String path = filePath.substring(drive.length());
        return cast(String[])[ drive, path ];
    }

    public static byte[] readFileBytes(File f)
    {
        InputStream input = new FileInputStream(f);


        long length = f.length();
        if (length > 2147483647L)
        {
            input.close();
            throw new IOException(String.format("File %s input too long", cast(Object[])[ f.getAbsolutePath() ]));
        }
        return readFileBytes(input, 0, cast(int)length);
    }

    public static byte[] readFileBytes(InputStream input, int maxLength)
    {
        ByteArrayOutputStream output = new ByteArrayOutputStream();
        try
        {
            byte[] buffer = new byte[2048];
            int numRead = 0;
            int l;
            while (((l = input.read(buffer)) != -1) && (numRead < maxLength))
            {
                output.write(buffer, 0, l);
                numRead += l;
            }
            return output.toByteArray();
        }
        finally
        {
            input.close();
            output.close();
        }
    }

    public static byte[] readFileBytes(InputStream input, int skip, int length)
    {
        try
        {
            byte[] bytes = new byte[length];


            int offset = skip;
            int numRead = 0;
            while ((offset < bytes.length) && ((numRead = input.read(bytes, offset, bytes.length - offset)) >= 0)) {
                offset += numRead;
            }
            return bytes;
        }
        finally
        {
            input.close();
        }
    }

    public static byte[] readFileBytes(InputStream input)
    {
        ByteArrayOutputStream output = new ByteArrayOutputStream();
        try
        {
            byte[] buffer = new byte[2048];
            int l;
            while ((l = input.read(buffer)) != -1) {
                output.write(buffer, 0, l);
            }
            return output.toByteArray();
        }
        finally
        {
            input.close();
            output.close();
        }
    }

    public static File getRelativeDirectory(File rootDir, String filePath)
    {
        String parentDir = rootDir.getPath();
        File file = new File(filePath);
        String fileDir = file.getParent();
        if (((Platform.isWindows()) && (parentDir.equalsIgnoreCase(fileDir))) || ((!Platform.isWindows()) && (parentDir.opEquals(fileDir)))) {
            return null;
        }
        if (((Platform.isWindows()) && (StringUtils.localeSafeToLowercase(fileDir).indexOf(StringUtils.localeSafeToLowercase(parentDir)) == 0)) || ((!Platform.isWindows()) && (fileDir.indexOf(parentDir) == 0)))
        {
            String relativeDir = "";
            if (parentDir.endsWith(File.separator)) {
                relativeDir = fileDir.substring(parentDir.length());
            } else {
                relativeDir = fileDir.substring(parentDir.length() + 1);
            }
            return new File(relativeDir);
        }
        throw new RuntimeException(String.format("The provided file path %s doesn't belong to root %s", cast(Object[])[ filePath, rootDir ]));
    }

    public static void closeQuietly(InputStream input)
    {
        if (input !is null) {
            try
            {
                input.close();
            }
            catch (IOException e) {}
        }
    }

    public static void closeQuietly(OutputStream os)
    {
        if (os !is null) {
            try
            {
                os.close();
            }
            catch (IOException e) {}
        }
    }

    public static InputStream getStreamFromClasspath(String filePath, Class/*!(?)*/ clazz)
    {
        InputStream input = clazz.getResourceAsStream(filePath);
        if (input is null) {
            throw new FileNotFoundException(String.format("File %s doesn't exist on the classpath", cast(Object[])[ filePath ]));
        }
        return input;
    }

    public static String getFilePathOfClasspathResource(String filePath, Class/*!(?)*/ clazz)
    {
        try
        {
            return getProperFilePath(new File(clazz.getResource(filePath).toURI()));
        }
        catch (Exception e) {}
        return null;
    }

    public static bool isPathAbsoulute(String filePath)
    {
        return FilenameUtils.getPrefixLength(filePath) > 0;
    }

    public static void copyStream(InputStream inputStream, OutputStream outputStream, long limit)
    {
        byte[] buffer = new byte[2048];
        long bytesCopied = 0L;
        int bytesRead;
        while ((bytesCopied < limit) && ((bytesRead = inputStream.read(buffer)) > 0)) {
            if (limit - bytesCopied >= bytesRead)
            {
                outputStream.write(buffer, 0, bytesRead);
                bytesCopied += bytesRead;
            }
            else
            {
                int subArrayLength = cast(int)(limit - bytesCopied);
                outputStream.write(Arrays.copyOfRange(buffer, 0, subArrayLength), 0, subArrayLength);
                bytesCopied += subArrayLength;
            }
        }
        outputStream.flush();
        inputStream.close();
    }

    public static void deleteDirOnExit(File dir)
    {
        dir.deleteOnExit();
        File[] files = dir.listFiles();
        if (files !is null) {
            foreach (File f ; files) {
                if (f.isDirectory()) {
                    deleteDirOnExit(f);
                } else {
                    f.deleteOnExit();
                }
            }
        }
    }

    public static bool deleteFileOrFolder(File file)
    {
        return org.apache.commons.io.FileUtils.deleteQuietly(file);
    }

    public static void writeFile(File targetFile, String text, String encoding)
    {
        BufferedWriter bw = null;
        try
        {
            bw = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(targetFile), encoding));
            bw.write(text);
            bw.flush();
        }
        finally
        {
            if (bw !is null) {
                bw.close();
            }
        }
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.util.FileUtils
* JD-Core Version:    0.7.0.1
*/