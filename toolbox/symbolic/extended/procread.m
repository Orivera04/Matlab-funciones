function s = procread(filename)
%PROCREAD Install a Maple procedure.
%   PROCREAD(FILENAME) reads the specified file, which contains 
%   the source text for a Maple procedure. PROCREAD deletes any
%   comments and newline characters, and then sends the resulting 
%   string to Maple. The Extended Symbolic Toolbox is required to
%   use PROCREAD.
%
%   Example:
%      Suppose the file "check.src" contains the following
%      source text for a Maple procedure.
%
%         check := proc(A)
%            #   check(A) computes A*inverse(A)
%            local X;
%            X := inverse(A):
%            evalm(A &* X);
%         end;
%
%      Then the statement
%
%         procread('check.src')
%
%      installs the procedure.  It can be accessed with 
%
%         maple('check',magic(3))
%
%      or
%
%         maple('check',vpa(magic(3)))
%
%   See also MAPLE.

%   Copyright 1993-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $  $Date: 2004/04/16 22:23:23 $

% Open the file and read the text.

f = fopen(filename);
if f < 0
   error('symbolic:procread:errmsg1','Could not open %s',filename)
end
s = fread(f)';

% Delete comments and newlines.

e = find(s==10);
for j = fliplr(find(s=='#'))
   k = min(e(e>j));
   s(j:k) = [];
end
e = find(s==10);
s(e) = ' '*ones(size(e));

% Send the string to Maple.

s = setstr(s);
s = maple(s);

% Close the file.
fclose(f);
