function rsums(f)
%RSUMS	Interactive evaluation of Riemann sums.
%	RSUMS(f) approximates the integral of f(x) by Riemann sums.
%	RSUMS is usually called with the command line form, eg.
%	      rsums exp(-5*x^2)

%	Copyright (c) 1993-94 by The MathWorks, Inc.
%	$Revision: 1.5 $  $Date: 1994/01/24 22:37:09 $

clf reset
axes('pos',[.18 .16 .77 .70])
f = symvars(f,'x',symvar(f));
n = 10;
rsummer(f,n)
uicontrol('units','normal','style','slider','pos',[.18 .03 .70 .03],...
   'min',2,'max',256,'value',n,'userdata',f,...
   'callback',['s = get(gcf,''child''); s=s(1); f=get(s,''userdata''); '...
   'n = round(get(s,''value'')); rsummer(f,n)']);
