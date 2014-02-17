module org.serviio.util.Tupple;

public class Tupple(T, S)
{
  private T valueA;
  private S valueB;
  
  public this(T valueA, S valueB)
  {
    this.valueA = valueA;
    this.valueB = valueB;
  }
  
  public T getValueA()
  {
    return this.valueA;
  }
  
  public void setValueA(T valueA)
  {
    this.valueA = valueA;
  }
  
  public S getValueB()
  {
    return this.valueB;
  }
  
  public void setValueB(S valueB)
  {
    this.valueB = valueB;
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.util.Tupple
 * JD-Core Version:    0.7.0.1
 */