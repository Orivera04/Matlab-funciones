function y=ftable(fname, lowerb,upperb)
intg=fgauss(fname,lowerb,upperb,16);
ints=simp1(fname,lowerb,upperb,2048);
intq=quad8(fname,lowerb,upperb,.00005);
fprintf(fname);
fprintf('%19.8e%18.8e%18.8e\n',intg,ints,intq);