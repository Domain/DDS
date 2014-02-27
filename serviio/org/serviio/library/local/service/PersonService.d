module org.serviio.library.local.service.PersonService;

import java.util.List;
import org.serviio.db.dao.DAOFactory;
import org.serviio.library.dao.PersonDAO;
import org.serviio.library.entities.Person;
import org.serviio.library.entities.Person:RoleType;
import org.serviio.library.service.Service;

public class PersonService
  : Service
{
  public static Person getPerson(Long personId)
  {
    return DAOFactory.getPersonDAO().findPersonById(personId);
  }
  
  public static List!(Person) getListOfPersons(Person.RoleType role, int startingIndex, int requestedCount)
  {
    return DAOFactory.getPersonDAO().retrievePersonsWithRole(role, startingIndex, requestedCount);
  }
  
  public static int getNumberOfPersons(Person.RoleType role)
  {
    return DAOFactory.getPersonDAO().getPersonsWithRoleCount(role);
  }
  
  public static List!(Person) getListOfPersonsForMediaItem(Long mediaItemId, Person.RoleType roleType)
  {
    return DAOFactory.getPersonDAO().retrievePersonsWithRoleForMediaItem(roleType, mediaItemId);
  }
  
  public static List!(Person) getListOfPersonsForMusicAlbum(Long albumId, Person.RoleType roleType)
  {
    return DAOFactory.getPersonDAO().retrievePersonsWithRoleForMusicAlbum(roleType, albumId);
  }
  
  public static List!(String) getListOfPersonInitials(Person.RoleType role, int startingIndex, int requestedCount)
  {
    return DAOFactory.getPersonDAO().retrievePersonInitials(role, startingIndex, requestedCount);
  }
  
  public static int getNumberOfPersonInitials(Person.RoleType role)
  {
    return DAOFactory.getPersonDAO().retrievePersonInitialsCount(role);
  }
  
  public static List!(Person) getListOfPersonsForInitial(String initial, Person.RoleType role, int startingIndex, int requestedCount)
  {
    return DAOFactory.getPersonDAO().retrievePersonsForInitial(initial, role, startingIndex, requestedCount);
  }
  
  public static int getNumberOfPersonsForInitial(String initial, Person.RoleType role)
  {
    return DAOFactory.getPersonDAO().retrievePersonsForInitialCount(initial, role);
  }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
 * Qualified Name:     org.serviio.library.local.service.PersonService
 * JD-Core Version:    0.7.0.1
 */