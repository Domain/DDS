module org.serviio.external.DCRawCLBuilder;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class DCRawCLBuilder : AbstractCLBuilder
{
    private ProcessExecutorParameter inFile;
    private List!(ProcessExecutorParameter) inFileOptions = new ArrayList();
    static String executablePath = setupExecutablePath("dcraw.location", "dcraw_executable");

    public ProcessExecutorParameter[] build()
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
        Collections.addAll(this.inFileOptions, ProcessExecutorParameter.parameters(options));
        return this;
    }

    public DCRawCLBuilder inFile(String inFile)
    {
        this.inFile = new ProcessExecutorParameter(inFile);
        return this;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.external.DCRawCLBuilder
* JD-Core Version:    0.7.0.1
*/