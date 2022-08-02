% Make mpgwrite.dll on the PC.
%
mex -DWIN32 mpgwrite.c mfwddct.c postdct.c huff.c bitio.c mheaders.c iframe.c ...
pframe.c bframe.c psearch.c bsearch.c block.c mpeg.c subsampl.c jrevdct.c frame.c fsize.c
