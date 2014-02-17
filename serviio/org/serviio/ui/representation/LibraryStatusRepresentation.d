module org.serviio.ui.representation.LibraryStatusRepresentation;

public class LibraryStatusRepresentation
{
  private bool libraryUpdatesCheckerRunning;
  private bool libraryAdditionsCheckerRunning;
  private String lastAddedFileName;
  private int numberOfAddedFiles = 0;
  
  public bool isLibraryUpdatesCheckerRunning()
  {
    return this.libraryUpdatesCheckerRunning;
  }
  
  public bool isLibraryAdditionsCheckerRunning()
  {
    return this.libraryAdditionsCheckerRunning;
  }
  
  public String getLastAddedFileName()
  {
    return this.lastAddedFileName;
  }
  
  public int getNumberOfAddedFiles()
  {
    return this.numberOfAddedFiles;
  }
  
  public void setLibraryUpdatesCheckerRunning(bool libraryUpdatesCheckerRunning)
  {
    this.libraryUpdatesCheckerRunning = libraryUpdatesCheckerRunning;
  }
  
  public void setLibraryAdditionsCheckerRunning(bool libraryAdditionsCheckerRunning)
  {
    this.libraryAdditionsCheckerRunning = libraryAdditionsCheckerRunning;
  }
  
  public void setLastAddedFileName(String lastAddedFileName)
  {
    this.lastAddedFileName = lastAddedFileName;
  }
  
  public void setNumberOfAddedFiles(int numberOfAddedFiles)
  {
    this.numberOfAddedFiles = numberOfAddedFiles;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.ui.representation.LibraryStatusRepresentation
 * JD-Core Version:    0.7.0.1
 */