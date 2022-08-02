function cout=char(mm,hg)
% CHAR  String representation of xregmulti
%
%  STR=CHAR(M) returns a string representation of the 
%  xregmulti object
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:53:57 $

% Created 25/5/2000

c={'      Model class:          Weight: '};

% position = 4 chars
% class name field = 20 chars
% weight = 8 chars

% gaps of 2 chars are inserted between fields

% total length = 36 chars
for n=1:length(mm.models)
   cls=name(mm.models{n});
   % put cls in 20 character char array
   if length(cls)<20
      cls(end+1:20)= ' ';
   elseif length(cls)>20
      cls=cls(1:20);
   end
   c=[c {['(' sprintf('%02d',n) ')  ' cls '  ' sprintf('%8.7f',mm.weights(n))]}];
end
cout=char(c);