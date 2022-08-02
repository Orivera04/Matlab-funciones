#If .mexrc.sh has not been modified for your ANSI compiler, uncomment
# the following two lines if you use GCC. Modify for you ownr ANSI
# compiler if different:
#MCC = CC=gcc
#MCFLAGS = CFLAGS=-ansi
#
# Copyright 1994, The MathWorks, Inc.

mpgread:
	mex $(MCC) $(MCFLAGS) mpgwrite.c mfwddct.c \
		postdct.c huff.c bitio.c mheaders.c iframe.c \
		pframe.c bframe.c psearch.c bsearch.c block.c \
		mpeg.c subsampl.c jrevdct.c frame.c fsize.c

