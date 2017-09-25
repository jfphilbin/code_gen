// Copyright (c) 2016, Open DICOMweb Project. All rights reserved.
// Use of this source code is governed by the open source license
// that can be found in the LICENSE file.
// Author: Jim Philbin <jfphilbin@gmail.edu>
// See the AUTHORS file for other contributors.

import 'package:tag/tag.dart';

void main() {
  List<String> codesByIndex = <String>[];
  List<String> sortedCodes = <String>[];
  ;

  List<String> keywordsByIndex = <String>[];
  List<String> sortedKeywords = <String>[];

  List<String> namesByIndex = <String>[];
  List<String> sortedNames = <String>[];

  List<List<int>> tagArray = <List<int>>[];
  List<int> tags = <int>[];
  List<String> tagStrings = <String>[];

  var pTags = pTagCodes.values.toList(growable: false);
  print('Tag count: ${pTags.length}');
//  for(PTag fast_tag in pTagCodes.values) {
  for (int i = 1; i < pTags.length; i++) {
    Tag tag = pTags[i];
    print(tag);

    var code = '0x${tag.code.toRadixString(16).padLeft(8, "0")}';
    codesByIndex.add(code);
    keywordsByIndex.add('"${tag.keyword}"');
    namesByIndex.add('"${tag.name}"');
    VR vr = tag.vr;
    print(vr);
    int vrIndex = tag.vrIndex;
    VM vm = tag.vm;
    int vmMin = vm.min * vm.width;
    int vmMax = (vm.max == -1) ? 255 : vm.max * vm.width;
    int vmRank = vm.width;
    int eType = EType.k3.index;
    int ieLevel = 4;
    int retired = tag.isRetired ? 1 : 0;
    int private = 0;
    List<int> fTag = [
      i,
      vrIndex,
      vmMin,
      vmMax,
      vmRank,
      eType,
      ieLevel,
      private,
      retired
    ];
    print(fTag);

    tagArray.add(fTag);
    var fTagString = '$fTag';
    tagStrings.add(fTagString);
  }

  var tagArrayString = tagStrings.join(', const ');

  int x = 1;
  int y = 2;
  print('x:y ${x.compareTo(y)}');

  int compareStrings(String a, String b) => a.compareTo(b);

  sortedCodes = new List.from(codesByIndex);
  sortedCodes.sort(compareStrings);
  print(codesByIndex);
  print(sortedCodes);

  sortedKeywords = new List.from(keywordsByIndex);
  sortedKeywords.sort(compareStrings);
  print(keywordsByIndex);
  print(sortedKeywords);

  sortedNames = new List.from(namesByIndex);
  sortedNames.sort(compareStrings);
  print(namesByIndex);
  print(sortedNames);

  print(tagArray);
  print('const List<List<int> tagArray = const [\n$tagArrayString];');
}
