function [bd, ok] = fitmodel( bd, action, X )
%FITMODEL Fit the boundary model contained in this development node
%
%  [BDEV, OK] = FITMODEL(BDEV,ACTION,X) wherre ACTION must be one of
%  'SpecialPoints', 'BdryPoints', 'FitModel', 'All'.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.2 $    $Date: 2004/04/04 03:32:09 $

if nargin < 3,
    X = double( getdata( bd ) );
end

action = lower( action );
doSpecialPoints = isequal( action, 'all' ) || isequal( action, 'specialpoints' );
doBdryPoints    = isequal( action, 'all' ) || isequal( action, 'bdrypoints' );
doModelFit      = isequal( action, 'all' ) || isequal( action, 'fitmodel' );

m   = bd.Model;
sp  = bd.SpecialPoints;
fsp = bd.LockedSpecialPoints;

if doSpecialPoints
    [m, sp] = getspecialpoints( m, X, sp, fsp );
    bd.Model = m;
    bd.SpecialPoints = sp;
    bd.LockedSpecialPoints = fsp;
    ok = true;
end

if doBdryPoints,
    [m, bp] = getboundarypoints( m, X );
    bd.Model = m;
    bd.BdryPoints = bp;
    ok = true;
else
    bp = bd.BdryPoints;
end

if doModelFit,
    [m, ok] = fitmodel( m, X(bp,:) );
    if ok>0
        bd.Model = m;
    end
end

xregpointer( bd );
