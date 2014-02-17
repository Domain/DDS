module org.serviio.external.ProcessListener;

public abstract class ProcessListener
{
  private ProcessExecutor processExecutor;
  protected bool finished = false;
  
  public abstract void processEnded(bool paramBoolean);
  
  public abstract void outputUpdated(String paramString);
  
  public abstract void releaseResources();
  
  public ProcessExecutor getExecutor()
  {
    return this.processExecutor;
  }
  
  public void setExecutor(ProcessExecutor executor)
  {
    this.processExecutor = executor;
  }
  
  public bool isFinished()
  {
    return this.finished;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.external.ProcessListener
 * JD-Core Version:    0.7.0.1
 */