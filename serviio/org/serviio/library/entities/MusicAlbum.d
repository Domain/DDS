module org.serviio.library.entities.MusicAlbum;

import org.serviio.db.entities.PersistedEntity;

public class MusicAlbum
  : PersistedEntity
{
  public static final int TITLE_MAX_LENGTH = 256;
  private String title;
  private String sortTitle;
  
  public this(String title)
  {
    this.title = title;
  }
  
  public String getTitle()
  {
    return this.title;
  }
  
  public void setTitle(String title)
  {
    this.title = title;
  }
  
  public String getSortTitle()
  {
    return this.sortTitle;
  }
  
  public void setSortTitle(String sortTitle)
  {
    this.sortTitle = sortTitle;
  }
  
  public String toString()
  {
    return String.format("MusicAlbum [title=%s, sortTitle=%s]", cast(Object[])[ this.title, this.sortTitle ]);
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.library.entities.MusicAlbum
 * JD-Core Version:    0.7.0.1
 */