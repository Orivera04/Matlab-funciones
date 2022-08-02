function ok = isValidLink(op,link_i,thing, names)
% ok = isValidLink(op,link_i,fact_i)
% ok = isValidLink(op,link_i,ptr)
%  Check whether linking factor(link_i) to a pointer or another factor
%  is allowable.  Algebraic loops are disallowed.
%  fact_i, ptr may be vectors.
% Cannot link to values which are not in dataset.
% Can link to things which cannot be evaluated.
% Cannot link to things in same group.
% ok = isValidLink(op,link_i,...,'gui') - allow linking of invalid pointers.
%   Suitable pointers must be created for these factors before linking.
% ok = isValidLink(op, link_i, thing, names) - tests to see if you can link 
% the unassigned factor given by link_i to other unassigned factors in the session.
% The names of these factors are given in the names cell array

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.5.2.3 $  $Date: 2004/02/09 06:52:02 $

if nargin<3
    error('cgoppoint::isValidLink: insufficient arguments.');
elseif ~isnumeric(link_i) | length(link_i)~=1 | ~ismember(link_i,1:get(op,'numfactors'))
    error('cgoppoint::isValidLink: bad index into factors');
elseif ~isa(thing,'xregpointer') & ~isnumeric(thing)
    error('cgoppoint::isValidLink: require factor index or pointer.');
end


val_facs = 1:get(op,'numfactors');
ptrlist = op.ptrlist;
ok = [];

gno = op.group(link_i);

for i = 1:length(thing)
    thisok = [];
    if isnumeric(thing(i))
        if ~ismember(thing(i),val_facs)
            error('cgoppoint::isValidLink: bad index into factors');
        else
            % Cannot link within group
            if gno & op.group(thing(i))==gno
                thisok = 0;
                %elseif op.factor_type(thing(i))==0
                % can link to ignored factors
                %thisok = 0;
            end
            checkptr = ptrlist(thing(i));
        end
    else
        % pointer
        if isvalid(thing(i)) & ~thing(i).isa('cgexpr')
            error('cgoppoint::isValidLink: expect valid pointer to expression.');
        else
            % Cannot link within group
            if isvalid(thing(i))
                currInd = findname(op, thing(i).getname);
                % Extra condition to only test those factors in the data set,
                % as factors not in d/set cannot be in a group
                % Stops an empty == scalar warning
                if ~isempty(currInd) & gno & op.group(currInd)==gno
                    thisok = 0;
                    %elseif op.factor_type(thing(i))==0
                    % can link to ignored factors
                    %thisok = 0;
                end            
            end
            checkptr = thing(i);
        end
    end


    if isempty(thisok)
    if ~isvalid(ptrlist(link_i)) | ~isvalid(checkptr)
        % Can link a factor which is not assigned
        % But first have to create a value - do this at link make time.
        myname = get(op, 'factors');
        myname = myname(link_i);
        if isvalid(checkptr) & isa(checkptr.info, 'cgtradeoff')
            % Never link to trade off objects
            thisok = 0;
        elseif strmatch(names(i), myname, 'exact')
            % Cannot link to myself
            thisok = 0;
        else
            thisok = 1;
        end
    elseif ptrlist(link_i)==checkptr
        % cannot link to self
        thisok = 0;
    elseif isa(checkptr.info, 'cgtradeoff')
        % cannot link to tradeoff objects
        thisok = 0;
    elseif checkptr.isddvariable & ~ismember(double(checkptr),double(ptrlist))
        thisok = 0;
    else
        % link is not ok if it causes a loop
        %  (ie if the thing we're trying to link to depends
        %   on the thing we're linking)
        % Cannot just check parents, because getptrs does not check for links.
        %  Have to check which factors the pointer depends on - this does
        %  include any links.
        dep_factors = EvalDependancy(op,checkptr);
        thisok = ~ismember(link_i,dep_factors);
        %parents = checkptr.getptrs;
        %thisok = ~ismember(double(ptrlist(link_i)),double(parents));
    end
    end
    
    ok = [ok thisok];
end
