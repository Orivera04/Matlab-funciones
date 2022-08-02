function nameout=fixname(name)
%FIXNAME           Make any necessary changes to NAME so that it is a valid MATLAB variable name.
%  nameout=fixname(name)
%
% FIXNAME looks at name to see if it is a valid MATLAB variable name. If not, it
%  makes any changes necessary. Leading numbers are stuck at the end.
%
% Ex. name='21hello.3*bg'
%     nameout='hello3bg21'
%
%INPUT:
%   name:			String which may need fixin'
%                May be a cell array of strings
%
%OUTPUT:
%   nameout:		String containing fixed name
%                Empty if no valid name can be constructed from name
% Scott Hirsch
% 5/99

%Rules for MATLAB variable names: 
% First char must be letter
% Contains only: letters, numbers, underscore

if nargin<1
   name=input('Please enter the name which needs fixin''');
end;

if ~isempty(str2num(name))
    nameout = ['a' name];
%    error('I can''t convert a number into a valid MATLAB string');
   return
end;

%iscll=iscell(name);

letters='abcdefghijklmnopqrstuvwxyz';
LETTERS=upper(letters);
numbers='1234567890';
validchar=[letters LETTERS numbers '_'];

ind=[];
for ii=1:length(name)
   s=findstr(name(ii),validchar);
   if ~isempty(s)
      ind=[ind ii];
   end;
end;

if isempty(ind)
   nameout='';
else
   
   
   nameout=name(ind);
   ind=1:length(nameout);
   
   %now, take any leading numbers and put them at the end
   
   s=-1;
   ii=0;
   while ~isempty(s)&isreal(s)			%isreal gets rid of i, j problem
      s=str2num(nameout(ii+1));
      ii=ii+1;
   end;   
   
   if ii>1
      nameout=[nameout(ii:end) nameout(1:ii-1)];
   end;
   
end;
