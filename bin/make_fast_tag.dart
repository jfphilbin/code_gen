// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'package:code_gen/src/fast_tag/tag.dart';

int kIndexMask = 0x000000000000FFFF;
int kVRIndexMask = 0x0000000000FF0000;
int kVMMinMask = 0x00000000FF000000;
int kVMMaxMask = 0x000000FF00000000;
int kVMRankMask = 0x0000FF0000000000;
int kETypeMask = 0x0007000000000000;
int kIELevelMask = 0x0018000000000000;
int kPrivateMask = 0x0020000000000000;
int kRetiredMask = 0x0040000000000000;

int kIndexShift = 0;
int kVRIndexShift = 16;
int kVMMinShift = 24;
int kVMMaxShift = 32;
int kVMRankShift = 40;
int kETypeShift = 48;
int kIELevelShift = 51;
int kPrivateShift = 53;
int kRetiredShift = 54;

bool _inRange(int min, int v, int max) => v >= 0 && v <= 0xFFFF;

/*
int _check(int min, int v, int max, String name) =>
    _inRange(min, v, max) ? v : invalidFieldError(name, v);
*/

bool isValidIndex(int v) => _inRange(0, v, 0xFFFF);
int  checkIndex(int v) => isValidIndex(v) ? v : invalidFieldError('Index', v);

int setField(int attribute, int value, int shift, int mask) =>
    ((value << shift) & mask) | attribute;

int getField(int attribute, int shift, int mask) => (attribute & mask) >> shift;

int setIndex(int attribute, int value) =>
    ((value << kIndexShift) & kIndexMask) | attribute;

int getIndex(int attribute) => (attribute & kIndexMask) >> kIndexShift;

int setVRIndex(int attribute, int value) =>
    ((value << kVRIndexShift) & kVRIndexMask) | attribute;

int getVRIndex(int attribute) => (attribute & kVRIndexMask) >> kVRIndexShift;

int setVMMin(int attribute, int value) =>
    ((value << kVMMinShift) & kVMMinMask) | attribute;

int getVMMin(int attribute) => (attribute & kVMMinMask) >> kVMMinShift;

int setVMMax(int attribute, int value) =>
    ((value << kVMMaxShift) & kVMMaxMask) | attribute;

int getVMMax(int attribute) => (attribute & kVMMaxMask) >> kVMMaxShift;

int setVMRank(int attribute, int value) =>
    ((value << kVMRankShift) & kVMRankMask) | attribute;

int getVMRank(int attribute) => (attribute & kVMRankMask) >> kVMRankShift;

int setEType(int attribute, int value) =>
    ((value << kETypeShift) & kETypeMask) | attribute;

int getEType(int attribute) => (attribute & kETypeMask) >> kETypeShift;

int setIELevel(int attribute, int value) =>
    ((value << kIELevelShift) & kIELevelMask) | attribute;

int getIELevel(int attribute) => (attribute & kIELevelMask) >> kIELevelShift;

int setPrivate(int attribute, int value) =>
    ((value << kPrivateShift) & kPrivateMask) | attribute;

int getPrivate(int attribute) => (attribute & kPrivateMask) >> kPrivateShift;

int setRetired(int attribute, int value) =>
    ((value << kRetiredShift) & kRetiredMask) | attribute;

int getRetired(int attribute) => (attribute & kRetiredMask) >> kRetiredShift;

String showTag(int v) => v.toRadixString(16).padLeft(16, "0").toUpperCase();

int makeFastTagFromList(List<int> tl) =>
    makeFastTag(tl[0], tl[1], tl[2], tl[3], tl[4], tl[5], tl[6], tl[7], tl[8]);

int makeFastTag(int index, int vrIndex, int vmMin, int vmMax, int vmRank,
    int eType, int ieLevel, int private, int retired) {
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

List<int> readFastTag(int tag) {
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

//String showTag(int v) => v.toRadixString(16).padLeft(16, "0").toUpperCase();

const List<List<int>> tags = const <List<int>>[
// [index, vrIndex, vmMin, vmMax, vmRank, eType, ieLevel, private, retired]
  const [0x1234, 0x56, 0x78, 0x9A, 0xBC, 0, 0, 0x01, 0x01],
  const [0xFEDC, 0xBA, 0x98, 0x76, 0x54, 1, 1, 0x00, 0x00],
  const [0xFEDC, 0xBA, 0x98, 0x76, 0x54, 2, 2, 0x00, 0x00],
  const [0xFEDC, 0xBA, 0x98, 0x76, 0x54, 3, 3, 0x00, 0x00],
  const [0xFEDC, 0xBA, 0x98, 0x76, 0x54, 4, 4, 0x00, 0x00],
  const [0xFEDC, 0xBA, 0x98, 0x76, 0x54, 5, 5, 0x00, 0x00],
  const [0xFEDC, 0xBA, 0x98, 0x76, 0x54, 6, 6, 0x00, 0x00]
];

void main() {
  for (int i = 0; i < tags.length; i++) {
    var tagList = tags[i];
    int tag = makeFastTagFromList(tagList);
    List<int> list = readFastTag(tag);
    print(' in: $tagList');
    print('fast_tag: 0x${showTag(tag)}');
    print('out: $list\n');
  }
}

