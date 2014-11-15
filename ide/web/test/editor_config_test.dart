// Copyright (c) 2014, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

library preferences_test;

//import 'dart:async';

import 'package:unittest/unittest.dart';

import '../lib/editor_config.dart';

String editorConfigContent = """

# top-most EditorConfig file
root = true

# Unix-style newlines with a newline ending every file
[*]
end_of_line = lf
insert_final_newline = false

# 4 space indentation
[*.py]
indent_style = tab
indent_size = 4

# Tab indentation (no size specified)
[[!a-g]]
tab_width = 3
indent_size = tab

# Indentation override for all JS under lib directory
[lib/**.js]
indent_size = 5

# Matches the exact files either package.json or .travis.yml
[{package.json,.travis.yml}]
indent_style = space
indent_size = tab
""";

String editorConfigTooManyOptions = """
[*]
end_of_line = lf
insert_final_newline = false
should_not_be_here = true
""";

defineTests() {
  group('editorConfig', () {
    test('glob test - general', () {
      Glob glob = new Glob("a*/b**/d?");
      expect(glob.matchPath("alpha/bravo/charlie/delta"), Glob.PREFIX_MATCH);
      expect(glob.matchPath("alpha/bravo/charlie/d"), Glob.PREFIX_MATCH);
      expect(glob.matchPath("alpha/bravo/charlie/do"), Glob.COMPLETE_MATCH);
      expect(glob.matchPath("abc/do"), Glob.PREFIX_MATCH);
      expect(glob.matchPath("foo/bar"), Glob.NO_MATCH);
      expect(glob.matchPath(""), Glob.NO_MATCH);

      glob = new Glob("a*/b*");
      expect(glob.matchPath("abc/"), Glob.PREFIX_MATCH);
    });

    test('glob test - escaping', () {
      Glob glob = new Glob("a**/foo\\ bar");
      expect(glob.matchPath("aaa/bbb"), Glob.PREFIX_MATCH);
      expect(glob.matchPath("aaa/bbb/foo ba"), Glob.PREFIX_MATCH);
      expect(glob.matchPath("aaa/bbb/foo bar"), Glob.COMPLETE_MATCH);
      expect(glob.matchPath("aaa/bbb/foo barb"), Glob.PREFIX_MATCH);

      glob = new Glob("foo.dart");
      expect(glob.matchPath("foo.dart"), Glob.COMPLETE_MATCH);
      expect(glob.matchPath("foo!dart"), Glob.NO_MATCH);
    });

//    test('EditorConfig - parsing', () {
//      ConfigFile e = new ConfigFile(editorConfigContent);
//
//      expect(e.root, true);
//      ConfigSection section = e.sections[0];
//      expect(section.lineEnding, ConfigSection.ENDING_LF);
//      expect(section.insertFinalNewline, false);
//      section = e.sections[1];
//      expect(section.useSpaces, false);
//      expect(section.indentSize, 4);
//      section = e.sections[2];
//      expect(section.tabWidth, 3);
//      expect(section.indentSize, 3);
//      section = e.sections[3];
//      expect(section.tabWidth, 5);
//      expect(section.indentSize, 5);
//      section = e.sections[4];
//      expect(section.useSpaces, true);
//      expect(section.indentSize, 2);
//      expect(() => new EditorConfig.fromString(editorConfigTooManyOptions),
//          throws);
//    });
  });
}