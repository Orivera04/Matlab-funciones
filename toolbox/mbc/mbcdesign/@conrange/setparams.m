function [c,msg]=setparams(c,varargin)
%SETPARAMS  Set constraint parameters
%
%  C=SETPARAMS(C,PARAMLIST)  where PARAMLIST is a list
%  of parameter-value pairs.  Valid parameters for the
%  CONRANGE object are :
%        Center: 
%     HalfWidth: 
%
%  C=SETPARAMS(C,B) allows for all the parameters to be passed in as a
%  single vector, B. In this vector, the first nfactors elements are the
%  center and next nfactors elements are the halfwidth.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:58:51 $ 



msg={};
if nargin == 2,
    % C = SETPARAMS(C,B)
    beta = varargin{1};
    beta = beta(:);
    d = sum( variables( c ) );
    
    if size( beta, 1 ) ~= numfeats( c ),
        msg{end+1} = { 'Paramter vector B is invalid size' };
    else
        % set model parameters
        center = beta(1:d)';
        halfwidth = beta(d+1:end)';
        if ~all( halfwidth >= 0 ),
            msg(end+1) ={ 'HalfWidth''s must be non-negative' };
        else
            c.Center = center;
            c.HalfWidth = halfwidth;
        end
    end
else
    % C = SETPARAMS(C,PARAMLIST) 
    for n=1:2:length(varargin)
        val=varargin{n+1};
        switch lower(varargin{n})
            case 'center'
                if ~isnumeric( val ),
                    msg(end+1) ={ 'Center vector must be numeric' };
                elseif length( val(:) ) ~= length( c.Center ),
                    msg(end+1) ={ 'Center vector is invalid size' };
                else
                    c.Center = val(:)';
                end
            case 'halfwidth'
                if ~isnumeric( val ),
                    msg(end+1) ={ 'HalfWidth vector must be numeric' };
                elseif length( val(:) ) ~= length( c.HalfWidth ),
                    msg(end+1) ={ 'HalfWidth vector is invalid size' };
                elseif ~all( val(:) >= 0 ),
                    msg(end+1) ={ 'HalfWidth''s must be non-negative' };
                else
                    c.HalfWidth = val(:)';
                end
            otherwise
                [c.conbase, tmp_msg] = setparams( c.conbase, varargin{n}, val );
                msg = { msg{:}, tmp_msg{:} };
        end
    end
end
