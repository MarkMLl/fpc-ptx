#!/bin/bash

. ./params.sh

# Use like
#
# ./dump_text.sh rtl.chm /baseunix/fpalarm.html
#
# or
#
# ./list_htmls.sh rtl.chm | ./prefix_lines.sh 'rtl.chm ' | xargs --max-lines=1 ./dump_text.sh

$CHMLS extract $SOURCE$1 $2 /dev/stdout 2> /dev/null | lynx -stdin -force_html -dump 2> /dev/null

