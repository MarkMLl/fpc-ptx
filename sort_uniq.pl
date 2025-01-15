#!/usr/bin/perl

# require './params.pl';

# Input each line, discard trailing newlines.

@allLines = <>;
chomp(@allLines);

# Sort the list, based on a case-insensitive comparison of what follows the
# index point marked by a bar (which is assumed to be the same position on
# each line) padded with the rest of the description and the name (to keep
# functions with the same description separate).

sub sorter {
  $a =~ /^(.+? +)(.+?)\|(.*?)( \{.+?\})$/;
  $firstName = $1;
  $firstDesc1 = $2;
  $firstDesc2 = $3;
  $b =~ /^(.+? +)(.+?)\|(.*?)( \{.+?\})$/;
  $secondName = $1;
  $secondDesc1 = $2;
  $secondDesc2 = $3;
  lc($firstDesc2 . $firstDesc1 . $firstName) cmp lc($secondDesc2 . $secondDesc1 . $secondName);
}
@sorted = sort(sorter @allLines);

# All else being equal, if the files comprise multiple versions their tags
# will be in ascending order. Compare lines ignoring their tags, output the
# first version of each which will show what package it was in and the version
# in which it first appeared.

$lastText = '';
$lastTag = '{xxx+999}';
foreach $line (@sorted) {
  $line =~ /^(.+?)( \{.+?\})$/;
  $thisText = $1;
  $thisTag = $2;
  if ($thisText ne $lastText) {
    printf("$thisText$thisTag\n");
  }
  $lastText = $thisText;
  $lastTag = $thisTag;
}
