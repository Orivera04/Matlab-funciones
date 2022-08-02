function m = completecopymodel( m )
%XREGARX/COMPLETECOPYMODEL   Model copy completion for XREGARX
%   COMPLETECOPYMODEL(M) performs model specific copy actions on the new 
%   XREGARX model M.
%
%   See also XREGMODEL/COPYMODEL, XREGMODEL/COMPLETECOPYMODEL

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:44:47 $

m = resetstaticmodel( m );

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|
