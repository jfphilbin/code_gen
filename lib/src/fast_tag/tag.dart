// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'package:system/system.dart';
import 'package:tag/vr.dart';

import 'code.dart';
import 'code_string.dart';
import 'etype.dart';
import 'ie_level.dart';
import 'keyword.dart';
import 'name.dart';
import 'vr.dart';

/// Fast Attributes
///
/// Fast Attributes allow complete verification of DICOM Data Elements.
/// A Fast Attribute fits into 63 bits, which means it is a small integer
/// value in Dart.
///
/// **Attribute Components**
///   Index: The Attribute's Identifier. It is used to access components
///      of the Attribute, such as Tag, Keyword, and Name, that are used
///      less often.
///   VR Index: Identifies the Attributes Value Representation or Data Type.
///   VM Min: The minimum number of values the Attribute must have.
///   VM Max: The maximum number of values the Attribute must have.
///   VM Rank: The width of the values array.
///   Type: The conditionality of the Attribute.
///   Private: Is the Attribute private.
///   Retired: Is the Attribute retired.
///   Information Entity Level: The Level in the IE hierarchy.
///
/// The following table shows the different Attribute Values and the
/// number of bits needed for each.import.
///
/// |            |  Bits  |    Bits   |        |            |
/// | Name       | Needed | Allocated | Offset |    Mask    |
/// |------------|--------|-----------|--------|------------|
/// | Index      |      ? |        16 |      0 | 0x00000000 |
/// | VR Index   |      6 |         8 |     16 | 0x00000000 |
/// | VM Min     |      ? |         8 |     24 | 0x00000000 |
/// | VM Max     |      ? |         8 |     32 | 0x00000000 |
/// | VM Width   |      ? |         8 |     40 | 0x00000000 |
/// | Mode       |      3 |         3 |     43 | 0x00000000 |
/// | IE Level   |      2 |         2 |     45 | 0x00000000 |
/// | isPrivate  |      1 |         1 |     46 | 0x00000000 |
/// | is Retired |      1 |         1 |     24 | 0x00000000 |
/// |------------|--------|---- ------|--------|------------|
/// | Total      |      ? |        55 |        |            |
///

const int _kIndexMask = 0x000000000000FFFF;
const int _kVRIndexMask = 0x0000000000FF0000;
const int _kVMMinMask = 0x00000000FF000000;
const int _kVMMaxMask = 0x000000FF00000000;
const int _kVMRankMask = 0x0000FF0000000000;
const int _kETypeMask = 0x0007000000000000;
const int _kIELevelMask = 0x0018000000000000;
const int _kPrivateMask = 0x0020000000000000;
const int _kRetiredMask = 0x0040000000000000;

// Field shift values
const int _kIndexShift = 0;
const int _kVRIndexShift = 16;
const int _kVMMinShift = 24;
const int _kVMMaxShift = 32;
const int _kVMRankShift = 40;
const int _kETypeShift = 48;
const int _kIELevelShift = 51;
const int _kPrivateShift = 53;
const int _kRetiredShift = 54;

/// Returns [true] if value [v] is in the specified range.
bool _inRange(int v, int min, int max) => v >= 0 && v <= 0xFFFF;

/* Examples showing how fields are accessed.

/// Returns value [v] if it is in the specified range; otherwise, [null].
int _check(int v, int min, int max, String name) =>
    _inRange(min, v, max) ? v : invalidFieldError(name, v);

/// Returns the specified field from the [fast_tag].
int _getField(int fast_tag, int mask) => fast_tag & mask;

/// Returns a new [fast_tag] containing the specificed field value.
int _setField(int fast_tag, int value, int mask, int shift) =>
    ((value << shift) & mask) | fast_tag;
*/

// [0, 0, 0, 1, 1, 0, 0, 0, 0]
const int _kMinValidTag = 0x0000010100000000;
//Urgent
// // [FFFF, 32, ?, 255, 3, 5, 4, 1, 1]
const int _kMaxValidTag = 0x07FFFFFFFFFFFFFFFFFF;

bool _tagInRange(int tag) => tag >= 0 && tag <= 0x07FFFFFFFFFFFFFF;

// Index
const int _kMinIndex = 0;
const int _kMaxIndex = 0xFFFF;
const int _kIndexOffset = 0;
bool _isValidIndex(int i) => _inRange(i, _kMinIndex, _kMaxIndex);
int _checkIndex(int i) => _isValidVRIndex(i) ? i : _invalidValueError(i, 'Index');

// vrIndex
const int kMinVRIndex = 0;
final int kMaxVRIndex = VR.kUT.index; //Urgent - should be VR.maxIndex;

