function nameout = uniquename( root, namein )
%UNIQUENAME Find a name that is not already in use on the tree
%
%  NAME = UNIQUENAME(ROOT,NAME) is unique form of NAME in the tree that has
%  ROOT as its root node.
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 08:13:43 $ 

% namein is the suggested name
% if necessary, nameout will contain the name_X

if nargin < 2,
    namein = name( root );
end

% get all names in design tree
namesused = i_allnames( root );
% Check for usage of name
if any( strcmp( namein, namesused ) ),
   % loop over _X until an unused one is found
   ok = 0;
   n = 0;
   while ~ok
      n=n+1;
      % append _X
      nameout = sprintf( '%s_%d ', namein, n );
      % check newname
      if ~any( strcmp( nameout, namesused ) ),
         ok = 1;
      end
   end
else
   nameout = namein;
end
return

%---------------------------------|--------------------------------------------|
function names = i_allnames( root )
c = allchildren( root );
if isempty( c ),
    childnames = {};
else
    childnames = pveceval( c, 'name' );
end

names = { name( root ), childnames{:} };
return

%---------------------------------|--------------------------------------------|
% EOF
%---------------------------------|--------------------------------------------|
