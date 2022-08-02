all: bspeval.mexlx bspderiv.mexlx bspkntins.mexlx bspdegelev.mexlx

bspeval.mexlx: bspeval.c basisfun.c findspan.c mexmat.c
	mex bspeval.c basisfun.c findspan.c mexmat.c

bspderiv.mexlx: bspderiv.c mexmat.c
	mex bspderiv.c mexmat.c

bspkntins.mexlx: bspkntins.c findspan.c mexmat.c
	mex bspkntins.c findspan.c mexmat.c

bspdegelev.mexlx: bspdegelev.c mexmat.c
	mex bspdegelev.c mexmat.c

clean:
	rm -f bspeval.mexlx bspderiv.mexlx bspkntins.mexlx bspdegelev.mexlx