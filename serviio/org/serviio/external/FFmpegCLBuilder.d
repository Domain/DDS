module org.serviio.external.FFmpegCLBuilder;

import java.lang.String;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import org.serviio.external.AbstractCLBuilder;
import org.serviio.external.ProcessExecutorParameter;

public class FFmpegCLBuilder : AbstractCLBuilder
{
    private List!(ProcessExecutorParameter) _globalOptions = new ArrayList();
    private List!(ProcessExecutorParameter) _inFileOptions = new ArrayList();
    private List!(ProcessExecutorParameter) _outFileOptions = new ArrayList();
    static String executablePath = setupExecutablePath("ffmpeg.location", "ffmpeg_executable");
    private ProcessExecutorParameter _inFile;
    private ProcessExecutorParameter _outFile;

    override public ProcessExecutorParameter[] build()
    {
        List!(ProcessExecutorParameter) args = new ArrayList();
        args.add(new ProcessExecutorParameter(executablePath));
        args.addAll(this._globalOptions);
        if (this._inFile !is null)
        {
            args.addAll(this._inFileOptions);
            args.add(new ProcessExecutorParameter("-i"));
            args.add(this._inFile);
        }
        if (this._outFile !is null)
        {
            args.addAll(this._outFileOptions);
            args.add(this._outFile);
        }
        ProcessExecutorParameter[] ffmpegArgs = new ProcessExecutorParameter[args.size()];
        return cast(ProcessExecutorParameter[])args.toArray(ffmpegArgs);
    }

    public FFmpegCLBuilder globalOptions(String[] options...)
    {
        Collections.addAll(this._globalOptions, ProcessExecutorParameter.parameters(options));
        return this;
    }

    public FFmpegCLBuilder inFileOptions(String[] options...)
    {
        Collections.addAll(this._inFileOptions, ProcessExecutorParameter.parameters(options));
        return this;
    }

    public FFmpegCLBuilder outFileOptions(String[] options...)
    {
        Collections.addAll(this._outFileOptions, ProcessExecutorParameter.parameters(options));
        return this;
    }

    public FFmpegCLBuilder outFileOption(String option, bool isQuoted)
    {
        Collections.addAll(this._outFileOptions, cast(ProcessExecutorParameter[])[ new ProcessExecutorParameter(option, isQuoted) ]);
        return this;
    }

    public FFmpegCLBuilder inFile(String _inFile)
    {
        this._inFile = new ProcessExecutorParameter(_inFile);
        return this;
    }

    public FFmpegCLBuilder outFile(String _outFile)
    {
        this._outFile = new ProcessExecutorParameter(_outFile);
        return this;
    }

    List!(String) getOutFileOptions()
    {
        return Collections.unmodifiableList(ProcessExecutorParameter.stringParameters(this._outFileOptions));
    }

    List!(String) getInFileOptions()
    {
        return Collections.unmodifiableList(ProcessExecutorParameter.stringParameters(this._inFileOptions));
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.external.FFmpegCLBuilder
* JD-Core Version:    0.7.0.1
*/