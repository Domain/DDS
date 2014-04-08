module org.serviio.external.DCRawWrapper;

import java.lang.Boolean;
import java.lang.String;
import java.lang.Long;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.List;
import java.util.concurrent.atomic.AtomicReference;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.serviio.external.AbstractExecutableWrapper;
import org.serviio.external.ProcessExecutor;
import org.serviio.external.DCRawCLBuilder;

public class DCRawWrapper : AbstractExecutableWrapper
{
    private static Logger log;
    protected static AtomicReference!(Boolean) present;

    static this()
    {
        log = LoggerFactory.getLogger!(DCRawWrapper);
        present = new AtomicReference!(Boolean)();
    }

    public static bool dcrawPresent()
    {
        if (present.get() is null)
        {
            DCRawCLBuilder builder = new DCRawCLBuilder();

            log.debug_(java.lang.String.format("Invoking DCRAW to check if it exists of path %s", cast(Object[])[ DCRawCLBuilder.executablePath ]));
            ProcessExecutor executor = processExecutorForTextOutput(builder);
            executeSynchronously(executor);
            present.set(Boolean.valueOf((executor.isSuccess()) && (executor.getResults().size() > 5)));
        }
        return (cast(Boolean)present.get()).boolValue();
    }

    public static byte[] retrieveThumbnailFromRawFile(String filePath)
    {
        DCRawCLBuilder builder = new DCRawCLBuilder();

        builder.inFile(filePath);
        builder.inFileOptions(cast(String[])[ "-c" ]);
        builder.inFileOptions(cast(String[])[ "-e" ]);

        log.debug_(java.lang.String.format("Invoking DCRAW to retrieve thumbnail from file: %s", cast(Object[])[ filePath ]));
        ProcessExecutor executor = new ProcessExecutor(builder.build(), false, new Long(10000L));
        executeSynchronously(executor);
        ByteArrayOutputStream output = cast(ByteArrayOutputStream)executor.getOutputStream();
        if (output !is null) {
            return output.toByteArray();
        }
        return null;
    }

    private static ProcessExecutor processExecutorForTextOutput(DCRawCLBuilder builder)
    {
        return new ProcessExecutor(builder.build(), false, null, false, true);
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.external.DCRawWrapper
* JD-Core Version:    0.7.0.1
*/