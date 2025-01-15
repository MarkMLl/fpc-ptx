#!/usr/bin/perl

# This is used to process a file containing documentation summaries pertaining
# to a single version of the FPC RTL and/or FCL etc., outputting a permuted
# index. Assume https://sourceforge.net/projects/freepascal/files/Documentation/
# as the master archive and expand the doc-chm.zip file, then work in the help
# directory e.g. /usr/local/src/fpc-doc/3.2.2/help which- at present- contains
# the script files mentioned below.
#
# Do something like this:
#
# ./list_htmls.sh rtl.chm | ./prefix_lines.sh "rtl.chm " | xargs --max-lines=1 ./dump_text.sh > rtl_322.tmp
# grep -A 5 'Overview' < rtl_322.tmp | grep -B 4 -- -- > rtl_322.txt
# rm rtl_322.tmp
#
# This could (and probably should) be replaced by an "all-Perl" solution,
# which apart from anything else could probably be made more efficient.
# However the current attempt has the big advantage that we are working from a
# (large) plain-text input file which allows relatively easy inspection and
# debugging:
#
#                                     SetFAttr
#
#   Set file attributes
# --
# --
#                                    SetFTime
#
#   Set file modification time.
# --
# --
#
# ...and so on. This is actually very crude- probably /unacceptably/ crude
# except for a very early demonstration- since (a) it loses a whole lot of
# potentially-useful information on package and unit names and (b) it gets
# badly confused by existing indexing files etc.
#                                               MarkMLl January 2025
#

require './params.pl';

# Read the file(s) specified or redirected on the command line.

while (<>) {

# Trim trailing cruft and ignore blank lines.

  s/^(.*?)\s*$/$1/g;
  if ($_ eq '') {
    next;
  }

# If the line starts with four or more spaces assume it's a function name,
# discard leading whitespace.

  if (/^ \s{3,}/) {
    $name = $_;
    $name =~ s/^\s+(.+)$/$1/;

# If the name has an appended (platform) etc. discard this.

    $name =~ s/(\S+) \(\S+\)$/$1/;

# If the name still contains spaces assume we were wrong and continue
# looking.

    if ($name =~ / /) {
      $name = '';
      $description = '';
      next;
    }
  } else {

# If the line does not start with -- then accumulate description text. In
# practice this will always be a couple of spaces.

    if ( /^ /) {
      $description .= $_;
    }

# If the line starts with -- then save the name and description.

    if (/^--/ and $name) {
      $description =~ s/\t/ /g;
      $description =~ s/\s\s/ /g;
      $description =~ s/^\s*(\S.*)$/$1/g;

# Here's where things get really gnarly. Start off by rejecting any name
# which embeds ___ (a text separator) or a description which embeds [[ (a
# hyperlink from a page header).

      if (($name =~ m/_{3,}/) or ($description =~ m/\[\[/)) {
        $name = '';
        $description = '';
        next;
      }

# Lose embedded hyperlinks. Not sure why g modifier isn't enough for this...
# I suspect it's something to do with shortening the string.

      while ($description =~ s/^(.*?)(\[\d+\])(.*)$/$1$3/g) {}

# Trim leading cruft. It's not so much that we don't particularly want
# to index this, but it consumes valuable space in what should be a one-
# line index entry.

      if ($description =~ s/^Attempts? //i) {
        $description =~ s/^to //;
      }
      if ($description =~ s/^Tr(y )|(ies )//i) {
        $description =~ s/^to //;
      }
      if ($description =~ s/^Returns? //i) {
        $description =~ s/^the //;
        $description =~ s/^an? //;
      }
      if ($description =~ s/^Calculates? //i) {
        $description =~ s/^the //;
        $description =~ s/^an? //;
      }
      if ($description =~ s/^Extracts? //i) {
        $description =~ s/^the //;
        $description =~ s/^an? //;
      }
      if ($description =~ s/^Encodes? //i) {
        $description =~ s/^the //;
        $description =~ s/^an? //;
      }
      if ($description =~ s/^Converts? //i) {
        $description =~ s/^the //;
        $description =~ s/^an? //;
      }
      if ($description =~ s/^Checks? //i) {
        $description =~ s/^whether //;
        $description =~ s/^if //;
        $description =~ s/^the //;
        $description =~ s/^an? //;
      }
      if ($description =~ s/^Implements? //i) {
        $description =~ s/^the //;
        $description =~ s/^an? //;
      }

# Merge "terms of art", preserving capitalisation.

      $description =~ s/ile name/ilename/;
      $description =~ s/ile mode/ilemode/;
      $description =~ s/pen mode/open_mode/;
      $description =~ s/ile attribute/ile_attribute/;
      $description =~ s/ile descriptor/ile_descriptor/;
      $description =~ s/read and write/read\/write/i;
      $description =~ s/read only/read-only/i;
      $description =~ s/start.of.file/BOF/i;
      $description =~ s/beginning.of.file/BOF/i;
      $description =~ s/end.of.file/EOF/i;
      $description =~ s/ile position/ile_position/i;
      $description =~ s/ime stamp/imestamp/i;
      $description =~ s/ime zone/imezone/i;

# Abbreviate where possible.

      $description =~ s/pproximate /pprox /;
      $description =~ s/aximum /ax /;
      $description =~ s/inimum /in /;
      $description =~ s/verage /vg /;
      $description =~ s/ISO 8601/ISO/;
      $description =~ s/Julian date /Julian /;
      $description =~ s/Julian day /Julian /;
      $description =~ s/UTC time /UTC /i;
      $description =~ s/UTC day /UTC /i;
      $description =~ s/Unix epoch /unix /i;
      $description =~ s/ value / /g;
      $description =~ s/ , /, /g;
      $description =~ s/,//g;

# Excise embedded cruft, and append a recognisable tag where no description
# has been extracted from the original material..

      $description =~ s/ the / /;
      $description =~ s/ an? / /;
      $description =~ s/^(.*?)\W$/$1/;
      if ($description eq '') {
        $description = '[Undescribed]';
      }

# Limit description length, trimming down to a whole word to avoid spurious
# partial-word indexing. Also limit name length in extremis.

      $description = substr($description, 0, $maxD + 1);
      if (length($description) > $maxD) {
        $description =~ s/^(.+\s).+$/$1/g;
      }
      if (length($name) <= $maxN) {
        $name .= ': ';
      } else {
        $name = substr($name, 0, $maxN) . '..';
      }
      printf("$name $description\n");

# So that should have given us something like 24 characters of (function etc.)
# name, 3 characters of separator, and 48 characters of description for a total
# of 75. Allow two or three more for the index marking the significant word
# in a permuted line and that's still less than 78.

      $name = '';
      $description = '';
    }
  }
}
