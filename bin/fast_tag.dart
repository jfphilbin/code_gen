// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

int kIndexMask   = 0x000000000000FFFF;
int kVRIndexMask = 0x0000000000FF0000;
int kVMMinMask   = 0x00000000FF000000;
int kVMMaxMask   = 0x000000FF00000000;
int kVMRankMask  = 0x0000FF0000000000;
int kETypeMask   = 0x0007000000000000;
int kIELevelMask = 0x0018000000000000;
int kPrivateMask = 0x0020000000000000;
int kRetiredMask = 0x0040000000000000;

int kIndexShift   = 0;
int kVRIndexShift = 16;
int kVMMinShift   = 24;
int kVMMaxShift   = 32;
int kVMRankShift  = 40;
int kETypeShift   = 48;
int kIELevelShift = 51;
int kPrivateShift = 53;
int kRetiredShift = 54;

const List<List<int>> tags = const <List<int>>[
// [index, vrIndex, vmMin, vmMax, vmRank, eType, ieLevel, private, retired]
  const [0x1234, 0x56, 0x78, 0x9A, 0xBC, 0x01, 0x02, 0x01, 0x01],
  const [0xFEDC, 0xBA, 0x98, 0x76, 0x54, 0x07, 0x04, 0x00, 0x00]

];
int indexValue     = 0x4321;
int vrIndexValue   = 0xAA;
int vmMinValue     = 0xBB;
int vmMaxValue     = 0xCC;
int vmRankValue    = 0xDD;
int eTypeValue     = 2;
int ieLevelValue   = 3;
int isPrivateValue = 1;
int isRetiredValue = 1;

int indexResult     = 0x0000000000004321;
int vrIndexResult   = 0x0000000000AA0000;
int vmMinResult     = 0x00000000BB000000;
int vmMaxResult     = 0x000000CC00000000;
int vrRankResult    = 0x0000DD0000000000;
int eTypeResult     = 0x0002000000000000;
int ieLevelResult   = 0x000E000000000000;
int isPrivateResult = 0x0020000000000000;
int isRetiredResult = 0x0040000000000000;

int setField(int attribute, int value, int shift, mask) =>
    ((value << shift) & mask) | attribute;

int getField(int attribute, int shift, mask) =>
    (attribute & mask) >> shift;

int setIndex(int attribute, int value) =>
    ((value << kIndexShift) & kIndexMask) | attribute;

int getIndex(int attribute) =>
    (attribute & kIndexMask) >> kIndexShift;

int setVRIndex(int attribute, int value) =>
    ((value << kVRIndexShift) & kVRIndexMask) | attribute;

int getVRIndex(int attribute) =>
    (attribute & kVRIndexMask) >> kVRIndexShift;

int setVMMin(int attribute, int value) =>
    ((value << kVMMinShift) & kVMMinMask) | attribute;

int getVMMin(int attribute) =>
    (attribute & kVMMinMask) >> kVMMinShift;

int setVMMax(int attribute, int value) =>
    ((value << kVMMaxShift) & kVMMaxMask) | attribute;

int getVMMax(int attribute) =>
    (attribute & kVMMaxMask) >> kVMMaxShift;

int setVMRank(int attribute, int value) =>
    ((value << kVMRankShift) & kVMRankMask) | attribute;

int getVMRank(int attribute) =>
    (attribute & kVMRankMask) >> kVMRankShift;

int setEType(int attribute, int value) =>
    ((value << kETypeShift) & kETypeMask) | attribute;

int getEType(int attribute) =>
    (attribute & kETypeMask) >> kETypeShift;

int setIELevel(int attribute, int value) =>
    ((value << kIELevelShift) & kIELevelMask) | attribute;

int getIELevel(int attribute) =>
    (attribute & kIELevelMask) >> kIELevelShift;

int setPrivate(int attribute, int value) =>
    ((value << kPrivateShift) & kPrivateMask) | attribute;

int getPrivate(int attribute) =>
    (attribute & kPrivateMask) >> kPrivateShift;

int setRetired(int attribute, int value) =>
    ((value << kRetiredShift) & kRetiredMask) | attribute;

int getRetired(int attribute) =>
    (attribute & kRetiredMask) >> kRetiredShift;

String showTag(int v) => v.toRadixString(16).padLeft(16, "0").toUpperCase();

void main() {
  int a = 0;
  a = setIndex(a, indexValue);
  print('a: 0x${showTag(a)}');

  int v = getIndex(a);
  print('v: 0x${showTag(v)}');
  assert(indexValue == v);

  a = 0;
  a = setVRIndex(a, vrIndexValue);
  print('a: 0x${showTag(a)}');

  v = getVRIndex(a);
  print('v: 0x${showTag(v)}');
  assert(vrIndexValue == v);


  a = 0;
  a = setVMMin(a, vmMinValue);
  print('a: 0x${showTag(a)}');

  v = getVMMin(a);
  print('v: 0x${showTag(v)}');
  assert(vmMinValue == v);

  a = 0;
  a = setVMMax(a, vmMaxValue);
  print('a: 0x${showTag(a)}');

  v = getVMMax(a);
  print('v: 0x${showTag(v)}');
  assert(vmMaxValue == v);

  a = 0;
  a = setVMRank(a, vmRankValue);
  print('a: 0x${showTag(a)}');

  v = getVMRank(a);
  print('v: 0x${showTag(v)}');
  assert(vmRankValue == v);

  a = 0;
  a = setEType(a, eTypeValue);
  print('a: 0x${showTag(a)}');

  v = getEType(a);
  print('v: 0x${showTag(v)}');
  assert(eTypeValue == v);

  a = 0;
  a = setIELevel(a, ieLevelValue);
  print('a: 0x${showTag(a)}');

  v = getIELevel(a);
  print('v: 0x${showTag(v)}');
  assert(ieLevelValue == v);

  a = 0;
  a = setIELevel(a, ieLevelValue);
  print('a: 0x${showTag(a)}');

  v = getIELevel(a);
  print('v: 0x${showTag(v)}');
  assert(ieLevelValue == v);

  a = 0;
  a = setPrivate(a, isPrivateValue);
  print('a: 0x${showTag(a)}');

  v = getPrivate(a);
  print('v: 0x${showTag(v)}');
  assert(isPrivateValue == v);

  a = 0;
  a = setRetired(a, isRetiredValue);
  print('a: 0x${showTag(a)}');

  v = getRetired(a);
  print('v: 0x${showTag(v)}');
  assert(isRetiredValue == v);

  for(int i = 0; i < tags.length; i++) {
   var tag = testIndex(i, 0);
  }
}

int testIndex(int i, int attribute) {
  List<int> tag = tags[i];
  attribute = setIndex(attribute, tag[0]);
  int v = getIndex(attribute);
  print('Index: $i in: ${tag[0]} out: $v');
  print(' in: 0x${showTag(v)}');
  print('out: 0x${showTag(v)}');
  return v;
}

/*
const List<List<int>> attributes = const [
// [index, vrIndex, vmMin, vmMax, vmRank, ieLevel, isPrivate, isRetired]
const [1, VR.kAEindex, 1, 2, 1, 0, 0, 0]
];

int setField(int attribute, int value, int shift, int mask) {
int v = value << shift;
return  v | mask;
}


int aListToInt(List<int> aList) {
int attribute = 0;
int index = aList[0];
}*/
