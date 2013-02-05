module org.serviio.delivery.resource.transcode.ImageTranscodingDefinition;

import java.util.ArrayList;
import java.util.List;
import org.serviio.delivery.resource.transcode.AbstractTranscodingDefinition;
import org.serviio.delivery.resource.transcode.ImageTranscodingMatch;
import org.serviio.delivery.resource.transcode.TranscodingConfiguration;

public class ImageTranscodingDefinition : AbstractTranscodingDefinition
{
	private List!(ImageTranscodingMatch) matches;

	public this(TranscodingConfiguration parentConfig, bool forceInheritance)
	{
		matches = new ArrayList!(ImageTranscodingMatch)();
		super(parentConfig);
		this.forceInheritance = forceInheritance;
	}

	public List!(ImageTranscodingMatch) getMatches()
	{
		return matches;
	}
}

/* Location:           D:\Program Files\Serviio\lib\serviio.jar
* Qualified Name:     org.serviio.delivery.resource.transcode.ImageTranscodingDefinition
* JD-Core Version:    0.6.2
*/