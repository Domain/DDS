module test.Test;

public class Test
{
    private /*static*/ void foo()
    {
    }

    public /*static*/ void foo(int i)
    {
    }
}

public interface ITest
{
    void foo();
    void foo(int);
}

public abstract class T : ITest
{
    public void bar()
    {
        foo();
    }

    public void foo(int i)
    {
    }
}

public class T2 : T
{
    public void foo()
    {
    }

    public void bar2()
    {
        foo(1);
    }
}
