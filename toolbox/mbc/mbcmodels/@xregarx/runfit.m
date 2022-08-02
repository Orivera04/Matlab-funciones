function [m, ok] = runfit( m, x, y, varargin )
%RUNFIT Run the fitting algorithm on the embedded static model
%
%  [M, OK] = RUNFIT(M,X,Y)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.4 $  $Date: 2004/04/04 03:29:55 $

sm= m.StaticModel;
yord= m.DynamicOrder(end);
if yord
    % work out scaling for the ouput terms in the static model
    r= [min(y) max(y)];
    if r(2)-r(1)< eps
        % handle constant inputs gracefully
        r(2)= r(1) + 1;
    end
    [Bnds,g,Tgt]= getcode(sm);
    Bnds(end-yord+1:end,1)= r(1);
    Bnds(end-yord+1:end,2)= r(2);
    sm= setcode(sm,Bnds,g,Tgt);
    % scale outputs (use last input of static model to do coding)
    yc= code(sm,y,size(Bnds,1));
else
    yc= y;
end

% fitmodel on StaticModel will code y values so we need to use natural
% values for y
xx = expanddata( x, y, m.DynamicOrder, m.Delay );

[sm, ok] = fitmodel( sm, xx, yc );
if ok>0
    % set initial condtions
    md = max( m.DynamicOrder + m.Delay ) - 1;
    if md>=1
        y0 = repmat(double(y(1)),md,1);
        sm = set( sm, 'InitialConditions', y0 );
    end

    % set the static model
    m.StaticModel = sm;
end
