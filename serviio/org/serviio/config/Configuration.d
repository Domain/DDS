module org.serviio.config.Configuration;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map:Entry;
import org.serviio.ApplicationSettings;
import org.serviio.library.entities.AccessGroup;
import org.serviio.library.online.PreferredQuality;
import org.serviio.licensing.LicensingManager;
import org.serviio.profile.DeliveryQuality;
import org.serviio.profile.DeliveryQuality:QualityType;
import org.serviio.util.CollectionUtils;
import org.serviio.util.FileUtils;
import org.serviio.util.ObjectValidator;
import org.serviio.util.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class Configuration
{
    private static final Logger log = LoggerFactory.getLogger!(Configuration);
    private static immutable String DATABASE_UPDATE_ID = "db_update_id";
    private static immutable String SEARCH_HIDDEN_FILES = "search_hidden_files";
    private static immutable String SEARCH_FOR_UPDATED_FILES = "search_updated_files";
    private static immutable String RETRIEVE_ART_FROM_ONLINE_SOURCES = "retireve_art_from_online_sources";
    private static immutable String BOUND_NIC_NAME = "bound_nic_name";
    private static immutable String TRANSCODING_ENABLED = "transcoding_enabled";
    private static immutable String TRANSCODING_FOLDER = "transcoding_folder";
    private static immutable String TRANSCODING_THREADS = "transcoding_threads";
    private static immutable String TRANSCODING_DOWNMIX_TO_STEREO = "transcoding_downmix_to_stereo";
    private static immutable String TRANSCODING_BEST_QUALITY = "transcoding_best_quality";
    private static immutable String REPOSITORY_AUTOMATIC_CHECK = "repository_automatic_check";
    private static immutable String REPOSITORY_AUTOMATIC_CHECK_INTERVAL = "repository_automatic_check_interval";
    private static immutable String METADATA_GENERATE_LOCAL_THUMBNAIL_VIDEO = "metadata_generate_local_thumbnail";
    private static immutable String METADATA_GENERATE_LOCAL_THUMBNAIL_IMAGE = "metadata_generate_local_thumbnail_image";
    private static immutable String METADATA_PREFERRED_LANGUAGE = "metadata_preferred_language";
    private static immutable String METADATA_USE_ORIGINAL_TITLE = "metadata_use_original_title";
    private static immutable String BROWSE_MENU_ITEM_OPTIONS = "browse_menu_item_options";
    private static immutable String BROWSE_MENU_SHOW_CATEGORY_NAME_IF_TRANSPARENT = "browse_menu_show_parent";
    private static immutable String BROWSE_MENU_PREFERRED_LANGUAGE = "browse_menu_preferred_language";
    private static immutable String CONSOLE_PREFERRED_LANGUAGE = "console_preferred_language";
    private static immutable String ONLINE_FEED_MAX_NUMBER_OF_ITEMS = "online_feed_max_num_items";
    private static immutable String ONLINE_FEED_EXPIRY_INTERVAL = "online_feed_expiry_interval";
    private static immutable String ONLINE_FEED_PREFERRED_QUALITY = "online_feed_prefered_quality";
    private static immutable String CUSTOMER_LICENSE = "customer_license";
    private static immutable String WEB_PASSWORD = "web_password";
    private static immutable String REMOTE_PREFERRED_DELIVERY_QUALITY = "remote_preferred_quality";
    private static immutable String REMOTE_ENABLE_PORT_FORWARDING = "enable_port_forwarding";
    private static immutable String REMOTE_EXTERNAL_ADDRESS = "remote_external_address";
    private static immutable String CONSOLE_SECURITY_PIN = "console_security_pin";
    private static immutable String CONSOLE_CHECK_FOR_UPDATES = "console_check_for_updates";
    private static immutable String BROWSE_MENU_DYNAMIC_CATEGORIES_NUMBER = "browse_menu_dyn_cat_number";
    private static immutable String SUBTITLES_PREFERRED_LANGUAGE = "subtitles_preferred_language";
    private static immutable String SUBTITLES_ENABLED = "subtitles_enabled";
    private static immutable String SUBTITLES_HARDSUBS_ENABLED = "subtitles_hardsubs_enabled";
    private static immutable String SUBTITLES_HARDSUBS_FORCE = "subtitles_hardsubs_force";
    private static immutable String SUBTITLES_EXTRACT_EMBEDDED = "subtitles_extract_embedded";
    private static immutable String SUBTITLES_HARDSUBS_CHARENC = "subtitles_character_encoding";
    private static immutable String RENDERER_ENABLED_BY_DEFAULT = "renderer_enabled_default";
    private static immutable String RENDERER_DEFAULT_ACCESS_GROUP_ID = "renderer_default_access_group_id";
    private static immutable String BROWSE_FILTER_OUT_SERIES = "browse_filter_out_series";
    private static Map!(String, String) cache = new HashMap();
    private static ConfigStorage storage;

    static this()
    {
        instantiateStorage();


        Map!(String, String) currentValues = storage.readAllConfigurationValues();
        foreach (Map.Entry!(String, String) configEntry ; currentValues.entrySet()) {
            cache.put(configEntry.getKey(), configEntry.getValue());
        }
    }

    public static bool isSearchHiddenFiles()
    {
        String value = cast(String)cache.get("search_hidden_files");
        if (ObjectValidator.isNotEmpty(value)) {
            return Boolean.valueOf(value).boolValue();
        }
        return false;
    }

    public static void setSearchHiddenFiles(bool search)
    {
        storeConfigValue("search_hidden_files", Boolean.toString(search));
    }

    public static bool isSearchUpdatedFiles()
    {
        String value = cast(String)cache.get("search_updated_files");
        if (ObjectValidator.isNotEmpty(value)) {
            return Boolean.valueOf(value).boolValue();
        }
        return true;
    }

    public static void setSearchUpdatedFiles(bool search)
    {
        storeConfigValue("search_updated_files", Boolean.toString(search));
    }

    public static bool isRetrieveArtFromOnlineSources()
    {
        String value = cast(String)cache.get("retireve_art_from_online_sources");
        if (ObjectValidator.isNotEmpty(value)) {
            return Boolean.valueOf(value).boolValue();
        }
        return true;
    }

    public static void setRetrieveArtFromOnlineSources(bool retrieve)
    {
        storeConfigValue("retireve_art_from_online_sources", Boolean.toString(retrieve));
    }

    public static String getBoundNICName()
    {
        String value = cast(String)cache.get("bound_nic_name");
        if (ObjectValidator.isNotEmpty(value)) {
            return value;
        }
        return null;
    }

    public static void setBoundNICName(String name)
    {
        if (ObjectValidator.isEmpty(name)) {
            storeConfigValue("bound_nic_name", "");
        } else {
            storeConfigValue("bound_nic_name", name);
        }
    }

    public static bool isTranscodingEnabled()
    {
        String value = cast(String)cache.get("transcoding_enabled");
        if (ObjectValidator.isNotEmpty(value)) {
            return Boolean.valueOf(value).boolValue();
        }
        return true;
    }

    public static void setTranscodingEnabled(bool transcode)
    {
        storeConfigValue("transcoding_enabled", Boolean.toString(transcode));
    }

    public static String getTranscodingFolder()
    {
        String value = cast(String)cache.get("transcoding_folder");
        if (ObjectValidator.isNotEmpty(value)) {
            return value;
        }
        String defaultTranscodeLocation = System.getProperty("serviio.defaultTranscodeFolder");
        if ((defaultTranscodeLocation !is null) && (FileUtils.fileExists(defaultTranscodeLocation))) {
            return defaultTranscodeLocation;
        }
        return System.getProperty("java.io.tmpdir");
    }

    public static void setTranscodingFolder(String folder)
    {
        if (ObjectValidator.isEmpty(folder)) {
            storeConfigValue("transcoding_folder", System.getProperty("java.io.tmpdir"));
        } else {
            storeConfigValue("transcoding_folder", folder);
        }
    }

    public static String getTranscodingThreads()
    {
        String value = cast(String)cache.get("transcoding_threads");
        if (ObjectValidator.isNotEmpty(value)) {
            return value;
        }
        return "auto";
    }

    public static void setTranscodingThreads(Integer threads)
    {
        if (threads is null) {
            storeConfigValue("transcoding_threads", "auto");
        } else {
            storeConfigValue("transcoding_threads", threads.toString());
        }
    }

    public static bool isTranscodingDownmixToStereo()
    {
        String value = cast(String)cache.get("transcoding_downmix_to_stereo");
        if (ObjectValidator.isNotEmpty(value)) {
            return Boolean.valueOf(value).boolValue();
        }
        return true;
    }

    public static void setTranscodingDownmixToStereo(bool retrieve)
    {
        storeConfigValue("transcoding_downmix_to_stereo", Boolean.toString(retrieve));
    }

    public static bool isTranscodingBestQuality()
    {
        String value = cast(String)cache.get("transcoding_best_quality");
        if (ObjectValidator.isNotEmpty(value)) {
            return Boolean.valueOf(value).boolValue();
        }
        return true;
    }

    public static void setTranscodingBestQuality(bool bestQuality)
    {
        storeConfigValue("transcoding_best_quality", Boolean.toString(bestQuality));
    }

    public static bool isAutomaticLibraryRefresh()
    {
        String value = cast(String)cache.get("repository_automatic_check");
        if (ObjectValidator.isNotEmpty(value)) {
            return Boolean.valueOf(value).boolValue();
        }
        return true;
    }

    public static void setAutomaticLibraryRefresh(bool autoRefresh)
    {
        storeConfigValue("repository_automatic_check", Boolean.toString(autoRefresh));
    }

    public static Integer getAutomaticLibraryRefreshInterval()
    {
        String value = cast(String)cache.get("repository_automatic_check_interval");
        if (ObjectValidator.isNotEmpty(value)) {
            return Integer.valueOf(Integer.parseInt(value));
        }
        return Integer.valueOf(5);
    }

    public static void setAutomaticLibraryRefreshInterval(Integer minutes)
    {
        if ((minutes is null) || (minutes.intValue() <= 0)) {
            storeConfigValue("repository_automatic_check_interval", "5");
        } else {
            storeConfigValue("repository_automatic_check_interval", minutes.toString());
        }
    }

    public static bool isGenerateLocalThumbnailForVideos()
    {
        String value = cast(String)cache.get("metadata_generate_local_thumbnail");
        if (ObjectValidator.isNotEmpty(value)) {
            return Boolean.valueOf(value).boolValue();
        }
        return true;
    }

    public static void setGenerateLocalThumbnailForVideos(bool generate)
    {
        storeConfigValue("metadata_generate_local_thumbnail", Boolean.toString(generate));
    }

    public static bool isGenerateLocalThumbnailForImages()
    {
        String value = cast(String)cache.get("metadata_generate_local_thumbnail_image");
        if (ObjectValidator.isNotEmpty(value)) {
            return Boolean.valueOf(value).boolValue();
        }
        return true;
    }

    public static void setGenerateLocalThumbnailForImages(bool generate)
    {
        storeConfigValue("metadata_generate_local_thumbnail_image", Boolean.toString(generate));
    }

    public static String getMetadataPreferredLanguage()
    {
        String value = cast(String)cache.get("metadata_preferred_language");
        if (ObjectValidator.isNotEmpty(value)) {
            return value;
        }
        return "en";
    }

    public static void setMetadataPreferredLanguage(String languageCode)
    {
        if (ObjectValidator.isEmpty(languageCode)) {
            storeConfigValue("metadata_preferred_language", "en");
        } else {
            storeConfigValue("metadata_preferred_language", languageCode);
        }
    }

    public static bool isMetadataUseOriginalTitle()
    {
        String value = cast(String)cache.get("metadata_use_original_title");
        if (ObjectValidator.isNotEmpty(value)) {
            return Boolean.valueOf(value).boolValue();
        }
        return false;
    }

    public static void setMetadataUseOriginalTitle(bool useOriginalTitle)
    {
        storeConfigValue("metadata_use_original_title", Boolean.toString(useOriginalTitle));
    }

    public static Map!(String, String) getBrowseMenuItemOptions()
    {
        String value = cast(String)cache.get("browse_menu_item_options");
        if (ObjectValidator.isNotEmpty(value)) {
            return CollectionUtils.CSVToMap(value, ",");
        }
        return Collections.emptyMap();
    }

    public static void setBrowseMenuItemOptions(Map!(String, String) itemsMap)
    {
        if (itemsMap !is null) {
            storeConfigValue("browse_menu_item_options", CollectionUtils.mapToCSV(itemsMap, ",", true));
        } else {
            storeConfigValue("browse_menu_item_options", "");
        }
    }

    public static String getBrowseMenuPreferredLanguage()
    {
        String value = cast(String)cache.get("browse_menu_preferred_language");
        if (ObjectValidator.isNotEmpty(value)) {
            return value;
        }
        return "en";
    }

    public static void setBrowseMenuPreferredLanguage(String languageCode)
    {
        if (ObjectValidator.isEmpty(languageCode)) {
            storeConfigValue("browse_menu_preferred_language", "en");
        } else {
            storeConfigValue("browse_menu_preferred_language", languageCode);
        }
    }

    public static void setBrowseMenuShowNameOfParentCategory(bool showTitle)
    {
        storeConfigValue("browse_menu_show_parent", Boolean.toString(showTitle));
    }

    public static bool isBrowseMenuShowNameOfParentCategory()
    {
        String value = cast(String)cache.get("browse_menu_show_parent");
        if (ObjectValidator.isNotEmpty(value)) {
            return Boolean.valueOf(value).boolValue();
        }
        return true;
    }

    public static String getConsolePreferredLanguage()
    {
        String value = cast(String)cache.get("console_preferred_language");
        if (ObjectValidator.isNotEmpty(value)) {
            return value;
        }
        return null;
    }

    public static void setConsolePreferredLanguage(String languageCode)
    {
        if (ObjectValidator.isEmpty(languageCode)) {
            storeConfigValue("console_preferred_language", "");
        } else {
            storeConfigValue("console_preferred_language", languageCode);
        }
    }

    public static Integer getMaxNumberOfItemsForOnlineFeeds()
    {
        String value = cast(String)cache.get("online_feed_max_num_items");
        if (ObjectValidator.isNotEmpty(value)) {
            return Integer.valueOf(Integer.parseInt(value));
        }
        return Integer.valueOf(20);
    }

    public static void setMaxNumberOfItemsForOnlineFeeds(Integer number)
    {
        if (number is null) {
            storeConfigValue("online_feed_max_num_items", "20");
        } else {
            storeConfigValue("online_feed_max_num_items", number.toString());
        }
    }

    public static Integer getOnlineFeedExpiryInterval()
    {
        String value = cast(String)cache.get("online_feed_expiry_interval");
        if (ObjectValidator.isNotEmpty(value)) {
            return Integer.valueOf(Integer.parseInt(value));
        }
        return Integer.valueOf(24);
    }

    public static void setOnlineFeedExpiryInterval(Integer hours)
    {
        if ((hours is null) || (hours.intValue() <= 0)) {
            storeConfigValue("online_feed_expiry_interval", "24");
        } else {
            storeConfigValue("online_feed_expiry_interval", hours.toString());
        }
    }

    public static PreferredQuality getOnlineFeedPreferredQuality()
    {
        String value = cast(String)cache.get("online_feed_prefered_quality");
        if (ObjectValidator.isNotEmpty(value)) {
            return PreferredQuality.valueOf(value);
        }
        return PreferredQuality.MEDIUM;
    }

    public static void setOnlineFeedPreferredQuality(PreferredQuality quality)
    {
        storeConfigValue("online_feed_prefered_quality", quality.toString());
    }

    public static String getCustomerLicense()
    {
        String value = cast(String)cache.get("customer_license");
        if (ObjectValidator.isNotEmpty(value)) {
            return value;
        }
        return null;
    }

    public static void setCustomerLicense(String licenseBody)
    {
        if (ObjectValidator.isEmpty(licenseBody)) {
            storeConfigValue("customer_license", "");
        } else {
            storeConfigValue("customer_license", licenseBody);
        }
    }

    public static String getWebPassword()
    {
        String value = cast(String)cache.get("web_password");
        if (ObjectValidator.isNotEmpty(value)) {
            return value;
        }
        return null;
    }

    public static void setWebPassword(String password)
    {
        if (ObjectValidator.isEmpty(password)) {
            storeConfigValue("web_password", "");
        } else {
            storeConfigValue("web_password", password);
        }
    }

    public static String getConsoleSecurityPin()
    {
        String value = cast(String)cache.get("console_security_pin");
        if (ObjectValidator.isNotEmpty(value)) {
            return value;
        }
        return null;
    }

    public static void setConsoleSecurityPin(String password)
    {
        if (ObjectValidator.isEmpty(password)) {
            storeConfigValue("console_security_pin", "");
        } else {
            storeConfigValue("console_security_pin", password);
        }
    }

    public static DeliveryQuality.QualityType getRemotePreferredDeliveryQuality()
    {
        String value = cast(String)cache.get("remote_preferred_quality");
        if (ObjectValidator.isNotEmpty(value)) {
            return DeliveryQuality.QualityType.valueOf(value);
        }
        return DeliveryQuality.QualityType.MEDIUM;
    }

    public static bool isRemotePortForwardingEnabled()
    {
        String value = cast(String)cache.get("enable_port_forwarding");
        if (ObjectValidator.isNotEmpty(value)) {
            return Boolean.valueOf(value).boolValue();
        }
        return false;
    }

    public static void setRemotePortForwardingEnabled(bool enable)
    {
        storeConfigValue("enable_port_forwarding", Boolean.toString(enable));
    }

    public static void setRemotePreferredDeliveryQuality(DeliveryQuality.QualityType quality)
    {
        storeConfigValue("remote_preferred_quality", quality.toString());
    }

    public static String getRemoteExternalAddress()
    {
        String value = cast(String)cache.get("remote_external_address");
        if (ObjectValidator.isNotEmpty(value)) {
            return value;
        }
        return null;
    }

    public static void setRemoteExternalAddress(String address)
    {
        if (ObjectValidator.isEmpty(address)) {
            storeConfigValue("remote_external_address", "");
        } else {
            storeConfigValue("remote_external_address", address);
        }
    }

    public static bool isConsoleCheckForUpdatesEnabled()
    {
        String value = cast(String)cache.get("console_check_for_updates");
        if (ObjectValidator.isNotEmpty(value)) {
            return Boolean.valueOf(value).boolValue();
        }
        return true;
    }

    public static void setConsoleCheckForUpdatesEnabled(bool check)
    {
        storeConfigValue("console_check_for_updates", Boolean.toString(check));
    }

    public static Integer getNumberOfFilesForDynamicCategories()
    {
        String value = cast(String)cache.get("browse_menu_dyn_cat_number");
        if (ObjectValidator.isNotEmpty(value)) {
            return Integer.valueOf(Integer.parseInt(value));
        }
        return Integer.valueOf(10);
    }

    public static void setNumberOfFilesForDynamicCategories(Integer number)
    {
        if ((number is null) || (number.intValue() <= 0)) {
            storeConfigValue("browse_menu_dyn_cat_number", "10");
        } else {
            storeConfigValue("browse_menu_dyn_cat_number", number.toString());
        }
    }

    public static List!(String) getSubtitlesPreferredLanguages()
    {
        String value = cast(String)cache.get("subtitles_preferred_language");
        return CollectionUtils.csvToList(value, ",", true);
    }

    public static void setSubtitlesPreferredLanguages(List!(String) languageCodes)
    {
        if ((languageCodes is null) || (languageCodes.size() == 0)) {
            storeConfigValue("subtitles_preferred_language", "");
        } else {
            storeConfigValue("subtitles_preferred_language", CollectionUtils.listToCSV(languageCodes, ",", true));
        }
    }

    public static bool isSubtitlesEnabled()
    {
        String value = cast(String)cache.get("subtitles_enabled");
        if (ObjectValidator.isNotEmpty(value)) {
            return Boolean.valueOf(value).boolValue();
        }
        return true;
    }

    public static void setSubtitlesEnabled(bool enabled)
    {
        storeConfigValue("subtitles_enabled", Boolean.toString(enabled));
    }

    public static bool isHardSubsEnabled()
    {
        String value = cast(String)cache.get("subtitles_hardsubs_enabled");
        if (ObjectValidator.isNotEmpty(value)) {
            return Boolean.valueOf(value).boolValue();
        }
        return false;
    }

    public static void setHardSubsEnabled(bool enabled)
    {
        storeConfigValue("subtitles_hardsubs_enabled", Boolean.toString(enabled));
    }

    public static bool isHardSubsForced()
    {
        String value = cast(String)cache.get("subtitles_hardsubs_force");
        if (ObjectValidator.isNotEmpty(value)) {
            return Boolean.valueOf(value).boolValue();
        }
        return false;
    }

    public static void setHardSubsForced(bool enabled)
    {
        storeConfigValue("subtitles_hardsubs_force", Boolean.toString(enabled));
    }

    public static bool isEmbeddedSubtitlesExtracted()
    {
        String value = cast(String)cache.get("subtitles_extract_embedded");
        if (ObjectValidator.isNotEmpty(value)) {
            return Boolean.valueOf(value).boolValue();
        }
        return false;
    }

    public static void setEmbeddedSubtitlesExtracted(bool enabled)
    {
        storeConfigValue("subtitles_extract_embedded", Boolean.toString(enabled));
    }

    public static String getSubsCharacterEncoding()
    {
        String value = cast(String)cache.get("subtitles_character_encoding");
        if (ObjectValidator.isNotEmpty(value)) {
            return value;
        }
        return "UTF-8";
    }

    public static void setSubsCharacterEncoding(String enc)
    {
        storeConfigValue("subtitles_character_encoding", enc);
    }

    public static String getDatabaseUpdateId()
    {
        String value = cast(String)cache.get("db_update_id");
        if (ObjectValidator.isNotEmpty(value)) {
            return value;
        }
        String token = StringUtils.generateRandomToken();
        setDatabaseUpdateId(token);
        return token;
    }

    public static void setDatabaseUpdateId(String token)
    {
        storeConfigValue("db_update_id", token);
    }

    public static bool isRendererEnabledByDefault()
    {
        String value = cast(String)cache.get("renderer_enabled_default");
        if (ObjectValidator.isNotEmpty(value)) {
            return Boolean.valueOf(value).boolValue();
        }
        return true;
    }

    public static void setRendererEnabledByDefault(bool enabled)
    {
        storeConfigValue("renderer_enabled_default", Boolean.toString(enabled));
    }

    public static Long getRendererDefaultAccessGroupId()
    {
        if (LicensingManager.getInstance().isProVersion())
        {
            String value = cast(String)cache.get("renderer_default_access_group_id");
            if (ObjectValidator.isNotEmpty(value)) {
                return new Long(value);
            }
            return AccessGroup.NO_LIMIT_ACCESS_GROUP_ID;
        }
        return AccessGroup.NO_LIMIT_ACCESS_GROUP_ID;
    }

    public static void setRendererDefaultAccessGroupId(Long id)
    {
        storeConfigValue("renderer_default_access_group_id", id !is null ? id.toString() : "");
    }

    public static bool isBrowseFilterOutSeries()
    {
        String value = cast(String)cache.get("browse_filter_out_series");
        if (ObjectValidator.isNotEmpty(value)) {
            return Boolean.valueOf(value).boolValue();
        }
        return false;
    }

    public static void setBrowseFilterOutSeries(bool filter)
    {
        storeConfigValue("browse_filter_out_series", Boolean.toString(filter));
    }

    private static void storeConfigValue(String configEntryName, String value)
    {
        cache.put(configEntryName, value);
        storage.storeValue(configEntryName, value);
    }

    private static void instantiateStorage()
    {
        try
        {
            Class/*!(?)*/ storageClass = Class.forName(ApplicationSettings.getStringProperty("configuration_storage_class"));
            storage = cast(ConfigStorage)storageClass.newInstance();
        }
        catch (ClassNotFoundException e)
        {
            log.error(String.format("Cannot instantiate Profile. Message: %s", cast(Object[])[ e.getMessage() ]));
        }
        catch (InstantiationException e)
        {
            log.error(String.format("Cannot instantiate Profile. Message: %s", cast(Object[])[ e.getMessage() ]));
        }
        catch (IllegalAccessException e)
        {
            log.error(String.format("Cannot instantiate Profile. Message: %s", cast(Object[])[ e.getMessage() ]));
        }
    }
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.config.Configuration
* JD-Core Version:    0.7.0.1
*/