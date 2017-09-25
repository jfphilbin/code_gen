// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'package:collection/collection.dart';
import 'package:tag/vr.dart';

//Urgent: these should be const
final int kMinVRCode = VR.kAE.code;
final int kMaxVRCode = VR.kUT.code;

//final int kMinVRIndex = VR.kAE.index;
//final int kMaxVRIndex =  VR.kUT.index;

/// Returns the index of the VRCode as a 16-bit Little Endian number.
int vrCodeToIndex(String name) => binarySearch(kSortedVRCodes, name);

const List<VR> kVRByIndex = const <VR>[
  VR.kInvalid,
  VR.kAE, VR.kAS, VR.kAT, VR.kBR, VR.kCS,
  VR.kDA, VR.kDS, VR.kDT, VR.kFD, VR.kFL,
  VR.kIS, VR.kLO, VR.kLT, VR.kOB, VR.kOD,
  VR.kOF, VR.kOL, VR.kOW, VR.kPN, VR.kSH,
  VR.kSL, VR.kSQ, VR.kSS, VR.kST, VR.kTM,
  VR.kUC, VR.kUI, VR.kUL, VR.kUN, VR.kUR,
  VR.kUS, VR.kUT // stop reformat
];

const Map<int, VR> vrMap = const <int, VR>{
  0x0000: VR.kInvalid, // stop reformat
  0x4541: VR.kAE, 0x5341: VR.kAS, 0x5441: VR.kAT, 0x5242: VR.kBR,
  0x5343: VR.kCS, 0x4144: VR.kDA, 0x5344: VR.kDS, 0x5444: VR.kDT,
  0x4446: VR.kFD, 0x4c46: VR.kFL, 0x5349: VR.kIS, 0x4f4c: VR.kLO,
  0x544c: VR.kLT, 0x424f: VR.kOB, 0x444f: VR.kOD, 0x464f: VR.kOF,
  0x4c4f: VR.kOL, 0x574f: VR.kOW, 0x4e50: VR.kPN, 0x4853: VR.kSH,
  0x4c53: VR.kSL, 0x5153: VR.kSQ, 0x5353: VR.kSS, 0x5453: VR.kST,
  0x4d54: VR.kTM, 0x4355: VR.kUC, 0x4955: VR.kUI, 0x4c55: VR.kUL,
  0x4e55: VR.kUN, 0x5255: VR.kUR, 0x5355: VR.kUS, 0x5455: VR.kUT
};

VR lookup(int vrCode) => vrMap[vrCode];

const Map<String, VR> vrStringToVR = const <String, VR>{
  "AE": VR.kAE, "AS": VR.kAS, "BR": VR.kBR, "CS": VR.kCS,
  "DA": VR.kDA, "DS": VR.kDS, "DT": VR.kDT, "IS": VR.kIS,
  "LO": VR.kLO, "LT": VR.kLT, "PN": VR.kPN, "SH": VR.kSH,
  "ST": VR.kST, "TM": VR.kTM, "UC": VR.kUC, "UI": VR.kUI,
  "UR": VR.kUR, "UT": VR.kUT, "AT": VR.kAT, "OB": VR.kOB,
  "OW": VR.kOW, "SL": VR.kSL, "SS": VR.kSS, "UL": VR.kUL,
  "US": VR.kUS, "FD": VR.kFD, "FL": VR.kFL, "OD": VR.kOD,
  "OF": VR.kOF // prevent reformat
};

/// VR codes in sorted order from min to max;
const List<int> kSortedVRCodes = const <int>[];
