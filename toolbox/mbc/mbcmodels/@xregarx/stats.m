function varargout = stats( m, action, Xv, Yv )
%XREGARX/STATS   Statistics for dynamic ARX models
%   STATS(M,'Local')
%   STATS(M,'SSEDF')
%   STATS(M,'Anova')
%   STATS(M,'MSE')
%   [S1,S2] = STATS(M,'Stepwise')
%   STATS(M,'Summary')
%   [S1,S2] = STATS(M,'Validate')
%   STATS(M,'Diagnostics',X,Y)

% STATS
% 
% [out,out2]= stats(m,action,Xv,Yv);
%
% Inputs
%   m      - XREGARX object 
%   action - String specifying required stats
%            'Local'    [R^2 F p]
%            'Stepwise' [[AnovaTable [PRESS,PRESS_rsq,R2]'] , [beta stdB]]
%            'Diagnostics' {cookd leverage r y X studres yhat ci_hi ci_lo}
%   Xv     - (Optional) Validation X data (only used if action=='diagnostics')
%   Yv     - (Optional) Validation Y data

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:45:40 $

if nargin < 2,
    error( 'You must specify the statistics you require' )
    
elseif nargin < 3,
    [varargout{1:nargout}] = stats( m.StaticModel, action );
    
elseif nargin == 3,
    error( 'When specifying inputs you must also give outputs' )
    
else    
   
   yhat= eval(m,Xv);
   rmse= sqrt( sum((Yv-yhat).^2)/(length(Yv)-size(m,1)) );
   s= [length(Yv),size(m,1),get(m,'boxcox'),rmse];
   varargout={s,[]};
%    XX = expanddata( Xv, Yv, m.DynamicOrder, m.Delay );
%    [varargout{1:nargout}] = stats( m.StaticModel, action, XX, Yv );
    
end

if ~ismember( lower( action ), { 'local', 'ssedf', 'anova', 'mse', ...
            'stepwise', 'summary', 'validate', 'diagnostics' } ),
    warning( sprintf( 'New stats action = ''%s''.', action ) );
end

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|
