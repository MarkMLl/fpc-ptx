#!/bin/bash

# Use like
#
# cat rtl_322.ptx | ./suffix_lines.sh {rtl_322}
#
# Note that the second parameter may have appended whitespace etc. so
# will usually be quoted.

while read line ; do
  echo -n "$line"
  echo "$@"
done