bool _isValidVRIndex(int i) => _inRange(i, kMinVRIndex, kMaxVRIndex);
int _checkVRIndex(int i) =>
    _isValidIndex(i) ? i : _invalidValueError(i, 'VRIndex');

// vmMin
const int _kMinVMMin = 0;
const int _kMaxPublicVMMin = 24;
bool _isValidVMMin(int i) => _inRange(i, _kMinVMMin, _kMaxPublicVMMin);
int _checkVMMin(int i) => _isValidVMMin(i) ? i : _invalidValueError(i, 'VMMax');

// vmMax
const int _kMinVMMax = 1;
const int _kMaxVMMax = 255;
bool _isValidVMMax(int i) => _inRange(i, _kMinVMMax, _kMaxVMMax);
int _checkVMMax(int i) => _isValidVMMax(i) ? i : _invalidValueError(i, 'VMMin');

// vmRank
const int _kMinVMRank = 1;
const int _kMaxVMRank = -1;
bool _isValidVMRank(int i) => _inRange(i, _kMinVMRank, _kMaxVMRank);
int _checkVMRank(int i) =>
    _isValidVMRank(i) ? i : _invalidValueError(i, 'VMRank');

// EType
const int _kMinEType = 0;
const int _kMaxEType = 4;
bool _isValidEType(int i) => _inRange(i, _kMinEType, _kMaxEType);
int _checkEType(int i) => _isValidEType(i) ? i : _invalidValueError(i, 'EType');

// IELevel
const int _kMinIELevel = 0;
const int _kMaxIELevel = 3;
bool _isValidIELevel(int i) => _inRange(i, _kMinIELevel, _kMaxIELevel);
int _checkIELevel(int i) =>
    _isValidIELevel(i) ? i : _invalidValueError(i, 'IELevel');

// Private
const int _kMinPrivate = 0;
const int _kMaxPrivate = 3;
bool _isValidPrivate(int i) => _inRange(i, _kMinPrivate, _kMaxPrivate);
int _checkPrivate(int i) =>
    _isValidPrivate(i) ? i : _invalidValueError(i, 'Private');

// Retired
const int _kMinRetired = 0;
const int _kMaxRetired = 3;
bool _isValidRetired(int i) => _inRange(i, _kMinRetired, _kMaxRetired);
int _checkRetired(int i) =>
    _isValidRetired(i) ? i : _invalidValueError(i, 'Retired');

Null _invalidValueError(int value, String name) {
  var msg = 'Invalid Tag Field Value for field "$name": $value';
  log.error(msg);
  if (throwOnError) throw new InvalidFieldError(msg);
  return null;
}

class Tag {
  final int fields;

  const Tag(this.fields);

  int get index => (fields & _kIndexMask) >> _kIndexShift;

  bool isValidIndex(int v) => _inRange(v, 0, 0xFFFF);
  int checkIndex(int v) => isValidIndex(v) ? v : invalidFieldError('Index', v);
  void set index(int i) =>
      ((_checkIndex(i) << _kIndexShift) & _kIndexMask) | fields;

  int get vrIndex => (fields & _kVRIndexMask) >> _kVRIndexShift;
  void set vrIndex(int i) =>
      ((_checkVRIndex(i) << _kVRIndexShift) & _kVRIndexMask) | fields;

  int get vmMin => (fields & _kVMMinMask) >> _kVMMinShift;
  void set vmMin(int i) =>
      ((_checkVMMin(i) << _kVMMinShift) & _kVMMinMask) | fields;

  int get vmMax => (fields & _kVMMaxMask) >> _kVMMaxShift;
  void set vmMax(int i) =>
      ((_checkVMMax(i) << _kVMMaxShift) & _kVMMaxMask) | fields;

  int get vmRank => (fields & _kVMRankMask) >> _kVMRankShift;
  void set vmRank(int i) =>
      ((_checkVMRank(i) << _kVMRankShift) & _kVMRankMask) | fields;

  int get eType => (fields & _kETypeMask) >> _kETypeShift;
  void set eType(int i) =>
      ((_checkEType(i) << _kETypeShift) & _kETypeMask) | fields;

  int get ieLevel => (fields & _kIELevelMask) >> _kIELevelShift;
  void set ieLevel(int i) =>
      ((_checkIELevel(i) << _kIELevelShift) & _kIELevelMask) | fields;

  int get private => (fields & _kPrivateMask) >> _kPrivateShift;
  void set private(int i) =>
      ((_checkPrivate(i) << _kPrivateShift) & _kPrivateMask) | fields;

