module org.serviio.util.StringUtils;

import java.lang.String;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.Charset;
import java.text.Normalizer;
import java.text.Normalizer:Form;
import java.util.Locale;
import java.util.UUID;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class StringUtils
{
    public static immutable String UTF_8_ENCODING = "UTF-8";
    public static String LINE_SEPARATOR;
    private static immutable Pattern articlesPattern;

    static this()
    {
        LINE_SEPARATOR = System.getProperty("line.separator");
        articlesPattern = Pattern.compile("^(the|a)(\\s|\\.(?!\\s)|_)(?!&)", 2);
    }

    public static String removeArticles(String value)
    {
        if (value !is null)
        {
            value = value.replaceAll("'|\"", "");
            return articlesPattern.matcher(value).replaceFirst("");
        }
        return null;
    }

    public static String removeAccents(String value)
    {
        String result = Normalizer.normalize(value, Normalizer.Form.NFD);
        return result.replaceAll("\\p{InCombiningDiacriticalMarks}+", "");
    }

    public static String readStreamAsString(InputStream stream, String encoding)
    {
        BufferedReader input = null;
        try
        {
            input = new BufferedReader(new InputStreamReader(stream, Charset.forName(encoding)));


            StringBuffer sb = new StringBuffer();
            int count = 0;
            String inputLine;
            while ((inputLine = input.readLine()) !is null)
            {
                if (count > 0) {
                    sb.append(LINE_SEPARATOR);
                }
                sb.append(inputLine);
                count++;
            }
            return sb.toString();
        }
        finally
        {
            if (input !is null) {
                try
                {
                    input.close();
                }
                catch (IOException e) {}
            }
        }
    }

    public static String readFileAsString(File file, String encoding)
    {
        return readStreamAsString(new FileInputStream(file), encoding);
    }

    public static String trim(String str)
    {
        if (str !is null) {
            return str.trim();
        }
        return null;
    }

    public static int getUnicodeCode(String letter)
    {
        char c = letter.charAt(0);
        return c;
    }

    public static String getCharacterForCode(int unicode)
    {
        return String.valueOf(cast(char)unicode);
    }

    public static String localeSafeToUppercase(String value)
    {
        if (value !is null) {
            return value.toUpperCase(Locale.ENGLISH);
        }
        return null;
    }

    public static String localeSafeToLowercase(String value)
    {
        if (value !is null) {
            return value.toLowerCase(Locale.ENGLISH);
        }
        return null;
    }

    public static byte[] hexStringToByteArray(String str)
    {
        char[] hex = str.toCharArray();
        int length = hex.length / 2;
        byte[] raw = new byte[length];
        for (int i = 0; i < length; i++)
        {
            int high = Character.digit(hex[(i * 2)], 16);
            int low = Character.digit(hex[(i * 2 + 1)], 16);
            int value = high << 4 | low;
            if (value > 127) {
                value -= 256;
            }
            raw[i] = (cast(byte)value);
        }
        return raw;
    }

    public static String removeNewLineCharacters(String text)
    {
        return text.replaceAll("[\\r\\n]", "");
    }

    public static String[] splitStringToLines(String content)
    {
        return content.split("\\r?\\n|\\r");
    }

    public static immutable String trimWithEllipsis(String text, int maxLength)
    {
        if (ObjectValidator.isNotEmpty(text))
        {
            if (text.length() > maxLength) {
                return text.substring(0, maxLength - 3) + "...";
            }
            return text;
        }
        return text;
    }

    public static String generateRandomToken()
    {
        return UUID.randomUUID().toString().replaceAll("-", "");
    }

    public static String toString(Object o)
    {
        if (o !is null) {
            return o.toString();
        }
        return null;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.util.StringUtils
* JD-Core Version:    0.7.0.1
*/