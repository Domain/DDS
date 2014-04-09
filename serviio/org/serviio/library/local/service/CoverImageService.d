module org.serviio.library.local.service.CoverImageService;

import java.lang;
import org.serviio.db.dao.DAOFactory;
import org.serviio.library.dao.CoverImageDAO;
import org.serviio.library.entities.CoverImage;
import org.serviio.library.local.metadata.ImageDescriptor;
import org.serviio.library.metadata.MediaFileType;
import org.serviio.library.service.Service;
import org.serviio.util.ImageUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class CoverImageService : Service
{
    private static Logger log;
    public static immutable int HD_THUMNAIL_WIDTH_MAX = 320;
    public static immutable int HD_THUMNAIL_HEIGHT_MAX = 320;

    static this()
    {
        log = LoggerFactory.getLogger!(CoverImageService);
    }

    public static Long createCoverImage(ImageDescriptor image, Integer rotation)
    {
        CoverImage coverImage = prepareCoverImage(image, rotation);
        if (coverImage !is null) {
            return Long.valueOf(DAOFactory.getCoverImageDAO().create(coverImage));
        }
        return null;
    }

    public static CoverImage prepareCoverImage(ImageDescriptor image, Integer requiredRotation)
    {
        if (image !is null) {
            try
            {
                ImageDescriptor hdThumbnail = prepareCoverImageThumbnail(image.getImageData(), requiredRotation, 320, 320);

                ImageDescriptor dlnaThumbnail = prepareCoverImageThumbnail(hdThumbnail.getImageData(), null, 160, 160);
                return new CoverImage(dlnaThumbnail.getImageData(), "image/jpeg", dlnaThumbnail.getWidth().intValue(), dlnaThumbnail.getHeight().intValue(), hdThumbnail.getImageData(), hdThumbnail.getWidth().intValue(), hdThumbnail.getHeight().intValue());
            }
            catch (Throwable e)
            {
                log.warn(java.lang.String.format("Cannot convert/resize art to JPG. Message: %s", cast(Object[])[ e.getMessage() ]));
                return null;
            }
        }
        return null;
    }

    public static Long getMusicAlbumCoverArt(Long albumId)
    {
        return DAOFactory.getCoverImageDAO().getCoverImageForMusicAlbum(albumId);
    }

    public static Long getFolderCoverArt(Long folderId, MediaFileType fileType)
    {
        return DAOFactory.getCoverImageDAO().getCoverImageForFolder(folderId, fileType);
    }

    public static Long getPersonCoverArt(Long personId)
    {
        return DAOFactory.getCoverImageDAO().getCover = LoggerFactory.getLogger!(CoverImageService);ImageForPerson(personId);
    }

    public static Long getRepositoryCoverArt(Long repositoryId, MediaFileType fileType)
    {
        return DAOFactory.getCoverImageDAO().getCoverImageForRepository(repositoryId, fileType);
    }

    public static void removeCoverImage(Long coverImageId)
    {
        if (coverImageId !is null) {
            DAOFactory.getCoverImageDAO().delete_(coverImageId);
        }
    }

    private static ImageDescriptor prepareCoverImageThumbnail(byte[] imagedata, Integer requiredRotation, int maxWidth, int maxHeight)
    {
        if ((imagedata !is null) && (imagedata.length > 0)) {
            try
            {
                log.debug_(java.lang.String.format("Resizing and storing cover art image for max resolution of %sx%s", cast(Object[])[ Integer.valueOf(maxWidth), Integer.valueOf(maxHeight) ]));
                ImageDescriptor resizedImage = ImageUtils.resizeImageAsJPG(imagedata, maxWidth, maxHeight);
                log.debug_("Image successfully resized");
                if ((requiredRotation !is null) && (!requiredRotation.opEquals(new Integer(0)))) {
                    log.debug_(java.lang.String.format("Rotating thumbnail image (%s)", cast(Object[])[ requiredRotation ]));
                }
                return ImageUtils.rotateImage(resizedImage.getImageData(), requiredRotation.intValue());
            }
            catch (Throwable e)
            {
                log.warn(java.lang.String.format("Cannot convert/resize art to JPG. Message: %s", cast(Object[])[ e.getMessage() ]));
                return null;
            }
        }
        return null;
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.library.local.service.CoverImageService
* JD-Core Version:    0.7.0.1
*/