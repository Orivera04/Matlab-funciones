function supportspev = pevcheck( m )
%PEVCHECK Returns true if model supports calculation of PEV
% 
%  SUPPORTSPEV = PEVCHECK( MODEL );
%
%  See also XREGSTATSMODEL/PEV, XREGSTATSMODEL/PEVGRID

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:57:56 $

supportspev = pevcheck( m.mvModel );