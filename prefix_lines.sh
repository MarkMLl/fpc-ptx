#!/bin/bash

# Use like
#
# ./list_htmls.sh rtl.chm | ./prefix_lines.sh 'rtl.chm '
#
# Note that the second parameter may have appended whitespace etc. so
# will usually be quoted.

while read line ; do
  echo -n "$@"
  echo "$line"
done

