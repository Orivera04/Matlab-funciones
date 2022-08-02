function [m,OK]= InitModel(m,x,y,Wc,IsCoded,doRinvCalc);
%XREGARX/INITMODEL Model Initialization for ARX models
%
%  [M,OK] = INITMODEL(M,X,Y,...)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.1 $    $Date: 2004/02/09 07:44:43 $ 

if nargin<4
    Wc= [];
end
if nargin<5
    IsCoded= true;
end
if nargin<6
    doRinvCalc= true;
end

yc= double(y);
if ~IsCoded
    [x,y] = checkdata(m,x,double(y));
    if m.DynamicOrder(end),
        % need to code y data
        yc = code( m.StaticModel, double(y), nfactors( m.StaticModel ) );
    end
end

% expand to static model inputs
xx = expanddata( x, double( y ), m.DynamicOrder, m.Delay );
% initialize static model
[sm, OK] = InitModel( m.StaticModel, xx, yc, Wc, IsCoded, doRinvCalc);

if OK,
    m.StaticModel = sm;
end
