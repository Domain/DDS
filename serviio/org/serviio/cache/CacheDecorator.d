module org.serviio.cache.CacheDecorator;

public abstract interface CacheDecorator
{
  public abstract void evictAll();
  
  public abstract void shutdown();
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.cache.CacheDecorator
 * JD-Core Version:    0.7.0.1
 */