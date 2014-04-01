module org.serviio.external.DCRawCLBuilder;

import java.lang.String;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import org.serviio.external.AbstractCLBuilder;
import org.serviio.external.ProcessExecutorParameter;

public class DCRawCLBuilder : AbstractCLBuilder
{
    private ProcessExecutorParameter file;
    private List!(ProcessExecutorParameter) fileOptions = new ArrayList!(ProcessExecutorParameter)();
    static String executablePath;

    static this()
    {
        executablePath = setupExecutablePath("dcraw.location", "dcraw_executable");
    }

    override public ProcessExecutorParameter[] build()
    {
        List!(ProcessExecutorParameter) args = new ArrayList();
        args.add(new ProcessExecutorParameter(executablePath));
        if (this.inFile !is null)
        {
            args.addAll(this.inFileOptions);
            args.add(this.inFile);
        }
        ProcessExecutorParameter[] dcrawArgs = new ProcessExecutorParameter[args.size()];
        return cast(ProcessExecutorParameter[])args.toArray(dcrawArgs);
    }

    public DCRawCLBuilder inFileOptions(String[] options...)
    {
        Collections.addAll(this.fileOptions, ProcessExecutorParameter.parameters(options));
        return this;
    }

    public DCRawCLBuilder inFile(String inFile)
    {
        this.file = new ProcessExecutorParameter(inFile);
        return this;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.external.DCRawCLBuilder
* JD-Core Version:    0.7.0.1
*/