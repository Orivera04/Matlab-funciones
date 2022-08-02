function [xslice,yslice,zslice]=slices(f,args,nargs)
%SLICES  Function used by plot.

%Copyright (c) 2001-04-22, B. Rasmus Anthin

f=struct(f);
xslice=(f.x(1)+f.x(2))/2;
yslice=(f.y(1)+f.y(2))/2;
zslice=(f.z(1)+f.z(2))/2;
if nargs>0
   xslice=args{1};
end
if nargs>1
   yslice=args{2};
end
if nargs>2
   zslice=args{3};
end