  bool get isPrivate => private == 1;
  void set isPrivate(bool v) => v ? 1 : 0;
  bool get isPublic => !isPrivate;

  int get retired => (fields & _kRetiredMask) >> _kRetiredShift;
  void set retired(int i) =>
      ((_checkRetired(i) << _kRetiredShift) & _kRetiredMask) | fields;

  bool get isRetired => retired == 1;
  void set isRetired(bool v) => retired = v ? 1 : 0;

  int get code => codesByIndex[index];
  String _get32BitHex(int i) => '0x${i.toRadixString(16).padLeft(4, '0')}';
  String get asHex => _get32BitHex(code);
  String get asDcm => '($groupAsHex, $eltAsHex)';

  String _get16BitHex(int i) => '0x${i.toRadixString(16).padLeft(4, '0')}';
  int get group => code >> 16;
  String get groupAsHex => _get16BitHex(group);
  int get elt => code & 0xFFF;
  String get eltAsHex => _get16BitHex(group);

  String get keyword => lKeywordsByIndex[index];
  String get name => namesByIndex[index];
  VR get vr => kVRByIndex[index];
  IE get ie => IE.byIndex[ieLevel];
  EType get etype => EType.byIndex[eType];

  bool isValidLength(List values, [ValuesIssues issues]) {
    assert(values != null);
    var length = values.length;
    if (length == 0 && eType > 1) return true;
    var ok = length >= vmMin && length <= vmMax && length % vmRank == 0;
    return (ok) ? true : valuesLengthError(length, issues);
  }

  bool isValidValues<V>(List<V> vList, [ValuesIssues issues]) {
    var ok = isValidLength(vList, issues);
    if (!ok) return false;
    for(V v in vList)
      if (vr.isNotValid(v)) ok= false;
    return ok;
  }

  bool isNotValidValues<V>(List<V> vList) => !isValidValues(vList);

  bool valuesLengthError<T>(int length, ValuesIssues issues) {
    var msg = <String>[];
    var okLength = length >= vmMin && length <= vmMax;
    if (!okLength) {
      msg.add('Invalid number of values: '
          'min($vmMin) <= length(${length} <= max($vmMax))');
    }
    var okRank = length % vmRank == 0;
    if (!okRank) {
      msg.add('Invalid number of values: '
          'length(${length} modulo width($vmRank) must equal 0, '
          'but is ${length % vmRank}');
    }
    if (issues != null) issues.addAll(msg);
    // log.error(issues.message);
    if (throwOnError) throw new InvalidValuesLengthError(this, msg);
    return false;
  }
  // **** Errors ****

  // **** Static Getters and Methods ****

  static isValidTagIndex(int i) => _tagInRange(i);

  static int setField(int tag, int value, int shift, int mask) =>
      ((value << shift) & mask) | tag;

  static int getField(int tag, int shift, int mask) => (tag & mask) >> shift;

  static int setIndex(int tag, int value) =>
      ((value << _kIndexShift) & _kIndexMask) | tag;

  static int getIndex(int tag) => (tag & _kIndexMask) >> _kIndexShift;

  static int setVRIndex(int tag, int value) =>
      ((value << _kVRIndexShift) & _kVRIndexMask) | tag;

  static int getVRIndex(int tag) => (tag & _kVRIndexMask) >> _kVRIndexShift;

  static int setVMMin(int tag, int value) =>
      ((value << _kVMMinShift) & _kVMMinMask) | tag;

  static int getVMMin(int tag) => (tag & _kVMMinMask) >> _kVMMinShift;

  static int setVMMax(int tag, int value) =>
      ((value << _kVMMaxShift) & _kVMMaxMask) | tag;

  static int getVMMax(int tag) => (tag & _kVMMaxMask) >> _kVMMaxShift;

  static int setVMRank(int tag, int value) =>
      ((value << _kVMRankShift) & _kVMRankMask) | tag;

  static int getVMRank(int tag) => (tag & _kVMRankMask) >> _kVMRankShift;

  static int setEType(int tag, int value) =>
      ((value << _kETypeShift) & _kETypeMask) | tag;

  static int getEType(int tag) => (tag & _kETypeMask) >> _kETypeShift;

  static int setIELevel(int tag, int value) =>
      ((value << _kIELevelShift) & _kIELevelMask) | tag;

  static int getIELevel(int tag) => (tag & _kIELevelMask) >> _kIELevelShift;

  static int setPrivate(int tag, int value) =>
      ((value << _kPrivateShift) & _kPrivateMask) | tag;

  static int getPrivate(int tag) => (tag & _kPrivateMask) >> _kPrivateShift;

