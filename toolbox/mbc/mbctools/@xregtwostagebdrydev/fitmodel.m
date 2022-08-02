function [bd, ok] = fitmodel( bd, action, X )
%FITMODEL Controls the constraint model fitting process
%
%  [BDEV, OK] = FITMODEL(BDEV,ACTION,X) where ACTION must be one of
%  'SpecialPoints', 'BdryPoints', 'FitModel', 'All'.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.6.3 $    $Date: 2004/04/04 03:32:42 $ 


%  The only significant difference between this method and the fitmodel
%  method for xregbdrydev is that the fitmodel call on the constraint
%  object is replaced by a call to fitlocal and a call to fitglobal.

if nargin < 3,
    p = Parent( bd );
    if ~isempty( p ),
        G = p.getdata( 'Global' );
        L = p.getdata( 'Local' );
    else
        error( 'no response data' );
    end   
end

action = lower( action );
doSpecialPoints = isequal( action, 'all' ) || isequal( action, 'specialpoints' );
doBdryPoints    = isequal( action, 'all' ) || isequal( action, 'bdrypoints' );
doModelFit      = isequal( action, 'all' ) || isequal( action, 'fitmodel' );

ok = true;

% if ok && doSpecialPoints,
%     [bd.xregbdrydev, ok] = fitmodel( bd.xregbdrydev, 'SpecialPoints', X );
% end
% 
% if ok && doBdryPoints,
%     [bd.xregbdrydev, ok] = fitmodel( bd.xregbdrydev, 'BdryPoints', X );
% end

if ok>0 && doModelFit
    c = getconstraint(   bd );
    bp = getbdrypoints( bd );
    params = fitlocal( c, L );
    [c, ok] = fitglobal( c, G, params );
    if ok>0 
        bd.LocalParameters = params;
        bd = setmodel( bd, c );
    end
end

xregpointer( bd );
