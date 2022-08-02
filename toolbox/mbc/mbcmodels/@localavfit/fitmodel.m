function [L,Bhat,Wchat,OK]= fitmodel(L,X,Y,B,Wc);
% FITMODEL main fit model method for localavfit models
%
% [L,Bhat,Wchat,OK]= fitmodel(L,X,Y,B,Wc);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.3 $  $Date: 2004/02/09 07:37:40 $


ws= warning;
warning('off');

Ns= size(Y,3);
Np= size(L,1);

% localmod method for cleaning data and doing ytrans
[Xf,Yf,OK,BadIndex]= checkdata(L,X,Y);
if isTBS(L)
   % need to initialise model with raw data
   Yraw= Y(~BadIndex);
else
   % use possible transformed data
   Yraw= Yf;
end

Bhat= B;
B= B(:,OK);

Wchat= Wc;
Wc= Wc(OK);

Bok= all(isfinite(B));

if any(~Bok)
   %obtain initial estimates of parameters
   
   InitSweeps= find( ~Bok );
   NsOK= size(Yf,3);
   
end

OKnow=[];
if any(OK)
   % now do fit
   [L.model,OKnow]= fitmodel(L.model,Xf,Yf);
end


warning(ws);

% update parameters and weights
if isempty(Wc)
   Wchat= Wc;
else
   Wchat(OK)= Wc;
end

OK(OK)= OKnow;
Bhat= zeros(size(L,1),length(OK));
Bhat(:,OK)=repmat(double(L),1,sum(OK));

% set bad sweep parameters to NaN/[]
Bhat(:,~OK)  = NaN;
if ~all(OK)
   [Wchat{~OK}] = deal([]);
end

