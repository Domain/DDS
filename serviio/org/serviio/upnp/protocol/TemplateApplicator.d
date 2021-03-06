module org.serviio.upnp.protocol.TemplateApplicator;

import freemarker.Template.Configuration;
import freemarker.Template.DefaultObjectWrapper;
import freemarker.Template.Template;
import freemarker.Template.TemplateException;
import java.lang.String;
import java.io.IOException;
import java.io.StringWriter;
import java.io.Writer;
import java.util.Map;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class TemplateApplicator
{
    private static Logger log;
    private static Configuration cfg;

    static this()
    {
        log = LoggerFactory.getLogger!(TemplateApplicator);
        cfg = new Configuration();
        try
        {
            cfg.setClassForTemplateLoading(TemplateApplicator.class_, "/");
            cfg.setObjectWrapper(new DefaultObjectWrapper());
            cfg.setOutputEncoding("UTF-8");
            cfg.setURLEscapingCharset(null);
        }
        catch (Exception e)
        {
            log.error("Cannot initialize Freemarker engine", e);
        }
    }

    public static String applyTemplate(String templateName, Map!(String, Object) parameters)
    {
        try
        {
            Template temp = cfg.getTemplate(templateName);
            Writer sw = new StringWriter();
            temp.process(parameters, sw);
            sw.flush();
            return sw.toString();
        }
        catch (IOException e)
        {
            log.error(java.lang.String.format("Cannot find template %s", cast(Object[])[ templateName ]), e);
            return null;
        }
        catch (TemplateException e)
        {
            log.error(java.lang.String.format("Error processing template %s: %s", cast(Object[])[ templateName, e.getMessage() ]), e);
        }
        return null;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.upnp.protocol.TemplateApplicator
* JD-Core Version:    0.7.0.1
*/