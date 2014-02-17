module org.serviio.external.FFmpegCLBuilder;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class FFmpegCLBuilder
  : AbstractCLBuilder
{
  private final List!(ProcessExecutorParameter) globalOptions = new ArrayList();
  private final List!(ProcessExecutorParameter) inFileOptions = new ArrayList();
  private final List!(ProcessExecutorParameter) outFileOptions = new ArrayList();
  static String executablePath = setupExecutablePath("ffmpeg.location", "ffmpeg_executable");
  private ProcessExecutorParameter inFile;
  private ProcessExecutorParameter outFile;
  
  public ProcessExecutorParameter[] build()
  {
    List!(ProcessExecutorParameter) args = new ArrayList();
    args.add(new ProcessExecutorParameter(executablePath));
    args.addAll(this.globalOptions);
    if (this.inFile !is null)
    {
      args.addAll(this.inFileOptions);
      args.add(new ProcessExecutorParameter("-i"));
      args.add(this.inFile);
    }
    if (this.outFile !is null)
    {
      args.addAll(this.outFileOptions);
      args.add(this.outFile);
    }
    ProcessExecutorParameter[] ffmpegArgs = new ProcessExecutorParameter[args.size()];
    return cast(ProcessExecutorParameter[])args.toArray(ffmpegArgs);
  }
  
  public FFmpegCLBuilder globalOptions(String... options)
  {
    Collections.addAll(this.globalOptions, ProcessExecutorParameter.parameters(options));
    return this;
  }
  
  public FFmpegCLBuilder inFileOptions(String... options)
  {
    Collections.addAll(this.inFileOptions, ProcessExecutorParameter.parameters(options));
    return this;
  }
  
  public FFmpegCLBuilder outFileOptions(String... options)
  {
    Collections.addAll(this.outFileOptions, ProcessExecutorParameter.parameters(options));
    return this;
  }
  
  public FFmpegCLBuilder outFileOption(String option, bool isQuoted)
  {
    Collections.addAll(this.outFileOptions, cast(ProcessExecutorParameter[])[ new ProcessExecutorParameter(option, isQuoted) ]);
    return this;
  }
  
  public FFmpegCLBuilder inFile(String inFile)
  {
    this.inFile = new ProcessExecutorParameter(inFile);
    return this;
  }
  
  public FFmpegCLBuilder outFile(String outFile)
  {
    this.outFile = new ProcessExecutorParameter(outFile);
    return this;
  }
  
  List!(String) getOutFileOptions()
  {
    return Collections.unmodifiableList(ProcessExecutorParameter.stringParameters(this.outFileOptions));
  }
  
  List!(String) getInFileOptions()
  {
    return Collections.unmodifiableList(ProcessExecutorParameter.stringParameters(this.inFileOptions));
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.external.FFmpegCLBuilder
 * JD-Core Version:    0.7.0.1
 */