function varargout=info(m,varargin)
% MODEL/INFO
%
% [Name,Units,Factors,XUnits,Comments]= info(m);
% m= info(m,Name,Units,Factors,XUnits,Comments); 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:52:14 $
   
   if nargin==1
      varargout{1}= {m.Yinfo.Name,m.Yinfo.Units,m.Xinfo.Symbols,m.Xinfo.Units,m.Comments};
   else
      [m.Yinfo.Name,...
            m.Yinfo.Units,...
            m.Xinfo.Symbols,...
            m.Xinfo.Units,...
            m.Comments]= deal(varargin{:});
   varargout{1}=m;
end