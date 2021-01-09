/*
  (c) Copyright 2020 Vishesh Handa

  Licensed under the MIT license:

      http://www.opensource.org/licenses/mit-license.php

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in
  all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
  THE SOFTWARE.
*/

import 'package:test/test.dart';

import 'package:gitjournal/core/processors/inline_tags.dart';

void main() {
  test('Should parse simple tags', () {
    var body = "#hello Hi\nthere how#are you #doing now? #dog";

    var p = InlineTagsProcessor(tagPrefixes: {'#'});
    var tags = p.extractTags(body);

    expect(tags, {'hello', 'doing', 'dog'});
  });

  test('Ignore . at the end of a tag', () {
    var body = "Hi there #tag.";

    var p = InlineTagsProcessor(tagPrefixes: {'#'});
    var tags = p.extractTags(body);

    expect(tags, {'tag'});
  });

  test('#a#b should be counted as two tags', () {
    var body = "Hi there #a#b";

    var p = InlineTagsProcessor(tagPrefixes: {'#'});
    var tags = p.extractTags(body);

    expect(tags, {'a', 'b'});
  });

  test('Non Ascii tags', () {
    var body = "Hi #fíre gone";

    var p = InlineTagsProcessor(tagPrefixes: {'#'});
    var tags = p.extractTags(body);

    expect(tags, {'fíre'});
  });

  test('Tags with a -', () {
    var body = "Hi #future-me. How are you?";

    var p = InlineTagsProcessor(tagPrefixes: {'#'});
    var tags = p.extractTags(body);

    expect(tags, {'future-me'});
  });

  test('Multiple Prefixes', () {
    var body = "Hi +one+two @foo #doo";

    var p = InlineTagsProcessor(tagPrefixes: {'#', '+', '@'});
    var tags = p.extractTags(body);

    expect(tags, {'one', 'two', 'foo', 'doo'});
  });

  test('Should Ignore headers', () {
    var body = "# Hi\nHow are you?";

    var p = InlineTagsProcessor(tagPrefixes: {'#', '+', '@'});
    var tags = p.extractTags(body);

    expect(tags.isEmpty, true);
  });

  test('Markdown Example', () {
    var body = """# Markdown Example
Markdown allows you to easily include formatted text, images, and even formatted Dart code in your app.

## Titles

Setext-style

This is an H1 =============  This is an H2 -------------

Atx-style

# This is an H1  ## This is an H2  ###### This is an H6

Select the valid headers:

- [x] # hello
- [ ] #hello

## Links

[Google's Homepage][Google]

[inline-style](https://www.google.com)  [reference-style][Google]

## Images



## Tables

|Syntax                                 |Result                               |
|---------------------------------------|-------------------------------------|
|*italic 1*                           |italic 1                           |
|_italic 2_                           | italic 2                          |
|**bold 1**                           |bold 1                           |
|__bold 2__                           |bold 2                           |
|This is a ~~strikethrough~~          |This is a strikethrough          |
|***italic bold 1***                  |italic bold 1                  |
|___italic bold 2___                  |italic bold 2                  |
|***~~italic bold strikethrough 1~~***|***italic bold strikethrough 1***|
|~~***italic bold strikethrough 2***~~|italic bold strikethrough 2|

## Styling
Style text as italic, bold, strikethrough, or inline code.

- Use bulleted lists
- To better clarify
- Your points

## Code blocks
Formatted Dart code looks really pretty too:

void main() {   runApp(MaterialApp(     home: Scaffold(       body: Markdown(data: markdownData),     ),   )); }

## Markdown widget

This is an example of how to create your own Markdown widget:

    Markdown(data: 'Hello world!');

Enjoy!

[Google]: https://www.google.com/""";

    var p = InlineTagsProcessor(tagPrefixes: {'#', '+', '@'});
    var tags = p.extractTags(body);

    expect(tags, {'hello'});
  });

  test("Handles Spaces", () {
    var body = """# DateTimeOffset
#csharp

Provides a combined #structure\tof `DateTime` with an `Offset` property defining a deviation from UTC. It doesn't associate a time zone with the offset.
""";

    var p = InlineTagsProcessor(tagPrefixes: {'#', '+', '@'});
    var tags = p.extractTags(body);

    expect(tags, {'csharp', 'structure'});
  });
}