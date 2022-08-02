function [c,msg]=setparams(c,varargin)
%SETPARAMS  Set constraint parameters
%
%  C=SETPARAMS(C,PARAMLIST)  where PARAMLIST is a list
%  of parameter-value pairs.  Valid parameters for the
%  conbase object are :
%
%      Variables
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.1 $    $Date: 2004/02/09 06:57:17 $ 

msg={};

for n=1:2:length(varargin)
    val=varargin{n+1};
    switch lower(varargin{n})
        case 'variables'
            if ~isnumeric( val ) && ~islogical( val ),
                msg(end+1) ={ 'Variables vector must be numeric or logical' };
            elseif length( val(:) ) ~= length( c.Variables ),
                msg(end+1) ={ 'Variables vector is invalid size' };
            else
                c.Variables = logical( val(:)' );
            end
    end
end
