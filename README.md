# fpc-ptx
Generate a permuted index from the FPC (Free Pascal Compiler) documentation files.

In common with many software projects, it can be remarkably difficult to answer the "what function do I use for this" question which invariably precedes detailed investigation of the required parameters.

This set of scripts comprises a "proof of concept" which reads the published documentation files (see e.g. https://sourceforge.net/projects/freepascal/files/Documentation/ ), extracts function descriptions from the body of the text, trims these in an attempt to keep entries of a manageable length, and prepares a permuted index.

As an example, using the .chm files for the RTL and FCL packages from versions 2.6.0 (the oldest for which these are available), 2.6.4, 3.0.0 and 3.2.2 (the current version) results in a formatted output file of roughly 38,000 lines with line lengths not exceeding 132 columns (I promise that I did _not_ tune this specifically for the music-ruled fethishists).

Each line comprises the name of a function (truncated where unavoidable), the description (sorted at an index point shown by | ) and a tag indicating what package the function may be found in (RTL or FCL) and the version in which it was introduced (subject to the availability of .chm files, i.e. rtl_264 in this contex means "no later than RTL 2.6.4").

```
TQWordHelper.ToHexString:                                to hexadecimal | string representation {rtl_322}
TShortIntHelper.ToHexStr..                               to hexadecimal | string representation {rtl_322}
TSmallIntHelper.ToHexStr..                               to hexadecimal | string representation {rtl_322}
TWordHelper.ToHexString:                                 to hexadecimal | string representation {rtl_322}
tunicodestring:                                                 Unicode | string representation {rtl_300}
strecopy:                                          Copy null-terminated | string return a pointer to {rtl_260}
strriscan:                                                         Scan | string reversely for a character {rtl_260}
MaxHashStrSize:                                                     Max | string size {fcl_260}
TStringHelper.IndexOfUnQ..                                     Index of | string skipping quoted parts {rtl_322}
TStringSplitOptions:                                              Split | String split options used in TStringHelper. {rtl_322}
RightStr:                                     number of characters from | string starting at end {rtl_322}
TStringHelper.StartsWith:                                           one | string starts with another {rtl_322}
SetActiveCollation:                        Native Object Pascal Unicode | string support {rtl_300}
RT_STRING:                                         Constant identifying | string table resource {rtl_322}
AnsiUpperCase:                                     uppercase version of | string taking into account {rtl_322}
TStringHelper.ToInteger:                                                | string to 32-bit signed integer {rtl_322}
TStringHelper.ToInt64:                                                  | string to 64-bit signed integer {rtl_322}
TryStringToGUID:                                              transform | string to a GUID {rtl_322}
strpcopy:                                                   Copy pascal | string to a null-terminated string {rtl_260}
assign(UTF8String):varia..                                 Assign UTF-8 | string to a variant performing {rtl_322}
UpCase:                                                                 | string to all uppercase {rtl_322}
AnsiStrLower:                                           null-terminated | string to all-lowercase {rtl_322}
strlower:                                               null-terminated | string to all-lowercase {rtl_260}
AnsiStrUpper:                                           null-terminated | string to all-uppercase {rtl_322}
strupper:                                               null-terminated | string to all-uppercase {rtl_260}
ArrayStringToPPchar:                                   Concert array of | string to an array of {rtl_322}
TStringHelper.CompareTo:                                        Compare | string to another {rtl_322}
StrPas:                                                 null-terminated | string to ansistring {rtl_322}
Utf8ToAnsi:                                       UTF-8 encoded Unicode | string to ansistring {rtl_322}
```

Note that TStringHelper (from SysUtils) is correctly grouped with standard string operations (from System, StrUtils etc.).

For a detailed description of parameters and semantics, see the standard documentation based at https://www.freepascal.org/docs.html


I again emphasise that this is intended as a proof of concept. As such there are various known problems with efficiency etc., but the most glaring issue is that parameters must be specified in the parameters.sh file rather than passed on a command line.
