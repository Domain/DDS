module org.serviio.external.ProcessExecutorParameter;

import java.lang.String;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class ProcessExecutorParameter
{
    private String value;
    private bool quoted = false;

    public static String[] stringParameters(ProcessExecutorParameter[] params)
    {
        List!(String) list = stringParameters(Arrays.asList(params));
        return cast(String[])list.toArray(new String[list.size()]);
    }

    public static List!(String) stringParameters(List!(ProcessExecutorParameter) params)
    {
        List!(String) result = new ArrayList();
        foreach (ProcessExecutorParameter p ; params) {
            result.add(p.getValue());
        }
        return result;
    }

    public static ProcessExecutorParameter[] parameters(String[] params)
    {
        List!(ProcessExecutorParameter) result = new ArrayList();
        foreach (String p ; params) {
            result.add(new ProcessExecutorParameter(p));
        }
        return cast(ProcessExecutorParameter[])result.toArray(new ProcessExecutorParameter[result.size()]);
    }

    public this(String value)
    {
        this.value = value;
    }

    public this(String value, bool quoted)
    {
        this.value = value;
        this.quoted = quoted;
    }

    public String getValue()
    {
        return this.value;
    }

    public bool isQuoted()
    {
        return this.quoted;
    }

    override public String toString()
    {
        return this.value;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.external.ProcessExecutorParameter
* JD-Core Version:    0.7.0.1
*/