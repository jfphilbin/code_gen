// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

// Element Type

const int kEType1 = 0;
const int kEType1c = 1;
const int kEType2 = 2;
const int kEType2c = 3;
const int kEType3 = 4;

const int kMinEtype = kEType1;
const int kMaxEtype = kEType3;

/// Element Type
/// Information Entity
class EType {
  final int index;
  final String name;
  final String meaning;

  const EType(this.index, this.name, this.meaning);

  String get info => '$this: $meaning';

  String toString() => '$runtimeType.$name';

  static const k1 = const EType(0, "1", "RequiredNonEmpty");
  static const k1c = const EType(1, "1C", "ConditionallyRequiredNonEmpty");
  static const k2 = const EType(2, "2", "Required");
  static const k2c = const EType(3, "2C", "ConditionallyRequired");
  static const k3 = const EType(3, "3", "Optional");

  static const byIndex = const [k1, k1c, k2, k2c, k3];

  static EType fromIndex(int i) => (i >= k1.index && i <= k3.index)
      ? byIndex[i]
      : throw new RangeError('Invalid IE Index: $i');
}
