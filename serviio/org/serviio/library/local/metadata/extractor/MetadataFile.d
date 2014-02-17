module org.serviio.library.local.metadata.extractor.MetadataFile;

import java.util.Date;

public class MetadataFile
{
  private ExtractorType extractorType;
  private Date lastUpdatedDate;
  private String identifier;
  private Object extractable;
  
  public this(ExtractorType extractorType, Date lastUpdatedDate, String identifier, Object extractable)
  {
    this.extractorType = extractorType;
    this.lastUpdatedDate = lastUpdatedDate;
    this.identifier = identifier;
    this.extractable = extractable;
  }
  
  public ExtractorType getExtractorType()
  {
    return this.extractorType;
  }
  
  public Date getLastUpdatedDate()
  {
    return this.lastUpdatedDate;
  }
  
  public String getIdentifier()
  {
    return this.identifier;
  }
  
  public Object getExtractable()
  {
    return this.extractable;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.library.local.metadata.extractor.MetadataFile
 * JD-Core Version:    0.7.0.1
 */