module org.serviio.delivery.resource.transcode.TranscodingJobListener;

import java.lang;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.PipedInputStream;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Set;
import java.util.TreeMap;
import org.serviio.delivery.Client;
import org.serviio.external.ProcessExecutor;
import org.serviio.external.ProcessListener;
import org.serviio.util.DateUtils;
import org.serviio.util.FileUtils;
import org.serviio.delivery.resource.transcode.TranscodeInputStream;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class TranscodingJobListener : ProcessListener
{
    private static Logger log;
    private String transcodingIdentifier;
    private File transcodedFile;
    private PipedInputStream transcodedStream;
    private bool isSegmentedOutput;
    private Set!(TranscodeInputStream) processingStreams;
    private bool started = false;
    private bool successful = true;
    private TreeMap!(Double, ProgressData) timeFilesizeMap;
    private /*volatile*/ bool shuttingDown = false;

    static this()
    {
        log = LoggerFactory.getLogger!(TranscodingJobListener);
    }

    public this(String transcodingIdentifier, bool isSegmentedOutput)
    {
        processingStreams = new HashSet!(TranscodeInputStream)();
        timeFilesizeMap = new TreeMap!(Double, ProgressData)();
        this.transcodingIdentifier = transcodingIdentifier;
        this.isSegmentedOutput = isSegmentedOutput;
    }

    override public void processEnded(bool success)
    {
        log.debug_(String_format("Transcoding finished; successful: %s", cast(Object[])[ Boolean.valueOf(success) ]));
        foreach (TranscodeInputStream stream ; this.processingStreams) {
            stream.setTranscodeFinished(true);
        }
        this.finished = true;
        this.successful = success;
    }

    override public void outputUpdated(String updatedLine)
    {
        if (!this.started)
        {
            if (updatedLine.startsWith("Press [q] to stop")) {
                this.started = true;
            }
        }
        else
        {
            int sizePos = updatedLine.indexOf("size=");
            if (sizePos > -1)
            {
                String sizeStr = updatedLine.substring(sizePos + 5);
                int timePos = sizeStr.indexOf("time=");
                int bitratePos = sizeStr.indexOf(" bitrate=");
                if ((timePos > -1) && (bitratePos > -1))
                {
                    String size = sizeStr.substring(0, timePos - 3).trim();
                    String time = sizeStr.substring(timePos + 5, bitratePos);
                    try
                    {
                        Double txTime = DateUtils.timeToSecondsPrecise(time);


                        String bitrateStr = sizeStr.substring(bitratePos + 9);
                        int unitPos = bitrateStr.indexOf("kbits/s");
                        if (unitPos > -1)
                        {
                            String bitrate = bitrateStr.substring(0, unitPos);
                            synchronized (this.timeFilesizeMap)
                            {
                                this.timeFilesizeMap.put(txTime, new ProgressData(Long.valueOf(Long.parseLong(size)), Float.valueOf(Float.parseFloat(bitrate))));
                            }
                        }
                    }
                    catch (NumberFormatException e)
                    {
                        log.debug_(String_format("Error updating FFmpeg output for line '%s': %s", cast(Object[])[ updatedLine, e.getMessage() ]));
                    }
                }
            }
        }
    }

    public void closeStream(Client client)
    {
        Iterator!(TranscodeInputStream) i = this.processingStreams.iterator();
        while (i.hasNext())
        {
            TranscodeInputStream tis = cast(TranscodeInputStream)i.next();
            if (tis.getClient().equals(client))
            {
                try
                {
                    tis.close();
                }
                catch (IOException e) {}
                i.remove();
            }
        }
    }

    public synchronized void releaseResources()
    {
        if (!this.shuttingDown)
        {
            this.shuttingDown = true;
            closeFFmpegConsumer();

            getExecutor().stopProcess(true);

            closeAllStreams();
            if (getTranscodedFile() !is null)
            {
                File fileToDelete = this.isSegmentedOutput ? getTranscodedFile().getParentFile() : getTranscodedFile();
                bool deleted = FileUtils.deleteFileOrFolder(fileToDelete);
                log.debug_(String_format("Deleted temp file '%s': %s", cast(Object[])[ fileToDelete, Boolean.valueOf(deleted) ]));
            }
        }
    }

    public String getTranscodingIdentifier()
    {
        return this.transcodingIdentifier;
    }

    public void addStream(TranscodeInputStream stream)
    {
        this.processingStreams.add(stream);
    }

    public bool isSuccessful()
    {
        return this.successful;
    }

    public TreeMap!(Double, ProgressData) getFilesizeMap()
    {
        return new TreeMap(this.timeFilesizeMap);
    }

    public File getTranscodedFile()
    {
        return this.transcodedFile;
    }

    public PipedInputStream getTranscodedStream()
    {
        return this.transcodedStream;
    }

    public void setTranscodedStream(PipedInputStream transcodedStream)
    {
        this.transcodedStream = transcodedStream;
    }

    public void setTranscodedFile(File transcodedFile)
    {
        this.transcodedFile = transcodedFile;
    }

    private void closeAllStreams()
    {
        Iterator!(TranscodeInputStream) i = this.processingStreams.iterator();
        while (i.hasNext())
        {
            TranscodeInputStream tis = cast(TranscodeInputStream)i.next();
            FileUtils.closeQuietly(cast(InputStream)tis);
            i.remove();
        }
    }

    private void closeFFmpegConsumer()
    {
        if (this.transcodedStream !is null) {
            FileUtils.closeQuietly(this.transcodedStream);
        }
    }

    public override hash_t toHash()
    {
        int prime = 31;
        int result = 1;
        result = 31 * result + (this.transcodingIdentifier is null ? 0 : this.transcodingIdentifier.hashCode());
        return result;
    }

    public override equals_t opEquals(Object obj)
    {
        if (this == obj) {
            return true;
        }
        if (obj is null) {
            return false;
        }
        if (getClass() != obj.getClass()) {
            return false;
        }
        TranscodingJobListener other = cast(TranscodingJobListener)obj;
        if (this.transcodingIdentifier is null)
        {
            if (other.transcodingIdentifier !is null) {
                return false;
            }
        }
        else if (!this.transcodingIdentifier.equals(other.transcodingIdentifier)) {
            return false;
        }
        return true;
    }
}

public class ProgressData
{
    private Long fileSize;
    private Float bitrate;

    public this(Long fileSize, Float bitrate)
    {
        this.fileSize = fileSize;
        this.bitrate = bitrate;
    }

    public Long getFileSize()
    {
        return this.fileSize;
    }

    public Float getBitrate()
    {
        return this.bitrate;
    }
}

/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.delivery.resource.transcode.TranscodingJobListener
* JD-Core Version:    0.7.0.1
*/