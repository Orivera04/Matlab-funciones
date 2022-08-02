function [c,msg] = constar( sz, varargin )
%CONSTAR   Star shapped constraint object
%   [C,Msg] = CONSTAR(n,<ParameterList>) where n is the number of factors 
%   <ParameterList> is a possibly empty list of parameter-value pairs.
%
%   CONSTAR objects constrain points according an rbf model of a star shaped 
%   region.
%
%   See also: SETPARAMS.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.1 $    $Date: 2004/02/09 06:57:40 $ 

if ~nargin % no input arguments
    sz=2;
end

if isa( sz, 'constar' ),
    c = sz;
else
    if isstruct( sz ), 
        if sz.Version == 4,
            c = sz;
            parent = sz.conbase;
            c = rmfield( c, 'conbase' );
            spo = getspecialpointoptions( parent );
            bpo = getbdrypointoptions(    parent );
        else
            [c, bpo, spo] = i_update( sz );
            parent = conbase( numel( c.Center ) );
        end
    else
        parent = conbase( sz );
        c.Version = 4;
        c.Model = xreginterprbf( 'nfactors', sz );
        c.Center = zeros( 1, sz );
        c.Transform = 'None';
        spo = 'LeastSquares';
        bpo = [];
    end
    c = class( c, 'constar', parent );
    if isempty( bpo ),
        bpo = optmgr_interior( c );
    end
    c = setspecialpointoptions( c, spo );
    c = setbdrypointoptions(    c, bpo );
end

if length(varargin)
    [c,msg] = setparams(c,varargin{:});
else
    msg={};   
end

%------------------------------------------------------------------------------|
function [new, spo, bpo] = i_update( old )

new.Version = 4;

new.Model = old.BoundaryModel;
new.Center = old.Center;
new.Transform = get( old.OptionsManger, 'Transform' );

spo = get( old.OptionsManger, 'CenterAlg' );

bpo = get( old.OptionsManger, 'Classification' );
if isfield( old.Store, 'DilationRadius' );
    r = old.Store.DilationRadius;
else,
    r = -1;
end
bpo = AddOption( om, 'ActualDilationRadius', ...
    -1, {'numeric', [-Inf,Inf]}, '', 0 );

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|
