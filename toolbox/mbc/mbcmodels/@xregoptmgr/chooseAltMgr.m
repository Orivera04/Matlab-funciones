function om= chooseAltMgr(om,val,varargin);
%CHOOSEALTMGR

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:56:40 $

alts= om.Alternatives;
om= feval(om.Alternatives{val},varargin{:});
om.Alternatives= alts;
