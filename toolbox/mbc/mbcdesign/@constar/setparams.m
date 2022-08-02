function [c,msg]=setparams(c,varargin)
%SETPARAMS  Set constraint parameters
%
%  C=SETPARAMS(C,PARAMLIST)  where PARAMLIST is a list
%  of parameter-value pairs.  Valid parameters for the
%  constar object are :
%         Model: 
%        Center: 
%     Transform: 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:59:11 $ 

msg={};

for n=1:2:length(varargin)
    val=varargin{n+1};
    switch lower(varargin{n})
        case 'model'
            if ~isa( val, 'xreginterprbf' ),
                msg(end+1) ={ 'Model must be an XREGINTERPRBF' };
            elseif nfactors( val ) ~= getsize( c ),
                msg(end+1) ={ 'Model has wrong number of factors' };
            else
                c.Model = val;
            end
        case 'center'
            if ~isnumeric( val ),
                msg(end+1) ={ 'Center vector must be numeric' };
            elseif length( val(:) ) ~= length( c.Center ),
                msg(end+1) ={ 'Center vector is invalid size' };
            else
                c.Center = val(:)';
            end
        case 'transform'
            transform_list = transform_radius( 'list' );
            if any( strcmpi( val, transform_list ) ),
                c.Transform = val;
            else
                msg(end+1) ={ 'Invalid transform' };
            end
        otherwise
            [c.conbase, tmp_msg] = setparams( c.conbase, varargin{n}, val );
            msg = { msg{:}, tmp_msg{:} };
    end
end
