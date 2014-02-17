module org.serviio.util.JsonUtils;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonArray;
import com.google.gson.JsonDeserializationContext;
import com.google.gson.JsonDeserializer;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonPrimitive;
import com.google.gson.JsonSyntaxException;
import java.lang.reflect.Type;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

public class JsonUtils
{
  public static Map!(String, Object) parseJson(String json)
  {
    GsonBuilder gsonBuilder = new GsonBuilder();
    gsonBuilder.registerTypeAdapter(Object.class_, new NaturalDeserializer(null));
    Gson gson = gsonBuilder.create();
    return cast(Map)gson.fromJson(json, Object.class_);
  }
  
  private static class NaturalDeserializer
    : JsonDeserializer!(Object)
  {
    public Object deserialize(JsonElement json, Type typeOfT, JsonDeserializationContext context)
    {
      if (json.isJsonNull()) {
        return null;
      }
      if (json.isJsonPrimitive()) {
        return handlePrimitive(json.getAsJsonPrimitive());
      }
      if (json.isJsonArray()) {
        return handleArray(json.getAsJsonArray(), context);
      }
      return handleObject(json.getAsJsonObject(), context);
    }
    
    private Object handlePrimitive(JsonPrimitive json)
    {
      if (json.isBoolean()) {
        return Boolean.valueOf(json.getAsBoolean());
      }
      if (json.isString()) {
        return json.getAsString();
      }
      bigDec = json.getAsBigDecimal();
      try
      {
        bigDec.toBigIntegerExact();
        try
        {
          return Integer.valueOf(bigDec.intValueExact());
        }
        catch (ArithmeticException e)
        {
          return Long.valueOf(bigDec.longValue());
        }
        return Double.valueOf(bigDec.doubleValue());
      }
      catch (ArithmeticException e) {}
    }
    
    private Object handleArray(JsonArray json, JsonDeserializationContext context)
    {
      List!(Object) array = new ArrayList(json.size());
      for (int i = 0; i < json.size(); i++) {
        array.add(deserialize(json.get(i), Object.class_, context));
      }
      return array;
    }
    
    private Object handleObject(JsonObject json, JsonDeserializationContext context)
    {
      Map!(String, Object) map = new HashMap();
      for (Map.Entry!(String, JsonElement) entry : json.entrySet()) {
        map.put(entry.getKey(), deserialize(cast(JsonElement)entry.getValue(), Object.class_, context));
      }
      return map;
    }
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.util.JsonUtils
 * JD-Core Version:    0.7.0.1
 */