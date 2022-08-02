function out = symbmatmake(vn,m,n)
% OUT = SYMBMATMAKE(VN,M,N)
% OUT is a symbolic marix of vector of dimension M,N.
% Elements have name VN (default 'x') and are subscripted according to position
% M has default 2
% N has default 1
% SYMMATMAKE('a',2,3) returns
% [ a11, a12, a13]
% [ a21, a22, a23]

%%%%% © Natural Environment Research Council, (2002)
%%%%% Written by R.C.A. Hindmarsh.

% This program is free software; you can redistribute it and/or
% modify it under the terms of the GNU General Public License
% as published by the Free Software Foundation; either version 2
% of the License, or (at your option) any later version.

% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.

% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

% Set up defaults
if  ~nargin,
   vn = 'x';
end
if nargin < 2
   m = 2;
end
if nargin < 3
   n = 1;
end
% Create symbolic value
if ~strcmp(class(vn),'sym')
   eval(['syms ' vn])
end
% Decide whether to concatenate horizontally or vertically
if m > 1
   fn = 'vertcat';
   morn = m;
else
   fn = 'horzcat';
   morn = n;
end
% Do the concatentation. Recursive calls if concatenating vectors to make
% matrix
for ii = 1:morn
   if m==1 | n == 1
       eval(['syms ', vn, num2str(ii)])
   else % Create matrix
       evstring = [vn, num2str(ii),' = symbmatmake(''',vn,num2str(ii),''',',...
             num2str(1),',',num2str(n),');'];
       eval(evstring)
   end
	if ii == 1
     eval([vn, ' = [',vn, num2str(ii),'];']);;
	else
     eval([vn, ' = ',fn,'(',vn,',',vn, num2str(ii),');']);
	end
end
eval(['out = ',vn,';']);
