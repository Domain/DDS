module org.serviio.library.metadata.LibraryIndexingListener;

public abstract interface LibraryIndexingListener
{
  public abstract void itemAdded(MediaFileType paramMediaFileType, String paramString);
  
  public abstract void itemUpdated(MediaFileType paramMediaFileType, String paramString);
  
  public abstract void itemDeleted(MediaFileType paramMediaFileType, String paramString);
  
  public abstract void resetForAdding();
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.library.metadata.LibraryIndexingListener
 * JD-Core Version:    0.7.0.1
 */