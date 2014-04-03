module org.serviio.delivery.HttpResponseCodeException;

public class HttpResponseCodeException : Exception
{
    private static immutable long serialVersionUID = -8008193408723387271L;
    int httpCode;

    public this(int httpCode)
    {
        super("");
        this.httpCode = httpCode;
    }

    public int getHttpCode()
    {
        return this.httpCode;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.delivery.HttpResponseCodeException
* JD-Core Version:    0.7.0.1
*/