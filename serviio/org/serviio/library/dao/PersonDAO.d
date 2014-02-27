module org.serviio.library.dao.PersonDAO;

import java.util.List;
import org.serviio.library.entities.Person;
import org.serviio.library.entities.Person:RoleType;

public abstract interface PersonDAO
{
    public abstract Person findPersonByName(String paramString);

    public abstract Person findPersonById(Long paramLong);

    public abstract Long addPersonToMedia(String paramString, Person.RoleType paramRoleType, Long paramLong);

    public abstract Long addPersonToMusicAlbum(String paramString, Person.RoleType paramRoleType, Long paramLong);

    public abstract void removeAllPersonsFromMedia(Long paramLong);

    public abstract List!(Long) removeAllPersonsFromMusicAlbum(Long paramLong);

    public abstract void removePersonsAndRoles(List!(Long) paramList);

    public abstract List!(Person) retrievePersonsWithRole(Person.RoleType paramRoleType, int paramInt1, int paramInt2);

    public abstract int getPersonsWithRoleCount(Person.RoleType paramRoleType);

    public abstract int getRoleForPersonCount(Long paramLong);

    public abstract List!(Person) retrievePersonsWithRoleForMediaItem(Person.RoleType paramRoleType, Long paramLong);

    public abstract List!(Person) retrievePersonsWithRoleForMusicAlbum(Person.RoleType paramRoleType, Long paramLong);

    public abstract List!(Person) retrievePersonsForMediaItem(Long paramLong);

    public abstract List!(Person) retrievePersonsForMusicAlbum(Long paramLong);

    public abstract Long getPersonRoleForMediaItem(Person.RoleType paramRoleType, Long paramLong1, Long paramLong2);

    public abstract Long getPersonRoleForMusicAlbum(Person.RoleType paramRoleType, Long paramLong1, Long paramLong2);

    public abstract List!(Long) getRoleIDsForMediaItem(Person.RoleType paramRoleType, Long paramLong);

    public abstract List!(String) retrievePersonInitials(Person.RoleType paramRoleType, int paramInt1, int paramInt2);

    public abstract int retrievePersonInitialsCount(Person.RoleType paramRoleType);

    public abstract List!(Person) retrievePersonsForInitial(String paramString, Person.RoleType paramRoleType, int paramInt1, int paramInt2);

    public abstract int retrievePersonsForInitialCount(String paramString, Person.RoleType paramRoleType);
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.dao.PersonDAO
* JD-Core Version:    0.7.0.1
*/