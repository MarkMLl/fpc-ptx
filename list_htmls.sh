#!/bin/bash

. ./params.sh

# Parameters are fully-qualified .chm filenames. Invoke like e.g.
#
# ./list_chms.sh | xargs ./list_htmls.sh
#
# assuming the working directory etc. are in params.sh

for chm in $@ ; do
  $CHMLS list --name-only $chm 2> /dev/null | grep \.html
done

