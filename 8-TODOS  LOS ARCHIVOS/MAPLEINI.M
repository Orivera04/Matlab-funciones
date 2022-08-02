function mapleinit
%MAPLEINIT Initialize MAPLE.
%	MAPLEINIT is called by MAPLEMEX to initialize the Maple Kernel.
%	MAPLEINIT determines the path to the directory containing the Maple
%	Library, loads the linear algebra package, initializes Digits,
%	and establishes several aliases.
%
%	This M-file, "symbolic/mapleinit.m", may be modified to access
%	a copy of the Maple V, Release 2, Library available elsewhere.

%	Copyright (c) 1993-94 by The MathWorks, Inc.
%	$Revision: 1.13 $  $Date: 1994/05/23 16:13:49 $

% If you already have a copy of the Library for Maple V, Release 2,
% you may modify the following code to set "maplelib" to the full
% path name of that library, e.g. maplelib = '/usr/local/Maple/lib',
% or maplelib = 'C:MAPLE\LIB', or maplelib = 'MyDisk:Maple:Lib'.
% You can then delete the copy of the Maple Library that is distributed
% with MATLAB.

already_have_Maple = 0;
if (already_have_Maple)
   maplelib = '...';
else
%  Find 'symbolic' or 'symbolic_lib' in the MATLAB path.
%  Append '_lib' if necessary.
   p = path;
   k = min(findstr(p,'general'));
   pathsep = p(k+7);         % Path separator, ':', ';' or ','.
   dirsep = p(k-1);          % Directory separator, '/', '\' or ':'.
   p = [pathsep p pathsep];
   k = findstr(lower(p),['symbolic' dirsep 'lib' pathsep]);
   if length(k) == 1
      lib = [];
   else
      k = findstr(lower(p),['toolbox' dirsep 'symbolic' pathsep]);
      if length(k) ~= 1
         error('MATLAB path should have exactly one symbolic toolbox.')
      end
      lib = [dirsep 'lib'];
   end
   c = find(p == pathsep);
   i = max(c(c<k))+1;
   j = min(c(c>k))-1;
   maplelib = [p(i:j) lib];
end

% Inform Maple of path to its library.
maplemex(maplelib,0);

% Load linear algebra package, load library routines, and set digits.
maplemex('with(linalg):');
maplemex('readlib(ifactor):');
maplemex('readlib(laplace):');
maplemex('readlib(fourier):');
maplemex('readlib(ztrans):');
maplemex('Digits := 16;');

% Establish aliases.
maplemex('alias(I=I, i=sqrt(-1), pi=Pi);');
maplemex('alias(log=ln, inf=infinity, Inf=infinity, fix=trunc);');
maplemex('alias(asin=arcsin, acos=arccos, atan=arctan);');
maplemex('alias(asinh=arcsinh, acosh=arccosh, atanh=arctanh);');
maplemex('alias(acsc=arccsc, asec=arcsec, acot=arccot);');
maplemex('alias(acsch=arccsch, asech=arcsech, acoth=arccoth);');
maplemex('alias(eye=&*());');

% Turn off "bytes used" and garbage collection messages.
maplemex('words(0);');
maplemex('gc(0);');
