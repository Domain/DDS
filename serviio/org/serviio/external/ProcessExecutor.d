module org.serviio.external.ProcessExecutor;

import java.lang;
import java.io.IOException;
import java.io.OutputStream;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import org.serviio.delivery.subtitles.SubtitlesService;
import org.serviio.external.io.OutputBytesReader;
import org.serviio.external.io.OutputReader;
import org.serviio.external.io.OutputTextReader;
import org.serviio.external.io.PipedOutputBytesReader;
import org.serviio.util.CollectionUtils;
import org.serviio.util.FileUtils;
import org.serviio.util.ObjectValidator;
import org.serviio.util.Platform;
import org.serviio.util.ProcessUtils;
import org.serviio.util.StringUtils;
import org.serviio.external.ProcessListener;
import org.serviio.external.ProcessExecutorParameter;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class ProcessExecutor : Thread
{
    private static Logger log;
    private static immutable int OUTPUT_STREAM_TIMEOUT = 5000;
    private ProcessExecutorParameter[] commandArguments;
    private bool destroyed = false;
    private bool checkForExitValue = false;
    private Long failsafeTimeout;
    private Process process;
    private OutputReader stdoutReader;
    private OutputTextReader stderrReader;
    private bool success = true;
    private bool unlimitedPipe = false;
    private bool useStdOutForTextOutput = false;
    private Set!(ProcessListener) listeners;

    static this()
    {
        log = LoggerFactory.getLogger!(ProcessExecutor);
    }

    public this(ProcessExecutorParameter[] commandArguments)
    {
        this(commandArguments, false);
    }

    public this(ProcessExecutorParameter[] commandArguments, bool checkForExitValue)
    {
        this(commandArguments, checkForExitValue, null);
    }

    public this(ProcessExecutorParameter[] commandArguments, bool checkForExitValue, Long failsafeTimeout)
    {
        this(commandArguments, checkForExitValue, failsafeTimeout, false);
    }

    public this(ProcessExecutorParameter[] commandArguments, bool checkForExitValue, Long failsafeTimeout, bool unlimitedPipe)
    {
        this(commandArguments, checkForExitValue, failsafeTimeout, unlimitedPipe, false);
    }

    public this(ProcessExecutorParameter[] commandArguments, bool checkForExitValue, Long failsafeTimeout, bool unlimitedPipe, bool useStdOutForTextOutput)
    {
        listeners = new HashSet!(ProcessListener)();
        this.commandArguments = commandArguments;
        this.checkForExitValue = checkForExitValue;
        this.failsafeTimeout = failsafeTimeout;
        this.unlimitedPipe = unlimitedPipe;
        this.useStdOutForTextOutput = useStdOutForTextOutput;
    }

    override public void run()
    {
        Thread faisafeThread = null;
        try
        {
            log.debug_("Starting " + CollectionUtils.arrayToCSV(this.commandArguments, " "));

            ProcessBuilder processBuilder = new ProcessBuilder(ProcessExecutorParameter.stringParameters(this.commandArguments));
            Map!(String, String) env = processBuilder.environment();
            if (Platform.isMac())
            {
                env.putAll(createOSXRuntimeEnvironmentVariables());
            }
            else if (Platform.isWindows())
            {
                env.putAll(createWindowsRuntimeEnvironmentVariables());

                processBuilder.command(ProcessExecutorParameter.stringParameters(this.commandArguments));
            }
            this.process = processBuilder.start();
            this.stderrReader = new OutputTextReader(this, this.process.getErrorStream());
            if (this.useStdOutForTextOutput) {
                this.stdoutReader = new OutputTextReader(this, this.process.getInputStream());
            } else if (this.unlimitedPipe) {
                this.stdoutReader = new PipedOutputBytesReader(this.process.getInputStream());
            } else {
                this.stdoutReader = new OutputBytesReader(this.process.getInputStream());
            }
            this.stderrReader.start();
            this.stdoutReader.start();
            if (this.failsafeTimeout !is null) {
                faisafeThread = makeFailSafe(this.failsafeTimeout);
            }
            try
            {
                this.process.waitFor();
                this.stdoutReader.join(5000L);
                this.stderrReader.join(5000L);
            }
            catch (InterruptedException e) {}
            if ((!this.destroyed) && (this.checkForExitValue)) {
                try
                {
                    if ((this.process !is null) && (this.process.exitValue() != 0))
                    {
                        StringBuffer errorMessage = new StringBuffer();
                        errorMessage.append(String.format("Process %s has a return code of %s! This is a possible error.", cast(Object[])[ this.commandArguments[0], Integer.valueOf(this.process.exitValue()) ]));
                        String last5Lines = this.stderrReader.getLast5Lines();
                        if (ObjectValidator.isNotEmpty(last5Lines)) {
                            errorMessage.append(" Detailed output follows.").append(StringUtils.LINE_SEPARATOR).append(last5Lines);
                        }
                        log.warn(errorMessage.toString());
                        this.success = false;

                        notifyListenersEnd(Boolean.valueOf(false));
                    }
                    else if ((this.process !is null) && (this.process.exitValue() == 0))
                    {
                        notifyListenersEnd(Boolean.valueOf(true));
                    }
                }
                catch (IllegalThreadStateException e)
                {
                    log.error(String.format("Error during finishing process execution: %s", cast(Object[])[ e.getMessage() ]));
                }
            } else if (!this.destroyed) {
                notifyListenersEnd(Boolean.valueOf(true));
            }
            this.destroyed = true;
            if (faisafeThread !is null) {
                faisafeThread.interrupt();
            }
            closeStreams();
        }
        catch (Exception e)
        {
            log.error("Fatal error in process starting: " + e.getMessage(), e);
            this.success = false;
            stopProcess(false);
            if ((!this.destroyed) && (this.checkForExitValue)) {
                try
                {
                    if ((this.process !is null) && (this.process.exitValue() != 0))
                    {
                        StringBuffer errorMessage = new StringBuffer();
                        errorMessage.append(String.format("Process %s has a return code of %s! This is a possible error.", cast(Object[])[ this.commandArguments[0], Integer.valueOf(this.process.exitValue()) ]));
                        String last5Lines = this.stderrReader.getLast5Lines();
                        if (ObjectValidator.isNotEmpty(last5Lines)) {
                            errorMessage.append(" Detailed output follows.").append(StringUtils.LINE_SEPARATOR).append(last5Lines);
                        }
                        log.warn(errorMessage.toString());
                        this.success = false;

                        notifyListenersEnd(Boolean.valueOf(false));
                    }
                    else if ((this.process !is null) && (this.process.exitValue() == 0))
                    {
                        notifyListenersEnd(Boolean.valueOf(true));
                    }
                }
                catch (IllegalThreadStateException e)
                {
                    log.error(String.format("Error during finishing process execution: %s", cast(Object[])[ e.getMessage() ]));
                }
            } else if (!this.destroyed) {
                notifyListenersEnd(Boolean.valueOf(true));
            }
            this.destroyed = true;
            if (faisafeThread !is null) {
                faisafeThread.interrupt();
            }
            closeStreams();
        }
        finally
        {
            if ((!this.destroyed) && (this.checkForExitValue)) {
                try
                {
                    if ((this.process !is null) && (this.process.exitValue() != 0))
                    {
                        StringBuffer errorMessage = new StringBuffer();
                        errorMessage.append(String.format("Process %s has a return code of %s! This is a possible error.", cast(Object[])[ this.commandArguments[0], Integer.valueOf(this.process.exitValue()) ]));
                        String last5Lines = this.stderrReader.getLast5Lines();
                        if (ObjectValidator.isNotEmpty(last5Lines)) {
                            errorMessage.append(" Detailed output follows.").append(StringUtils.LINE_SEPARATOR).append(last5Lines);
                        }
                        log.warn(errorMessage.toString());
                        this.success = false;

                        notifyListenersEnd(Boolean.valueOf(false));
                    }
                    else if ((this.process !is null) && (this.process.exitValue() == 0))
                    {
                        notifyListenersEnd(Boolean.valueOf(true));
                    }
                }
                catch (IllegalThreadStateException e)
                {
                    log.error(String.format("Error during finishing process execution: %s", cast(Object[])[ e.getMessage() ]));
                }
            } else if (!this.destroyed) {
                notifyListenersEnd(Boolean.valueOf(true));
            }
            this.destroyed = true;
            if (faisafeThread !is null) {
                faisafeThread.interrupt();
            }
            closeStreams();
        }
    }

    public void addListener(ProcessListener listener)
    {
        this.listeners.add(listener);
        listener.setExecutor(this);
    }

    public void stopProcess(bool success)
    {
        if ((this.process !is null) && (!this.destroyed))
        {
            log.debug_(String.format("Stopping external process: %s", cast(Object[])[ this ]));
            ProcessUtils.destroy(this.process);
            this.destroyed = true;
            closeStreams();

            notifyListenersEnd(Boolean.valueOf(success));
        }
    }

    public OutputStream getOutputStream()
    {
        if (this.stdoutReader !is null) {
            return this.stdoutReader.getOutputStream();
        }
        return null;
    }

    public List!(String) getResults()
    {
        if (this.useStdOutForTextOutput) {
            return getResultsFromStream(this.stdoutReader);
        }
        return getResultsFromStream(this.stderrReader);
    }

    private List!(String) getResultsFromStream(OutputReader reader)
    {
        if (reader !is null)
        {
            try
            {
                reader.join(1000L);
            }
            catch (InterruptedException e) {}
            return reader.getResults();
        }
        log.warn("Cannot retrieve results, output reader is null");
        return Collections.emptyList();
    }

    public bool isSuccess()
    {
        return this.success;
    }

    public void notifyListenersOutputUpdated(String updatedLine)
    {
        foreach (ProcessListener listener ; this.listeners) {
            listener.outputUpdated(updatedLine);
        }
    }

    private Map!(String, String) createOSXRuntimeEnvironmentVariables()
    {
        Map!(String, String) newEnv = new HashMap();
        newEnv.putAll(System.getenv());
        newEnv.putAll(createFontConfigRuntimeEnvironmentVariables());
        if (log.isTraceEnabled()) {
            log.trace(String.format("Env variables: %s", cast(Object[])[ newEnv.toString() ]));
        }
        return newEnv;
    }

    private Map!(String, String) createWindowsRuntimeEnvironmentVariables()
    {
        Map!(String, String) newEnv = new HashMap();
        newEnv.putAll(System.getenv());
        ProcessExecutorParameter[] i18n = new ProcessExecutorParameter[this.commandArguments.length + 2];
        i18n[0] = new ProcessExecutorParameter("cmd");
        i18n[1] = new ProcessExecutorParameter("/C");
        for (int counter = 0; counter < this.commandArguments.length; counter++)
        {
            ProcessExecutorParameter argument = this.commandArguments[counter];
            String envName = "JENV_" + counter;
            i18n[(counter + 2)] = new ProcessExecutorParameter("%" + envName + "%");
            bool quotesNeeded = quotesNeededForWindows(argument);
            if ((!quotesNeeded) && (!argument.isQuoted())) {
                argument = new ProcessExecutorParameter(escapeAmpersandForWindows(argument.getValue()));
            }
            newEnv.put(envName, wrapInQuotes(argument, quotesNeeded));
        }
        this.commandArguments = i18n;
        String[] tempPath = FileUtils.splitFilePathToDriveAndRest(System.getProperty("java.io.tmpdir"));
        newEnv.put("HOMEDRIVE", tempPath[0]);
        newEnv.put("HOMEPATH", tempPath[1]);
        newEnv.putAll(createFontConfigRuntimeEnvironmentVariables());
        if (log.isTraceEnabled()) {
            log.trace(String.format("Env variables: %s", cast(Object[])[ newEnv.toString() ]));
        }
        return newEnv;
    }

    private String wrapInQuotes(ProcessExecutorParameter argument, bool quotesNeeded)
    {
        return (quotesNeeded ? "\"" : "") + argument + (quotesNeeded ? "\"" : "");
    }

    protected bool quotesNeededForWindows(ProcessExecutorParameter argument)
    {
        bool quotesNeeded = (!argument.isQuoted()) && (argument.getValue().indexOf(" ") > -1);
        return quotesNeeded;
    }

    private String escapeAmpersandForWindows(String value)
    {
        return value.replaceAll("&", "^&");
    }

    private Map!(String, String) createFontConfigRuntimeEnvironmentVariables()
    {
        Map!(String, String) newEnv = new HashMap();
        newEnv.put("FONTCONFIG_FILE", "fonts.conf");
        newEnv.put("FONTCONFIG_PATH", SubtitlesService.FONT_CONFIG_DIR);
        return newEnv;
    }

    private Thread makeFailSafe(immutable Long timeout)
    {
        Runnable r = new class() Runnable {
            public void run()
            {
                try
                {
                    Thread.sleep(timeout.longValue());
                }
                catch (InterruptedException e) {}
                this.outer.stopProcess(false);
            }
        };
        Thread failsafe = new Thread(r);
        failsafe.start();
        return failsafe;
    }

    private void notifyListenersEnd(Boolean success)
    {
        foreach (ProcessListener listener ; this.listeners) {
            listener.processEnded(success.boolValue());
        }
    }

    private void closeStreams()
    {
        if (this.stderrReader !is null) {
            this.stderrReader.closeStream();
        }
        if (this.stdoutReader !is null) {
            this.stdoutReader.closeStream();
        }
        if (this.process !is null) {
            FileUtils.closeQuietly(this.process.getOutputStream());
        }
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.external.ProcessExecutor
* JD-Core Version:    0.7.0.1
*/