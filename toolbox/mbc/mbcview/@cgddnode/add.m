function [D,ptr, alreadyin] = add(D,varargin)	
% CGDDNODE/ADD Add variables/constants/functions to the current data dictionary
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.7.2.2 $  $Date: 2004/02/09 08:23:03 $

% INPUTS    :   D           -   data dictionary
%               varargin    -   see below 
%
% OUTPUT    :   D           -   data dictionary
%               ptr         -   pointer of new object if created, or existing object if 
%                               already exists
%               alreadyin   -   0 if created here, 1 otherwise

% Where arguments can be any of the following
% ptr,aliasname
% name,aliasname
% ptr
% name
% equation string

CGP = project(D);

% First try and find the first argument
ptr = find(D,varargin{1});
% Need to check for things specified by 'lhs = rhs' .. if not found above
if isempty(ptr) & ischar(varargin{1})
    eqpos = findstr(varargin{1}, '=');
    if ~isempty(eqpos)
        ptr = find(D, deblank(varargin{1}(1:eqpos-1)));
    end
end
alreadyin = 0;
if isempty(ptr)
    % this thing must be added
    if ischar(varargin{1})
        eqpos = findstr(varargin{1}, '=');
        if eqpos
            lhs = varargin{1}(1:eqpos - 1);
            myname = uniquename(CGP, lhs);
            rhs = varargin{1}(eqpos +1:end);
            val = str2num(rhs);
            if isempty(val)                        
                % this thing is a cgsymvalue
                ptr = xregpointer(cgsymvalue(myname));
                ptr.info = ptr.setequation(rhs, address(D));
                D.numsymvars = D.numsymvars+1;
            else
                %this thing is a constant
                valobj = cgconstvalue;
                valobj = setname(valobj, myname);
                valobj = setnomvalue(valobj, val);
                ptr = xregpointer(valobj);
            end
        else
            % get a unique name
            myname = uniquename(CGP, varargin{1});
            % this thing is a cgvalue
            ptr = cgvalue(myname);
            % set default range
            ptr.info = ptr.setrange([-1 1]);
            % set an initial value and set point
            ptr.info = ptr.setnomvalue(1);
            ptr.info = ptr.setvalue(1);
        end
    else
        ptr = varargin{1};
        if ptr.issymvalue
            D.numsymvars = D.numsymvars+1;
        end
    end
    D.ptrlist = [D.ptrlist; ptr];
else
    alreadyin = 1;
end

if nargin == 3
    % Trying to add an alias
    alias = varargin{2};
    alptr = find(D, alias);
    if isempty(alptr)
        ptr.info = ptr.addalias(alias);
    end
end

% update dynamic copy
pointer(D);

