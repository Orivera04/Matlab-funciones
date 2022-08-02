function [op,mess] = ImportTable(p,tableptr,include_output,option,inputs)
% p = ImportTable(cgoppoint,tptr,include_output)
%       Create new dataset from table tptr.  
% p = ImportTable(p,tptr,include_output)
%       Fill existing dataset from table.  Factors corresponding to 
%         table axes must be present in p.  Include_output forces the table
%         output to be included, adding an additional factor if necessary.
%         All original data is discarded. Table axes factors are set as inputs, table
%         output as output, other factors set to 'ignore'.
% p = ImportTable(p,tptr,include_output,option)
%       option = 'overwrite' - discard all original data (default)
%                'evaluate' - evaluate this table at the points present in the dataset;
%                               keep all other original data.
%                'new' - return new dataset.
% p = ImportTable(p,tptr,include_output,option,{inputnames})
%       Table axis data is placed in the factors given by inputnames.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.5.4.3 $  $Date: 2004/02/09 06:51:16 $

mess = '';
if nargin<3
    mess = 'Not enough arguments';
elseif nargin<4
    option = 'overwrite';
end
if nargin<5
    inputs = [];
end

% construct an oppoint from the table; 
% use this to fill the existing one if necessary
name = getname(tableptr.info);   
if include_output
    op = cgoppoint(tableptr,'fill','name',[name,'_output']);
else
    op = cgoppoint(tableptr,'name',[name,'_axes']);
end

if ~isempty(p)
    valid = check_eval(p,tableptr); %check that we can fill this dataset from the table
    included = isfactor(p,tableptr); %check whether table is already present as a factor
    ptrlist = get(p,'ptrlist');
    
    filled_i = []; out_i = [];
    if ~isempty(inputs) %match the given input names
        factors = lower(get(p,'factors'));
        orig_name = lower(get(p,'orig_name'));
        if length(inputs)~=length(get(tableptr.info,'axesptrs'))
            mess = 'Number of named inputs does not match dimension of table.';
        else
            for i = 1:length(inputs)
                if ~ischar(inputs{i})
                    mess = 'Input names must be strings';
                else
                    f = find(strcmp(lower(inputs{i}),factors));
                    if length(f)==1
                        filled_i(i) = f;
                    else
                        f = find(strcmp(lower(inputs{i}),orig_name));
                        if length(f)==1
                            filled_i(i) = f;
                        else
                            mess = ['Cannot find ' inputs{i} ' in data set'];
                        end
                    end
                end
            end
        end
    elseif ~valid
        mess = 'Dataset inputs do not match table inputs';
    end
    
    if isempty(mess)    %no errors so far
        switch lower(option)
            
        case 'overwrite'
            newdata = op.data;
            numfactors = get(p,'numfactors');
            con = get(p,'constant');
            range = cell(1,numfactors);
            axes = get(op,'range');
            if length(con)~=numfactors
                con = zeros(1,numfactors);
            end
            data = repmat(con,size(newdata,1),1);
            
            if ~isempty(inputs) %use named inputs
                data(:,filled_i) = newdata(:,1:length(filled_i));
                t_ptrs = [];    %may need to find table, even if given named inputs
            else
                t_ptrs = tableptr.get('axesptrs');
            end
            
            if included & include_output    %find existing inputs to match table axes
                t_ptrs = [t_ptrs tableptr];
            end
            for i = 1:length(t_ptrs)    %match up table axes with factors; already checked that this is going to be ok
                f = find(double(t_ptrs(i))==double(ptrlist));
                if ~isempty(f)
                    data(:,f) = newdata(:,i);
                    filled_i = [filled_i f];
                    range{f} = axes{i};
                    if double(ptrlist(f))==double(tableptr)
                        out_i = f;
                    end
                end
            end
            group = BuildRelatedGroups(p);
            group_i = [];
            for i = 1:length(group)
                if any(ismember(filled_i,group{i}))
                    group_i = [group_i group{i}];
                end
            end
            notfilled = setdiff(1:numfactors,group_i); %set other columns to 'ignore'
            group_i = setdiff(group_i,filled_i);  %set group members to 'dependant'
            op = set(p,'data',data,'range',range);
            op = set(op,notfilled,'grid_flag',0);    % grid_flag 4 = blank
            op = set(op,group_i,'grid_flag',8);    % grid_flag 8 = dependant
            op = set(op,filled_i,'factor_type',1,'grid_flag',6);   %grid_flag used in gui; 6 = import table
                    %if given as input names may not be inputs already
            if ~included & include_output   %need to add factor
                op = addfactor(op,tableptr,newdata(:,end),'factor_type',2,'grid_flag',0);
            elseif included & include_output & ~isempty(out_i)  %last one found is table - set as output
                op = set(op,out_i,'factor_type',2,'grid_flag',0);
            end
            % The data set should be evaluated in every case, as other factors (such as models) may be in the d/s
            if ~isempty(group)
                op = range_grid(op);    % evaluate any group stuff
            end
            op = eval_fill(op);
            
        case 'evaluate'
            newdata = i_eval(p,tableptr);
            op = p;
            if ~include_output
                mess = 'Evaluation discarded; set include_output to 1 to include.';
            elseif included
                f = find(double(tableptr)==double(ptrlist));
                if ~isempty(f)
                    op = set(op,f,'data',newdata,'factor_type',2,'grid_flag',0);   %update this factor
                end
            else
                op = addfactor(op,tableptr,newdata,'factor_type',2,'grid_flag',0); %add new
            end
            
        case 'new'
            % do nothing
        otherwise
            mess = 'Unrecognised option';
        end
    end
    
end
if nargout<2 & ~isempty(mess)
    error(mess)
end
if ~isempty(mess)
    op = p; %return original
end
