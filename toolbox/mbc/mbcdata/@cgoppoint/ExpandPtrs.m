function [ptrs,linkptrs,names,units,cr_flag,value_ind,return_ind] = ExpandPtrs(op,in,fact_i)
% [ptrs,linkptrs,names,units,cr_flag,value_ind,factor_ind] = ExpandPtrs(op,fact_i)
%                                                   ExpandPtrs(op,ptrs)
%                                                   ExpandPtrs(op,ptrs,fact_i)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.2.5 $  $Date: 2004/04/04 03:25:56 $

if isnumeric(in)
    if ~all(ismember(in,1:length(op.ptrlist)))
        error('ExpandPtrs: bad index into factors');
    end
    inptrs = op.ptrlist(in);
    fact_i = in;
elseif isa(in,'xregpointer')
    inptrs = in;
    if nargin<3
        fact_i = repmat(0,1,length(in));
    elseif ~all(ismember(fact_i,0:length(op.ptrlist)))
        % include zero in factor index
        error('ExpandPtrs: bad index into factors');
    end
else
    error('ExpandPtrs: expect factor index or xregpointers');
end

overwrite = get(op,'evaldisp_overwrite');

ptrs = []; index = []; value_ind = []; linkptrs = []; names = [];
units = []; return_ind = [];
cr_flag = [];
done = 0; % dummy value so we don't have to check for isempty
for i = 1:length(inptrs)
    ptr = inptrs(i);
    if fact_i(i)>0
        %if (isvalid(ptr) & ~ptr.isddvariable & overwrite(fact_i(i)));
         %   two_needed = 1;
         %else
            two_needed = 0; done = 0;
            %end
        if ~isvalid(ptr) | overwrite(fact_i(i))
            done = 1;
            % either overwrites expression or only exists in 
            %  dataset - add to expansion
            linkptrs = [linkptrs xregpointer];
            ptrs = [ptrs ptr];
            value_ind = [value_ind 1];
            if isvalid(ptr)
                % overwritten
                if two_needed
                    names = [names {[ptr.getname ' (dataset)']}];
                else
                    names = [names {ptr.getname}];
                end
            else
                names = [names {op.orig_name{fact_i(i)}}];
            end
            cr_flag = [cr_flag 1];
            units = [units {op.units{fact_i(i)}}];
            return_ind = [return_ind i];
        end
        % ??? Always generates two outputs if overwriting something.
        %  Is this always good? Eg select two factors and want
        %  to generate error - not possible.
        if isvalid(ptr) & ~done
            value_ind = [value_ind ptr.isddvariable];
            if ~value_ind(end) | ~overwrite(fact_i(i))
                % Only show overwrite if not a value
            % assigned to something - add that to expansion
                if op.created_flag(fact_i(i))==-2
                    linkptrs = [linkptrs op.linkptrlist(fact_i(i))];
                else
                    linkptrs = [linkptrs xregpointer];
                end
                ptrs = [ptrs ptr];
                if overwrite(fact_i(i))
                    names = [names {[ptr.getname ' (evaluation)']}];
                    cr_flag = [cr_flag -3];
                else
                    names = [names {ptr.getname}];
                    cr_flag = [cr_flag op.created_flag(fact_i(i))];
                end
                units = [units {ptr.grabUnits}];
                return_ind = [return_ind i];
            end
        end
    elseif ~isvalid(ptr)
        % something gone wrong - not a factor, not a ptr.
        error('ExpandPtrs: null pointer must have index into factors');
    elseif ~ptr.isa('cgexpr')
        % do nothing
        %error('AddExpr: all ptrs must be expressions');
    elseif ~ptr.isdsvariable
        % do not add these
        %error(['AddExpr: cannot add ' ptr.class ' to dataset.']);
    else
        if ~ismember(double(ptr),done)
            done = [done double(ptr)];
            
            if ptr.isa('cgfeature')
                %special case: subfeature.
                %  check for model and equation.
                mod = ptr.get('model');
                eq = ptr.get('equation');
                sfname = ptr.getname;
                if ~isempty(mod) & isvalid(mod)
                    linkptrs = [linkptrs mod];
                    ptrs = [ptrs ptr];
                    value_ind = [value_ind 0];
                    names = [names {[sfname ': Model']}];
                    cr_flag = [cr_flag -2];
                    units = [units {mod.grabUnits}];
                    return_ind = [return_ind i];
                end
                if ~isempty(eq) & isvalid(eq)
                    linkptrs = [linkptrs eq];
                    ptrs = [ptrs ptr];
                    value_ind = [value_ind 0];
                    names = [names {[sfname ': Strategy']}];
                    cr_flag = [cr_flag -2];
                    units = [units {eq.grabUnits}];
                    return_ind = [return_ind i];
                end
            else
                linkptrs = [linkptrs xregpointer];
                ptrs = [ptrs ptr];
                value_ind = [value_ind ptr.isa('cgvariable')];
                names = [names {ptr.getname}];
                cr_flag = [cr_flag -1];
                units = [units {ptr.grabUnits}];
                return_ind = [return_ind i];
            end
        end
    end
end
% [un_ptr,i] = unique(double(ptrs));
% ptrs = assign(xregpointer,un_ptr);
% linkptrs = linkptrs(i);
% %index = index(i);
% value_ind = value_ind(i);
