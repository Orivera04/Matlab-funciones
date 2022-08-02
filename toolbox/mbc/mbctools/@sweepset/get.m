function Values= get(A,Properties);
% SWEEPSET/GET overloaded get function for sweepset
%   Values= get(A,Properties);
%
% Supported Properties
%   Variable Properties
%      'ID','FORMAT','NAME','DESCRIPTION',
%      'UNITS','TYPE','STATUS','NOTES','MIN','MAX'
% Sweepset Header Properties
%      'NUMBER','DATE','COMMENT'
%
% The resulting Values are returned as a cell array

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 08:06:17 $




Valid_VarDescript   = {'ID','FORMAT','NAME','DESCRIPTION','UNITS','TYPE','STATUS','NOTES','MIN','MAX'};
vfields= fieldnames(A.var);
Valid_MapDescript   = {'NUMBER','DATE','COMMENT','FILENAME'};
mfields= {'number','datetime','comment','filename'};

ischar=0;
if isa(Properties,'char')
   ischar=1;
   Properties={Properties};
end
Values= cell(1,length(Properties));

for k=1:length(Properties)
   Property= Properties{k};
   mind= strmatch(upper(Property),Valid_MapDescript);
   vind= strmatch(upper(Property),Valid_VarDescript);
   if all(size(mind))==1
      fstr= ['Values{k} = A.',mfields{mind},';'];
      eval(fstr)
   elseif all(size(vind))==1
      fstr= ['Values{k} = {A.var.',vfields{vind},'}'';'];
      eval(fstr)
   else
      error('Invalid Property')
   end
end

if all(size(Values))==1 & ischar
   Values= Values{1};
end

