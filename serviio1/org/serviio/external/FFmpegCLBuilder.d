module org.serviio.external.FFmpegCLBuilder;

import java.lang.String;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import org.serviio.external.DCRawCLBuilder;
import org.serviio.external.AbstractCLBuilder;

public class FFmpegCLBuilder : AbstractCLBuilder
{
    static String executablePath;

    private /*final*/ List!(String) _globalOptions;
    private /*final*/ List!(String) _inFileOptions;
    private String _inFile;
    private /*final*/ List!(String) _outFileOptions;
    private String _outFile;

    static this()
    {
        executablePath = setupExecutablePath("ffmpeg.location", "ffmpeg_executable");
    }

    public this()
    {
        _globalOptions = new ArrayList!(String)();
        _inFileOptions = new ArrayList!(String)();
        _outFileOptions = new ArrayList!(String)();
    }

    override public String[] build()
    {
        List!(String) args = new ArrayList!(String)();
        args.add(executablePath);
        args.addAll(_globalOptions);
        if (_inFile !is null) {
            args.addAll(_inFileOptions);
            args.add("-i");
            args.add(_inFile);
        }
        if (_outFile !is null) {
            args.addAll(_outFileOptions);
            args.add(_outFile);
        }
        String[] ffmpegArgs = new String[args.size()];
        return cast(String[])args.toArray(ffmpegArgs);
    }

    public FFmpegCLBuilder globalOptions(String[] options) {
        Collections.addAll(_globalOptions, options);
        return this;
    }

    public FFmpegCLBuilder inFileOptions(String[] options) {
        Collections.addAll(_inFileOptions, options);
        return this;
    }

    public FFmpegCLBuilder outFileOptions(String[] options) {
        Collections.addAll(_outFileOptions, options);
        return this;
    }

    public FFmpegCLBuilder inFile(String inFile) {
        this._inFile = inFile;
        return this;
    }

    public FFmpegCLBuilder outFile(String outFile) {
        this._outFile = outFile;
        return this;
    }

    List!(String) getOutFileOptions() {
        return Collections.unmodifiableList(_outFileOptions);
    }
}

/* Location:           D:\Program Files\Serviio\lib\serviio.jar
* Qualified Name:     org.serviio.external.FFmpegCLBuilder
* JD-Core Version:    0.6.2
*/