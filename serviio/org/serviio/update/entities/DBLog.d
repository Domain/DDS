module org.serviio.update.entities.DBLog;

import org.serviio.db.entities.PersistedEntity;

public class DBLog
  : PersistedEntity
{
  private Integer versionMajor;
  private Integer versionMinor;
  private String scriptFile;
  
  public this(Integer versionMajor, Integer versionMinor, String scriptFile)
  {
    this.versionMajor = versionMajor;
    this.versionMinor = versionMinor;
    this.scriptFile = scriptFile;
  }
  
  public Integer getVersionMajor()
  {
    return this.versionMajor;
  }
  
  public void setVersionMajor(Integer versionMajor)
  {
    this.versionMajor = versionMajor;
  }
  
  public Integer getVersionMinor()
  {
    return this.versionMinor;
  }
  
  public void setVersionMinor(Integer versionMinor)
  {
    this.versionMinor = versionMinor;
  }
  
  public String getScriptFile()
  {
    return this.scriptFile;
  }
  
  public void setScriptFile(String scriptFile)
  {
    this.scriptFile = scriptFile;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.update.entities.DBLog
 * JD-Core Version:    0.7.0.1
 */