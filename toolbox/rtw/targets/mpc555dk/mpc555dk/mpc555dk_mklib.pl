# Copyright 2001-2002 The MathWorks, Inc.
#
# File    : mpc555dk_mklib.pl   $Revision: 1.6.2.1 $
# $Date: 2004/04/19 01:26:58 $
# Abstract:
#	Builds a library from all files in a source directory.
#
#	Usage: 
#		SET RTW_CC=<whatever>
#		SET RTW_CFLAGS=<whatever>
#		SET RTW_LIBCMD=<whatever>
#		perl mklib.pl <directory> <libraryName>

#------------------------------------------------#
# Setup path for Win32 to get at system commands #
#------------------------------------------------#

BEGIN {
    my ($scriptDir) = ($0 =~ /(.+)[\\\/]/);
    my ($matlabroot) = ($ENV{'MATLAB'});
    push(@INC, "$scriptDir");
    push(@INC, "$matlabroot\\rtw\\c\\tools");

} 

use win_subs;

SetupWinSysPath();

#-------------#
# Check usage #
#-------------#

$nargs = $#ARGV + 1;

if ($nargs != 2) {Usage();}

$dir = $ARGV[0];
$lib = $ARGV[1];

$rtw_cc = $ENV{'RTW_CC'};
if ($rtw_cc eq "") {
    die "ERROR: RTW_CC environmental variable not set\n";
}

$rtw_cflags = $ENV{'RTW_CFLAGS'};
if (($rtw_cflags eq "") && !($rtw_cc =~ /mex -c/i)){
    die "ERROR: RTW_CFLAGS environmental variable not set\n";
}

$rtw_libcmd = $ENV{'RTW_LIBCMD'};
if ($rtw_libcmd eq "") {
    die "ERROR: RTW_LIBCMD environmental variable not set\n";
}


#-------------------------------#
# Load *.c files from directory #
#-------------------------------#

opendir(DIR,$dir) || die "Couldn't open $dir: $!\n";
@dirContents = readdir($dir,DIR);
closedir(DIR);

@cfiles = ();
if ($rtw_cflags =~ /-DINTEGER_CODE=1/) {
    #-------------------------------------------------------------------#
    # For Integer Code Only, only use saturation routines and rt_enab.c #
    #-------------------------------------------------------------------#
    push(@cfiles,"${dir}\\rt_enab.c");
    push(@cfiles,"${dir}\\rt_sat_prod_int8.c");
    push(@cfiles,"${dir}\\rt_sat_prod_int16.c");
    push(@cfiles,"${dir}\\rt_sat_prod_int32.c");
    push(@cfiles,"${dir}\\rt_sat_prod_uint8.c");
    push(@cfiles,"${dir}\\rt_sat_prod_uint16.c");
    push(@cfiles,"${dir}\\rt_sat_prod_uint32.c");
    push(@cfiles,"${dir}\\rt_sat_div_int8.c");
    push(@cfiles,"${dir}\\rt_sat_div_int16.c");
    push(@cfiles,"${dir}\\rt_sat_div_int32.c");
    push(@cfiles,"${dir}\\rt_sat_div_uint8.c");
    push(@cfiles,"${dir}\\rt_sat_div_uint16.c");
    push(@cfiles,"${dir}\\rt_sat_div_uint32.c");
} else {
    foreach $file (@dirContents) {
        if ($file =~ /^.*\.[cC]$/) {
            if (($file =~ /^rt_matrx\.c$/i) && 
            (($rtw_cc =~ /mex -c/i) ||
            ($rtw_cflags =~ /MATLAB_MEX_FILE/)) ) {
                #---------------------------------------#
                # Remove rt_matrx.c for RTW S-Functions #
                #---------------------------------------#
                next;
            } elsif ((($file =~ /^rt_callsys\.c$/i) || 
            ($file =~ /^rt_matrx\.c$/i)) && 
            ($rtw_cflags =~ /-DERT\b/)) {
                #-------------------------------------------------------#
                # Remove rt_callsys.c and rt_matrx.c for RTW Embedded-C #
                #-------------------------------------------------------#
                next;
            } else {
                push(@cfiles,"${dir}\\${file}");
            }
        }
    }
}


if ("@cfiles" eq "") {
    die "ERROR: no .c files found in $dir\n";
}


#--------------------#
# Compile the cfiles #
#--------------------#

foreach $file (@cfiles) {
    local($cmd)   = "$rtw_cc -\@\@RTW_CFLAGS $file";
    local($ofile) = $file;
    $ofile =~ s/.*\\//g;
    $ofile =~ s/\.[cC]/.o/g;

    #
    # Compile
    #
    if (-e $ofile) {
        unlink($ofile);
    }
    print "$cmd\n------------------------------------------------\n";
    system("$cmd");
}

#--------------------#
# Create the library #
#--------------------#

if (-e $lib) {
    unlink($lib);
}

$sep = " ";

$ofileList = "";
foreach $file (@cfiles) {
    local($ofile) = $file;
    $ofile =~ s/.*\\//g;
    $ofile =~ s/\.[cC]/.o/g;

    $ofileList = $ofileList . $sep . $ofile;
}

$cmd = "$rtw_libcmd -q $lib $ofileList ";
print "$cmd\n";
system("$cmd");

# Delete the objects
foreach $file (@cfiles) {
    local ($ofile) = $file;
    $ofile =~ s/.*\\//g;
    $ofile =~ s/\.[cC]/.o/g;
    unlink($ofile);
}

#------#
# Done #
#------#
exit(0);

#-------------------#
# Subroutine: Usage #
#-------------------#
sub Usage {
    die "usage: mklib <directory> <libraryName>\n";
}

# EOF
