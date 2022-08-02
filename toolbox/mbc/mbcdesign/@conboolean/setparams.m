function [c, msg] = setparams( c, varargin )
%SETPARAMS  Set constraint parameters
%
%  C=  SETPARAMS(C,PARAMLIST)  where PARAMLIST is a list of parameter-value
%  pairs.  Valid parameters for the CONBOOLEAN object are : 
%      Constraints: any CONBASE or derivative object or cell array of those
%                   objects
%               Op: 'and', 'or', 'xor', 'none'
%              Not: logical


%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:57:36 $ 

msg = {};

for n = 1:2:length(varargin),
    val = varargin{n+1};
    switch lower( varargin{n} )
        case 'constraints',
            if isa( val, 'conbase' ) && getsize( val ) == getsize( c ),
                c.Constraints = { val };
            elseif isa( val, 'cell' ),
                ok = 1;
                for i = 1:length( val ),
                    ok = ok && isa( val{i}, 'conbase' ) ...
                        && getsize( val{i} ) == getsize( c );
                end
                if ~ok,
                    msg(end+1) ={ 'Invalid constraint object' };
                else
                    c.Constraints = val;
                end    
            else
                msg(end+1) ={ 'Invalid constraint object' };
            end
        case 'op',
            if any( strcmpi( {'and', 'or', 'xor', 'none'}, val ) ),
                c.Op = val;
            else
                msg(end+1) ={ 'Op must be one of ''and'', ''or'', ''xor'', ''none''' };
            end
        case 'not',
            c.Not = logical( val );
        otherwise
            [c.conbase, tmp_msg] = setparams( c.conbase, varargin{n}, val );
            msg = { msg{:}, tmp_msg{:} };
    end
end
