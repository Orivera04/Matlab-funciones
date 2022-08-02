function LM= localmod(LM,types);
% LOCALMOD local model constructor
%
% The localmod class is an attachment to model objects to allow 
% pooled estimates of multiple data sets with pooled covariance model
% Response features are also managed by the localmod object

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:39:20 $


if nargin==1 & isa(LM,'struct')
   %ver= LM.Version;
   % while ver < 2
   %   switch ver
   %   case {0,1}
   %      ver = 2
         Values= LM.Values;
         Type= LM.Type;
         delG= LM.delG;
         if isfield(LM,'Limits')
            Limits= LM.Limits;
         else
            Limits=repmat([-Inf;Inf],1,length(Values));
         end
         DatumType= LM.DatumType;
    %  end % switch ver
   % end % while 
elseif nargin== 1 & isa(LM,'localmod')
   return
else 
   Values= [];
   Type= struct('Display',{},...
      'Function',{},...
      'delG',{},...
      'Name',{},...
      'IsDatum',{},...
		'index',{},...
		'IsLinear',{});
   delG= [];
   Limits=zeros(2,0);
   DatumType=0;
   
   
end
FitOpts= struct('TolSigma',1e-3,...
   'TolParams',1e-3,...
   'TolCov',1e-3,...
   'MaxIter',10,...
   'lsqnl',[],...
   'DispHndl',[]);
LM= struct('Values',Values,...
   'Type',Type,...
   'delG',delG,...
   'DatumType',DatumType,...
   'Limits',Limits,...
   'covmodel',xregcovariance,...
   'FitOptions',FitOpts,...
   'Version',2);

LM= class(LM,'localmod');
