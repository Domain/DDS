/*
 * PS3 Media Server, for streaming any medias to your PS3.
 * Copyright (C) 2012  I. Sokolov
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; version 2
 * of the License only.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */
module net.pms.formats.v2.SubtitleType;

import java.util.all;

import org.apache.commons.lang.StringUtils : isBlank;
import org.apache.commons.lang.StringUtils : trim;

/**
 * Enum with possible types of subtitle tracks and methods for determining
 * them by file extension or libmediainfo output
 *
 * @since 1.60.0
 */
public class SubtitleType {
	// MediaInfo database of codec signatures (not comprehensive)
	// http://mediainfo.svn.sourceforge.net/viewvc/mediainfo/MediaInfoLib/trunk/Source/Resource/Text/DataBase/

	// SubtitleType(int index, String description, List<String> fileExtensions, List<String> libMediaInfoCodecs)
	//UNKNOWN (0, "Generic", list(), list()),
	//SUBRIP (1, "SubRip",
	//        list("srt"),
	//        list("S_TEXT/UTF8", "S_UTF8", "Subrip")),
	//TEXT (2, "Text file", list("txt"), list()),
	//MICRODVD (3, "MicroDVD", list("sub"), list()),
	//SAMI (4, "SAMI", list("smi"), list()),
	//ASS (5, "(Advanced) SubStation Alpha",
	//        list("ass", "ssa"),
	//        list("S_TEXT/SSA", "S_TEXT/ASS", "S_SSA", "S_ASS", "SSA", "ASS")),
	//VOBSUB (6, "VobSub",
	//        list("idx"),
	//        list("S_VOBSUB", "subp", "mp4s", "E0")),
	//UNSUPPORTED (7, "Unsupported", list(), list()),
	//USF (8, "Universal Subtitle Format", list(), list("S_TEXT/USF", "S_USF")),
	//BMP (9, "BMP", list(), list("S_IMAGE/BMP")),
	//DIVX (10, "DIVX subtitles", list(), list("DXSB")),
	//TX3G (11, "Timed text (TX3G)", list(), list("tx3g")),
	//PGS (12, "Blu-ray subtitles", list(), list("S_HDMV/PGS", "PGS", "144"));

	private int index;
	private String description;
	private List/*<String>*/ fileExtensions;
	private List/*<String>*/ libMediaInfoCodecs;

	private static Map/*<Integer, SubtitleType>*/ stableIndexToSubtitleTypeMap;
	private static Map/*<String, SubtitleType>*/ fileExtensionToSubtitleTypeMap;
	private static Map/*<String, SubtitleType>*/ libmediainfoCodecToSubtitleTypeMap;
	private static List/*<String>*/ list(String[] args... ) {
		return new ArrayList/*<String>*/(Arrays.asList(args));
	}

	static this() {
		stableIndexToSubtitleTypeMap = new HashMap/*<Integer, SubtitleType>*/();
		fileExtensionToSubtitleTypeMap = new HashMap/*<String, SubtitleType>*/();
		libmediainfoCodecToSubtitleTypeMap = new HashMap/*<String, SubtitleType>*/();
		foreach (SubtitleType subtitleType ; values()) {
			stableIndexToSubtitleTypeMap.put(subtitleType.getStableIndex(), subtitleType);
			foreach (String fileExtension ; subtitleType.fileExtensions) {
				fileExtensionToSubtitleTypeMap.put(fileExtension.toLowerCase(), subtitleType);
			}
			foreach (String codec ; subtitleType.libMediaInfoCodecs) {
				libmediainfoCodecToSubtitleTypeMap.put(codec.toLowerCase(), subtitleType);
			}
		}
	}

	public static SubtitleType valueOfStableIndex(int stableIndex) {
		SubtitleType subtitleType = stableIndexToSubtitleTypeMap.get(stableIndex);
		if (subtitleType is null) {
			subtitleType = UNKNOWN;
		}
		return subtitleType;
	}

	/**
	 * @deprecated use getSubtitleTypeByFileExtension(String fileExtension) instead
	 */
	deprecated
	public static SubtitleType getSubtitleTypeByFileExtension(String fileExtension) {
		return valueOfFileExtension(fileExtension);
	}

	public static SubtitleType valueOfFileExtension(String fileExtension) {
		if (isBlank(fileExtension)) {
			return UNKNOWN;
		}
		SubtitleType subtitleType = fileExtensionToSubtitleTypeMap.get(fileExtension.toLowerCase());
		if (subtitleType is null) {
			subtitleType = UNKNOWN;
		}
		return subtitleType;
	}

	/**
	 * @deprecated use SubtitleType valueOfLibMediaInfoCodec(String codec) instead
	 */
	deprecated
	public static SubtitleType getSubtitleTypeByLibMediaInfoCodec(String codec) {
		return valueOfLibMediaInfoCodec(codec);
	}

	public static SubtitleType valueOfLibMediaInfoCodec(String codec) {
		if (isBlank(codec)) {
			return UNKNOWN;
		}
		SubtitleType subtitleType = libmediainfoCodecToSubtitleTypeMap.get(trim(codec).toLowerCase());
		if (subtitleType is null) {
			subtitleType = UNKNOWN;
		}
		return subtitleType;
	}

	public static Set/*<String>*/ getSupportedFileExtensions() {
		return fileExtensionToSubtitleTypeMap.keySet();
	}

	private this(int index, String description, List/*<String>*/ fileExtensions, List/*<String>*/ libMediaInfoCodecs) {
		this.index = index;
		this.description = description;
		this.fileExtensions = fileExtensions;
		this.libMediaInfoCodecs = libMediaInfoCodecs;
	}

	public String getDescription() {
		return description;
	}

	public String getExtension() {
		if (fileExtensions.isEmpty()) {
			return "";
		} else {
			return fileExtensions.get(0);
		}
	}

	public int getStableIndex() {
		return index;
	}
}
