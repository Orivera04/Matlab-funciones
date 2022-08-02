function c=setsize(c,sz)
%SETSIZE  Reset number of factors for object
%
%   C=SETSIZE(C,NF)  sets C to work with NF factors
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:58:12 $

if sz < getsize( c ),
  c = conellipsoid( sz );  
else
    c.conbase = setsize( c.conbase, sz );
end

% sznow=getsize(c);
% 
% if sz<sznow
%    c.xc=c.xc(1:sz);
%    c.W=c.W(1:sz,1:sz);
% elseif sz>sznow
%    c.xc=[c.xc zeros(1,sz-sznow)];
%    c.W(:,end+1:sz)=0;
%    c.W(end+1:sz,:)=0;
%    c.W(sznow+1:sz,sznow+1:sz)=eye(sz-sznow);
% end
