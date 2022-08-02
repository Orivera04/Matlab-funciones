function [b,m,x,c]=mmbuiltin(arg)
%MMBUILTIN Built-in Functions. (MM)
% [B,M,X,C]=MMBUILTIN returns cell arrays of strings containing
% the names of built-in functions in B, M-file functions in M,  
% MEX-file functions in X, and classes in C.
% Functions in toolboxes are not included.
%
% [...]=MMBUILTIN('-nodemos') ignores all functions in the demos
% subdirectory, i.e., functions that support MATLAB demonstrations.
%
% Use WHAT('toolboxdirectory') to explore functions in a specific
% toolbox directory.

% D.C. Hanselman, University of Maine, Orono ME 04469
% 3/25/00, 4/4/00, 11/29/00
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

b=cell(0);
getM=nargout>1;
getX=nargout>2;
getC=nargout>3;
m=cell(0);
x=cell(0);
c=cell(0); 
mld=fullfile(matlabroot,'toolbox','matlab',''); % path to matlab subdirectory
d=dir(mld);                         % get directory info in a structure
d=d(cat(1,d.isdir));                % take only those elements that are directories
[dirs{1:length(d)}]=deal(d.name);   % convert directory names to a cell array
dirs(strncmp(dirs,'.',1))=[];       % throw out . and .. directories
if nargin==1 & ischar(arg) & strncmpi(arg,'-n',2)
   dirs(strncmpi(dirs,'demos',5))=[];
end
mld=[mld filesep];                  % path string to matlab subdirectory

for i=1:length(dirs)                % loop over all directories found
   w=what([mld dirs{i}]);           % structure of directory contents
   for j=1:length(w.m)              % loop over M-files found
      mfile=w.m{j}(1:end-2);        % grab j-th file, delete .m at end
      if exist(mfile,'builtin')==5  % if builtin add to list
         b=[b;{mfile}];
      elseif getM & exist(mfile,'file')==2
         m=[m;{mfile}];
      end
   end
   if getX
      x=[x;w.mex(:)];
   end
   if getC
      c=[c;w.classes(:)];
   end
end
nbi={'and','colon','eq','ge','gt','le','lt','ne','paren',...
      'not','or','power','slash','ans','arith','function_handle',...
      'helpinfo','layout','lists','matrix_element_separators',...
      'memory','partialpath','precedence','punct','relop','strings',...
      'vissuite','fileformats','change_notification',...
      'change_notification_advanced','Contents','Readme'};
b=setdiff(b,nbi)';   % eliminate phonies and alphabetize
if getM              % eliminate phonies and alphabetize
   m=setdiff(m,nbi)';
end
if getX
   nx=length(mexext)+1;
   for i=1:length(x) % strip off .MEX extension
      x{i}=x{i}(1:end-nx);
   end
   x=sort(x);        % alphabetize
end
if getC              % eliminate redundancies and alphabetize
   c=unique(c);
end