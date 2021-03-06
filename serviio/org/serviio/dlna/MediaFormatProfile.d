module org.serviio.dlna.MediaFormatProfile;

import java.lang.util;
import java.util.Arrays;
import java.util.List;
import org.serviio.library.metadata.MediaFileType;

public enum MediaFormatProfile// : MediaFileType
{
    MP3,
    MP2_MPS,
    WMA_BASE,
    WMA_FULL,
    LPCM16_44_MONO,
    LPCM16_44_STEREO,
    LPCM16_48_MONO,
    LPCM16_48_STEREO,
    AAC_ISO,
    AAC_ISO_320,
    AAC_ADTS,
    AAC_ADTS_320,
    FLAC,
    OGG,

    JPEG_SM,
    JPEG_MED,
    JPEG_LRG,
    JPEG_TN,
    PNG_LRG,
    PNG_TN,
    GIF_LRG,
    RAW,

    MPEG1,
    MPEG_PS_PAL,
    MPEG_PS_NTSC,
    MPEG_TS_SD_EU,
    MPEG_TS_SD_EU_ISO,
    MPEG_TS_SD_EU_T,
    MPEG_TS_SD_NA,
    MPEG_TS_SD_NA_ISO,
    MPEG_TS_SD_NA_T,
    MPEG_TS_SD_KO,
    MPEG_TS_SD_KO_ISO,
    MPEG_TS_SD_KO_T,
    MPEG_TS_JP_T,
    AVI,
    MATROSKA,
    HLS,
    FLV,
    DVR_MS,
    WTV,
    OGV,
    REAL_VIDEO,
    AVC_MP4_MP_SD_AAC_MULT5,
    AVC_MP4_MP_SD_MPEG1_L3,
    AVC_MP4_MP_SD_AC3,
    AVC_MP4_MP_HD_720p_AAC,
    AVC_MP4_MP_HD_1080i_AAC,
    AVC_MP4_HP_HD_AAC,
    AVC_TS_MP_HD_AAC_MULT5,
    AVC_TS_MP_HD_AAC_MULT5_T,
    AVC_TS_MP_HD_AAC_MULT5_ISO,
    AVC_TS_MP_HD_MPEG1_L3,
    AVC_TS_MP_HD_MPEG1_L3_T,
    AVC_TS_MP_HD_MPEG1_L3_ISO,
    AVC_TS_MP_HD_AC3,
    AVC_TS_MP_HD_AC3_T,
    AVC_TS_MP_HD_AC3_ISO,
    AVC_TS_HP_HD_MPEG1_L2_T,
    AVC_TS_HP_HD_MPEG1_L2_ISO,
    AVC_TS_MP_SD_AAC_MULT5,
    AVC_TS_MP_SD_AAC_MULT5_T,
    AVC_TS_MP_SD_AAC_MULT5_ISO,
    AVC_TS_MP_SD_MPEG1_L3,
    AVC_TS_MP_SD_MPEG1_L3_T,
    AVC_TS_MP_SD_MPEG1_L3_ISO,
    AVC_TS_HP_SD_MPEG1_L2_T,
    AVC_TS_HP_SD_MPEG1_L2_ISO,
    AVC_TS_MP_SD_AC3,
    AVC_TS_MP_SD_AC3_T,
    AVC_TS_MP_SD_AC3_ISO,
    AVC_TS_HD_DTS_T,
    AVC_TS_HD_DTS_ISO,
    WMVMED_BASE,
    WMVMED_FULL,
    WMVMED_PRO,
    WMVHIGH_FULL,
    WMVHIGH_PRO,
    VC1_ASF_AP_L1_WMA,
    VC1_ASF_AP_L2_WMA,
    VC1_ASF_AP_L3_WMA,
    VC1_TS_AP_L1_AC3_ISO,
    VC1_TS_AP_L2_AC3_ISO,
    VC1_TS_HD_DTS_ISO,
    VC1_TS_HD_DTS_T,
    MPEG4_P2_MP4_ASP_AAC,
    MPEG4_P2_MP4_SP_L6_AAC,
    MPEG4_P2_MP4_NDSD,
    MPEG4_P2_TS_ASP_AAC,
    MPEG4_P2_TS_ASP_AAC_T,
    MPEG4_P2_TS_ASP_AAC_ISO,
    MPEG4_P2_TS_ASP_MPEG1_L3,
    MPEG4_P2_TS_ASP_MPEG1_L3_T,
    MPEG4_P2_TS_ASP_MPEG1_L3_ISO,
    MPEG4_P2_TS_ASP_MPEG2_L2,
    MPEG4_P2_TS_ASP_MPEG2_L2_T,
    MPEG4_P2_TS_ASP_MPEG2_L2_ISO,
    MPEG4_P2_TS_ASP_AC3,
    MPEG4_P2_TS_ASP_AC3_T,
    MPEG4_P2_TS_ASP_AC3_ISO,
    AVC_TS_HD_50_LPCM_T,
    AVC_MP4_LPCM,
    MPEG4_P2_3GPP_SP_L0B_AAC,
    MPEG4_P2_3GPP_SP_L0B_AMR,
    AVC_3GPP_BL_QCIF15_AAC,
    MPEG4_H263_3GPP_P0_L10_AMR,
    MPEG4_H263_MP4_P0_L10_AAC,
}

