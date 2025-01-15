#!/bin/bash

. ./params.sh

# No parameters are expected.

for pkg in $PACKAGE ; do
  find $SOURCE -name "$pkg.chm"
done

