#!/bin/sh

# set -x

. ./params.sh

# Note that even though the parameters file can specify a list of packages, I'm processing
# one at a time because of the fixed parameter to the prefix_lines.sh script (which will
# often have an appended space, hence the quoting).

./list_chms.sh | xargs ./list_htmls.sh | ./prefix_lines.sh "$CHMNAME " | \
  xargs --max-lines=1 ./dump_text.sh > $OUTPUT$TAG.rawpages
grep -A 5 'Overview' < $OUTPUT$TAG.rawpages | grep -B 3 -- -- > $OUTPUT$TAG.rawchunks

# Reduce each chunk of text to a single line.

./format1.pl < $OUTPUT$TAG.rawchunks > $OUTPUT$TAG.rawlines

# Generate a permuted index. I'm appending the tag to each line since it can be easily
# removed during a final sort (ptx isn't brilliant in this regard), or alternatively
# it could be used to tag the version at which a facility (or at least a particular
# way of describing it) was introduced.

ptx --references --ignore-case --width=128 --ignore-file=stopwords.txt $OUTPUT$TAG.rawlines \
  | ./format2.pl | ./suffix_lines.sh " {$TAG}" > $OUTPUT$TAG.rawptx

# The final sort and deduplication will normally be applied to the merged result
# of running the above over multiple packages and releases (both encoded in the
# appended tag). However it's always useful to have since ptx's sorting isn't very
# good.

./sort_uniq.pl < $OUTPUT$TAG.rawptx > $OUTPUT$TAG.ptx

# Delete temporary files. These will almost certainly be needed during debugging.

rm $OUTPUT$TAG.raw*
rm params.pl

# Judge the efficacy of the ignore list ("stopwords") using something like
#
# cut -d '|' -f 2 scratch | cut -d ' ' -f 2 | sort | uniq -c | sort -n

# TODO:
#
# * Replace messy page grepping and format1.pl to methodically read line-by-line.
#
# * Improve page generation to be able to handle multiple packages and versions.
#
# * Optionally prefix function names with unit and possibly package.
#
# * Progress indication to stderr during .html file processing.
#
# * Are there resources (e.g. "AI") which would aid stopword generation?
#
# * Ditto for terms to be discarded before indexing.
#
# * Ditto for merging pharases into "terms of art" to be indexed atomically.

