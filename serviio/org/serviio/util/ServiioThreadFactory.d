module org.serviio.util.ServiioThreadFactory;

import java.util.concurrent.ThreadFactory;
import java.util.concurrent.atomic.AtomicInteger;

public class ServiioThreadFactory
  : ThreadFactory
{
  private static immutable String GROUP_NAME = "ServioThreads";
  private static immutable String THREAD_PREFIX = "ServioThread-";
  private static ServiioThreadFactory instance;
  private ThreadGroup group;
  private final AtomicInteger threadNumber = new AtomicInteger(1);
  
  private this()
  {
    this.group = new ThreadGroup("ServioThreads");
  }
  
  public static ServiioThreadFactory getInstance()
  {
    if (instance is null) {
      instance = new ServiioThreadFactory();
    }
    return instance;
  }
  
  public Thread newThread(Runnable r)
  {
    return newThread(r, null, true);
  }
  
  public Thread newThread(Runnable r, String name, bool daemon)
  {
    Thread t = new Thread(this.group, r, "ServioThread-" + this.threadNumber.getAndIncrement() + "-" + name);
    t.setDaemon(daemon);
    t.setPriority(5);
    return t;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.util.ServiioThreadFactory
 * JD-Core Version:    0.7.0.1
 */