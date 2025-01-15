VERSION=3.2.2
SHORTVER=322
PACKAGE=rtl

TAG=${PACKAGE}_$SHORTVER
CHMNAME=$PACKAGE.chm
CHMLS=/usr/local/bin.fpc/$VERSION/chmls

SOURCE=/usr/local/src/fpc-doc/$VERSION/help/ 
OUTPUT=./

# Above are the master parameters, reformat for Perl and define the maximum
# width of the name and description fields (excluding appended tag).

cat > ./params.pl << EOF

# Script-generated file: DO NOT EDIT.

\$VERSION='$VERSION';
\$SHORTVER='$SHORTVER';
@PACKAGE=('$PACKAGE');

\$TAG='$TAG';
@CHMNAME=('$CHMNAME');
\$CHMLS='$CHMLS';

\$SOURCE='$SOURCE';
\$OUTPUT='$OUTPUT';

\$maxN = 24;
\$maxD = 48;

1;
EOF