public MediaFileType getFileType(MediaFormatProfile profile)
{
    final switch (profile)
    {
        case MediaFormatProfile.MP3: 
            return MediaFileType.AUDIO;
        case MediaFormatProfile.MP2_MPS: 
            return MediaFileType.AUDIO;
        case MediaFormatProfile.WMA_BASE: 
            return MediaFileType.AUDIO;
        case MediaFormatProfile.WMA_FULL: 
            return MediaFileType.AUDIO;
        case MediaFormatProfile.LPCM16_44_MONO: 
            return MediaFileType.AUDIO;
        case MediaFormatProfile.LPCM16_44_STEREO: 
            return MediaFileType.AUDIO;
        case MediaFormatProfile.LPCM16_48_MONO: 
            return MediaFileType.AUDIO;
        case MediaFormatProfile.LPCM16_48_STEREO: 
            return MediaFileType.AUDIO;
        case MediaFormatProfile.AAC_ISO: 
            return MediaFileType.AUDIO;
        case MediaFormatProfile.AAC_ISO_320: 
            return MediaFileType.AUDIO;
        case MediaFormatProfile.AAC_ADTS: 
            return MediaFileType.AUDIO;
        case MediaFormatProfile.AAC_ADTS_320: 
            return MediaFileType.AUDIO;
        case MediaFormatProfile.FLAC: 
            return MediaFileType.AUDIO;
        case MediaFormatProfile.OGG: 
            return MediaFileType.AUDIO;

        case MediaFormatProfile.JPEG_SM: 
            return MediaFileType.IMAGE;
        case MediaFormatProfile.JPEG_MED: 
            return MediaFileType.IMAGE;
        case MediaFormatProfile.JPEG_LRG: 
            return MediaFileType.IMAGE;
        case MediaFormatProfile.JPEG_TN: 
            return MediaFileType.IMAGE;
        case MediaFormatProfile.PNG_LRG: 
            return MediaFileType.IMAGE;
        case MediaFormatProfile.PNG_TN: 
            return MediaFileType.IMAGE;
        case MediaFormatProfile.GIF_LRG: 
            return MediaFileType.IMAGE;
        case MediaFormatProfile.RAW: 
            return MediaFileType.IMAGE;

        case MediaFormatProfile.MPEG1: 
            return MediaFileType.VIDEO;
        case MediaFormatProfile.MPEG_PS_PAL: 
            return MediaFileType.VIDEO;
        case MediaFormatProfile.MPEG_PS_NTSC: 
            return MediaFileType.VIDEO;
        case MediaFormatProfile.MPEG_TS_SD_EU: 
            return MediaFileType.VIDEO;
        case MediaFormatProfile.MPEG_TS_SD_EU_ISO: 
            return MediaFileType.VIDEO;
        case MediaFormatProfile.MPEG_TS_SD_EU_T: 
            return MediaFileType.VIDEO;
        case MediaFormatProfile.MPEG_TS_SD_NA: 
            return MediaFileType.VIDEO;
        case MediaFormatProfile.MPEG_TS_SD_NA_ISO: 
            return MediaFileType.VIDEO;
        case MediaFormatProfile.MPEG_TS_SD_NA_T: 
            return MediaFileType.VIDEO;
        case MediaFormatProfile.MPEG_TS_SD_KO: 
            return MediaFileType.VIDEO;
        case MediaFormatProfile.MPEG_TS_SD_KO_ISO: 
            return MediaFileType.VIDEO;
        case MediaFormatProfile.MPEG_TS_SD_KO_T: 
            return MediaFileType.VIDEO;
        case MediaFormatProfile.MPEG_TS_JP_T: 
            return MediaFileType.VIDEO;
        case MediaFormatProfile.AVI: 
            return MediaFileType.VIDEO;
        case MediaFormatProfile.MATROSKA: 
            return MediaFileType.VIDEO;
        case MediaFormatProfile.HLS:
            return MediaFileType.VIDEO;
        case MediaFormatProfile.FLV: 
            return MediaFileType.VIDEO;
        case MediaFormatProfile.DVR_MS: 
            return MediaFileType.VIDEO;
        case MediaFormatProfile.WTV: 
            return MediaFileType.VIDEO;
        case MediaFormatProfile.OGV: 
            return MediaFileType.VIDEO;
        case MediaFormatProfile.REAL_VIDEO: 
            return MediaFileType.VIDEO;
        case MediaFormatProfile.AVC_MP4_MP_SD_AAC_MULT5: 
            return MediaFileType.VIDEO;
        case MediaFormatProfile.AVC_MP4_MP_SD_MPEG1_L3: 
            return MediaFileType.VIDEO;
        case MediaFormatProfile.AVC_MP4_MP_SD_AC3: 
            return MediaFileType.VIDEO;
        case MediaFormatProfile.AVC_MP4_MP_HD_720p_AAC: 
            return MediaFileType.VIDEO;
        case MediaFormatProfile.AVC_MP4_MP_HD_1080i_AAC: 
            return MediaFileType.VIDEO;
        case MediaFormatProfile.AVC_MP4_HP_HD_AAC: 
            return MediaFileType.VIDEO;
        case MediaFormatProfile.AVC_TS_MP_HD_AAC_MULT5: 
            return MediaFileType.VIDEO;
        case MediaFormatProfile.AVC_TS_MP_HD_AAC_MULT5_T: 
            return MediaFileType.VIDEO;
        case MediaFormatProfile.AVC_TS_MP_HD_AAC_MULT5_ISO: 
            return MediaFileType.VIDEO;
        case MediaFormatProfile.AVC_TS_MP_HD_MPEG1_L3: 
            return MediaFileType.VIDEO;
        case MediaFormatProfile.AVC_TS_MP_HD_MPEG1_L3_T: 
            return MediaFileType.VIDEO;
        case MediaFormatProfile.AVC_TS_MP_HD_MPEG1_L3_ISO: 
            return MediaFileType.VIDEO;
        case MediaFormatProfile.AVC_TS_MP_HD_AC3: 
            return MediaFileType.VIDEO;
        case MediaFormatProfile.AVC_TS_MP_HD_AC3_T: 
            return MediaFileType.VIDEO;
        case MediaFormatProfile.AVC_TS_MP_HD_AC3_ISO: 
            return MediaFileType.VIDEO;
        case MediaFormatProfile.AVC_TS_HP_HD_MPEG1_L2_T: 
            return MediaFileType.VIDEO;
        case MediaFormatProfile.AVC_TS_HP_HD_MPEG1_L2_ISO: 
            return MediaFileType.VIDEO;
        case MediaFormatProfile.AVC_TS_MP_SD_AAC_MULT5: 
            return MediaFileType.VIDEO;
        case MediaFormatProfile.AVC_TS_MP_SD_AAC_MULT5_T: 
            return MediaFileType.VIDEO;
        case MediaFormatProfile.AVC_TS_MP_SD_AAC_MULT5_ISO: 
            return MediaFileType.VIDEO;
        case MediaFormatProfile.AVC_TS_MP_SD_MPEG1_L3: 
            return MediaFileType.VIDEO;
        case MediaFormatProfile.AVC_TS_MP_SD_MPEG1_L3_T: 
            return MediaFileType.VIDEO;
        case MediaFormatProfile.AVC_TS_MP_SD_MPEG1_L3_ISO: 
            return MediaFileType.VIDEO;
        case MediaFormatProfile.AVC_TS_HP_SD_MPEG1_L2_T: 
            return MediaFileType.VIDEO;
        case MediaFormatProfile.AVC_TS_HP_SD_MPEG1_L2_ISO: 
            return MediaFileType.VIDEO;
        case MediaFormatProfile.AVC_TS_MP_SD_AC3: 
            return MediaFileType.VIDEO;
        case MediaFormatProfile.AVC_TS_MP_SD_AC3_T: 
            return MediaFileType.VIDEO;
        case MediaFormatProfile.AVC_TS_MP_SD_AC3_ISO: 
            return MediaFileType.VIDEO;
        case MediaFormatProfile.AVC_TS_HD_DTS_T: 
            return MediaFileType.VIDEO;
        case MediaFormatProfile.AVC_TS_HD_DTS_ISO: 
            return MediaFileType.VIDEO;
        case MediaFormatProfile.WMVMED_BASE: 
            return MediaFileType.VIDEO;
        case MediaFormatProfile.WMVMED_FULL: 
            return MediaFileType.VIDEO;
        case MediaFormatProfile.WMVMED_PRO: 
            return MediaFileType.VIDEO;
        case MediaFormatProfile.WMVHIGH_FULL: 
            return MediaFileType.VIDEO;
        case MediaFormatProfile.WMVHIGH_PRO: 
            return MediaFileType.VIDEO;
        case MediaFormatProfile.VC1_ASF_AP_L1_WMA: 
            return MediaFileType.VIDEO;
        case MediaFormatProfile.VC1_ASF_AP_L2_WMA: 
            return MediaFileType.VIDEO;
        case MediaFormatProfile.VC1_ASF_AP_L3_WMA: 
            return MediaFileType.VIDEO;
        case MediaFormatProfile.VC1_TS_AP_L1_AC3_ISO: 
            return MediaFileType.VIDEO;
        case MediaFormatProfile.VC1_TS_AP_L2_AC3_ISO: 
            return MediaFileType.VIDEO;
        case MediaFormatProfile.VC1_TS_HD_DTS_ISO: 
            return MediaFileType.VIDEO;
        case MediaFormatProfile.VC1_TS_HD_DTS_T: 
            return MediaFileType.VIDEO;
        case MediaFormatProfile.MPEG4_P2_MP4_ASP_AAC: 
            return MediaFileType.VIDEO;
        case MediaFormatProfile.MPEG4_P2_MP4_SP_L6_AAC: 
            return MediaFileType.VIDEO;
        case MediaFormatProfile.MPEG4_P2_MP4_NDSD: 
            return MediaFileType.VIDEO;
        case MediaFormatProfile.MPEG4_P2_TS_ASP_AAC: 
            return MediaFileType.VIDEO;
        case MediaFormatProfile.MPEG4_P2_TS_ASP_AAC_T: 
            return MediaFileType.VIDEO;
        case MediaFormatProfile.MPEG4_P2_TS_ASP_AAC_ISO: 
            return MediaFileType.VIDEO;
        case MediaFormatProfile.MPEG4_P2_TS_ASP_MPEG1_L3: 
            return MediaFileType.VIDEO;
        case MediaFormatProfile.MPEG4_P2_TS_ASP_MPEG1_L3_T: 
            return MediaFileType.VIDEO;
        case MediaFormatProfile.MPEG4_P2_TS_ASP_MPEG1_L3_ISO: 
            return MediaFileType.VIDEO;
        case MediaFormatProfile.MPEG4_P2_TS_ASP_MPEG2_L2: 
            return MediaFileType.VIDEO;
        case MediaFormatProfile.MPEG4_P2_TS_ASP_MPEG2_L2_T: 
            return MediaFileType.VIDEO;
        case MediaFormatProfile.MPEG4_P2_TS_ASP_MPEG2_L2_ISO: 
            return MediaFileType.VIDEO;
        case MediaFormatProfile.MPEG4_P2_TS_ASP_AC3: 
            return MediaFileType.VIDEO;
        case MediaFormatProfile.MPEG4_P2_TS_ASP_AC3_T: 
            return MediaFileType.VIDEO;
        case MediaFormatProfile.MPEG4_P2_TS_ASP_AC3_ISO: 
            return MediaFileType.VIDEO;
        case MediaFormatProfile.AVC_TS_HD_50_LPCM_T: 
            return MediaFileType.VIDEO;
        case MediaFormatProfile.AVC_MP4_LPCM: 
            return MediaFileType.VIDEO;
        case MediaFormatProfile.MPEG4_P2_3GPP_SP_L0B_AAC: 
            return MediaFileType.VIDEO;
        case MediaFormatProfile.MPEG4_P2_3GPP_SP_L0B_AMR: 
            return MediaFileType.VIDEO;
        case MediaFormatProfile.AVC_3GPP_BL_QCIF15_AAC: 
            return MediaFileType.VIDEO;
        case MediaFormatProfile.MPEG4_H263_3GPP_P0_L10_AMR: 
            return MediaFileType.VIDEO;
        case MediaFormatProfile.MPEG4_H263_MP4_P0_L10_AAC:
            return MediaFileType.VIDEO;
    }
    
    return MediaFileType.VIDEO;
}

public bool isManifestFormat(MediaFormatProfile profile)
{
    if (profile == MediaFormatProfile.HLS)
        return true;

    return false;
}

public List!(MediaFormatProfile) getSupportedMediaFormatProfiles()
{
    return Arrays.asList(values!MediaFormatProfile());
}


/* Location:           C:\Users\Main\Downloads\serviio.jar
* Qualified Name:     org.serviio.dlna.MediaFormatProfile
* JD-Core Version:    0.7.0.1
*/