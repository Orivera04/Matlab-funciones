function names=str2names(stringin,delimiter);
%STR2NAMES         Convert string of names separated by spaces into individual strings
% names = str2names(stringin)
%
% Input
%	stringin:		a string (single line) containing words separated by spaces
%   delimiter:      (optional).  A delimiter other than spaces (such as a
%   comma)
%
% Output
%   names:			cell array with contents = strings containing each name

% (c) The MathWorks 2001
% Scott Hirsch
% shirsch@mathworks.com

% Input Argument checking
if nargin==1            % Default is space delimited
    delimiter = ' ';
end;

%remove leading spaces
stringin=removeleadingspaces(stringin);

%remove trailing spaces
stringin=removetrailingspaces(stringin);

ind=1:length(stringin);	
spaces=findstr(stringin,delimiter);		%index to spaces
letters=setdiff(ind,spaces);		%index to letters
namestring=stringin(letters);		%a string containing all names smooshed together

diffl=diff(letters);
nnames=sum(diffl>1)+1;
nameends=find(diffl>1);
namestarts=[1 nameends+1];
nameends=[nameends length(namestring)];


names={};
for ii=1:nnames
   names{ii}=namestring(namestarts(ii):nameends(ii));
end;
