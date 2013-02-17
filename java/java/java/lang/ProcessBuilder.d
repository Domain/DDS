module java.lang.ProcessBuilder;

import java.io.File;
import java.lang.String;
import java.lang.exceptions;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.lang.Process;

public final class ProcessBuilder
{
	private List!(String) cmd;
	private File dir;
	private Map!(String, String) env;
	private bool redirectErrorStream_;

	public this(List!(String) paramList)
	{
		if (paramList is null)
			throw new NullPointerException();
		this.cmd = paramList;
	}

	public this(String[] paramArrayOfString)
	{
		this.cmd = new ArrayList(paramArrayOfString.length);
		foreach (String str ; paramArrayOfString)
			this.cmd.add(str);
	}

	public ProcessBuilder command(List!(String) paramList)
	{
		if (paramList is null)
			throw new NullPointerException();
		this.cmd = paramList;
		return this;
	}

	public ProcessBuilder command(String[] paramArrayOfString)
	{
		this.cmd = new ArrayList(paramArrayOfString.length);
		foreach (String str ; paramArrayOfString)
			this.cmd.add(str);
		return this;
	}

	public List!(String) command()
	{
		return this.cmd;
	}

	public Map!(String, String) environment()
	{
		SecurityManager localSecurityManager = System.getSecurityManager();
		if (localSecurityManager !is null) {
			localSecurityManager.checkPermission(new RuntimePermission("getenv.*"));
		}
		if (this.env is null) {
			this.env = ProcessEnvironment.env();
		}
		assert (this.env !is null);

		return this.env;
	}

	ProcessBuilder environment(String[] paramArrayOfString)
	{
		assert (this.env is null);
		if (paramArrayOfString !is null) {
			this.env = ProcessEnvironment.emptyEnvironment(paramArrayOfString.length);
			assert (this.env !is null);

			foreach (String str ; paramArrayOfString)
			{
				if (str.indexOf(0) != -1) {
					str = str.replaceFirst("", "");
				}
				int k = str.indexOf('=', 1);

				if (k != -1) {
					this.env.put(str.substring(0, k), str.substring(k + 1));
				}
			}
		}
		return this;
	}

	public File directory()
	{
		return this.dir;
	}

	public ProcessBuilder directory(File paramFile)
	{
		this.dir = paramFile;
		return this;
	}

	public bool redirectErrorStream()
	{
		return this.redirectErrorStream_;
	}

	public ProcessBuilder redirectErrorStream(bool paramBoolean)
	{
		this.redirectErrorStream_ = paramBoolean;
		return this;
	}

	public Process start()
	{
		String[] arrayOfString = cast(String[])this.cmd.toArray(new String[this.cmd.size()]);
		arrayOfString = cast(String[])arrayOfString.clone();
		foreach (Object localObject2 ; arrayOfString) {
			if (localObject2 is null)
				throw new NullPointerException();
		}
		String name = arrayOfString[0];

		SecurityManager localSecurityManager = System.getSecurityManager();
		if (localSecurityManager !is null) {
			localSecurityManager.checkExec(name);
		}
		String str = this.dir is null ? null : this.dir.toString();
		try
		{
			return ProcessImpl.start(arrayOfString, this.env, str, this.redirectErrorStream_);
		}
		catch (IOException localIOException)
		{
			if (str is null) 
				tmpTernaryOp = ""; 
			throw new IOException("Cannot run program \"" ~ name ~ "\"" ~ (new StringBuilder()).append(" (in directory \"").append(str).append("\")").toString() ~ ": " ~ localIOException.getMessage(), localIOException);
		}
	}
}