  static int setRetired(int tag, int value) =>
      ((value << _kRetiredShift) & _kRetiredMask) | tag;

  static int getRetired(int tag) => (tag & _kRetiredMask) >> _kRetiredShift;

  static String showTag(int v) =>
      v.toRadixString(16).padLeft(16, "0").toUpperCase();

  static int fromList(List<int> tl) => makeFastTag(
      tl[0], tl[1], tl[2], tl[3], tl[4], tl[5], tl[6], tl[7], tl[8]);

  static int makeFastTag(int index, int vrIndex, int vmMin, int vmMax,
      int vmRank, int eType, int ieLevel, int private, int retired) {
    int tag = 0;

    tag = setIndex(tag, index);
    tag = setVRIndex(tag, vrIndex);
    tag = setVMMin(tag, vmMin);
    tag = setVMMax(tag, vmMax);
    tag = setVMRank(tag, vmRank);
    tag = setEType(tag, eType);
    tag = setIELevel(tag, ieLevel);
    tag = setPrivate(tag, private);
    tag = setRetired(tag, retired);
    return tag;
  }

  static List<int> readFastTag(int tag) {
    int index = getIndex(tag);
    int vrIndex = getVRIndex(tag);
    int vmMin = getVMMin(tag);
    int vmMax = getVMMax(tag);
    int vmRank = getVMRank(tag);
    int eType = getEType(tag);
    int ieLevel = getIELevel(tag);
    int private = getPrivate(tag);
    int retired = getRetired(tag);
    return [
      index,
      vrIndex,
      vmMin,
      vmMax,
      vmRank,
      eType,
      ieLevel,
      private,
      retired
    ];
  }

  /// Returns the [Tag] corresponding to [index].
  static Tag lookup(int index) => byIndex[index];

  /// Returns the [Tag] corresponding to its [index].
  static Tag fromIndex(int index) => byIndex[index];

  /// Returns the [Tag] corresponding to the DICOM [code].
  static Tag fromCode(int code) => byIndex[tagCodeToIndex(code)];

  /// Returns the [Tag] corresponding to code [String] [s]. A code [String]
  /// has the format "ggggeeee".
  static Tag fromCodeString(String s) => byIndex[tagCodeStringToIndex(s)];

  /// Returns the [Tag] corresponding to [keyword].
  static Tag fromKeyword(String keyword) => byIndex[tagKeywordToIndex(keyword)];

  /// Returns the [Tag] corresponding to [name].
  static Tag fromName(String name) => byIndex[tagNameToIndex(name)];

  /// A [List] of [Tag]s by their index.
  static List<Tag> byIndex = <Tag>[

  ];
}

Null invalidFieldError(String name, int value) {
  var msg = 'Invalid Attribute Field Error: $name Value: $value';
  log.error(msg);
  if (throwOnError) throw new InvalidFieldError(msg);
  return null;
}

class InvalidFieldError extends Error {
  String msg;

  InvalidFieldError(this.msg);

  @override
  String toString() => msg;
}

class InvalidIdentifierError<T> extends Error {
  T id;

  InvalidIdentifierError(this.id);

  @override
  String toString() => 'Invalid Attribute Identifier: $id';
}

Null invalidIdentifierError<T>(T id, Type type) {
  var v = (id is String) ? '"$id"' : id;
  var msg = 'Invalid $type identifier: $v)';
  log.error(msg);
  if (throwOnError) throw new InvalidIdentifierError(v);
  return null;
}

class InvalidValuesLengthError<T> extends Error {
  Tag a;
  List<T> values;
  ValuesIssues issues;

  InvalidValuesLengthError(this.a, this.values, [this.issues]);

  @override
  String toString() => '''Invalid values length for Attribute: $a
  values: ${system.truncate(values)}
  $issues''';
}

class InvalidValuesError<T> extends Error {
  Tag a;
  List<T> values;
  ValuesIssues issues;

  InvalidValuesError(this.a, this.values, [this.issues]);

  @override
  String toString() => '''Invalid values for Attribute: $a
  values: ${system.truncate(values)}
  $issues''';
}

class ValuesIssues {
  final Tag a;
  final List<String> issues = <String>[];

  ValuesIssues(this.a, [String msg]) {
    if (msg != null) issues.add(msg);
  }

  String get message {
    var s = issues.join('\n  ');
    return 'Invalid values for Attribute: $a\n  $s';
  }

  void add(String msg) => issues.add(msg);

  void addAll(List<String> msgs) => issues.addAll(msgs);

  @override
  String toString() => message;
}
