function C=subsasgn(A,S,data)
% SWEEPSET/SUBASGN subassignment of sweep A(S)=B
% 
% Supported subassignments
%   A.var = data;
%   A.var(recs) = data;
%   A(recs,{varlist}) = data;
%   A(logicalMatrix(nrecs x nvars)) = data;
%   A{tests} = data;
% 
% subassignment which extends sweepset size is not supported.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.



C=A;
if isempty(data)
    error('mbc:sweepset:InvalidArgument', 'Deleting records, variables or sweeps by assigning to [] is not supported')
end
switch S(1).type
    case '{}'
        % TO CHECK - data can't be empty here and should we really be
        % testing C.nrec > 0?
        if ~isempty(data) & C.nrec>0
            C.data(sindex(C,S.subs{1}),:)= data;
        end
        
    case '.'
        ind=find(C,{S(1).subs});
        if ~isempty(ind);
            if length(S)==2 & strcmp(S(2).type,'()')
                try
                    % TO CHECK - local reference to S{2}.subs{1}?
                    C=i_AsgnBadData(C,S(2).subs{1},ind,data);
                    C.data(S(2).subs{1},ind) = data;
                catch
                    error('mbc:sweepset:InvalidAssignment', 'Incompatible assignment')
                end
            else
                try
                    C=i_AsgnBadData(C,':',ind,data);
                    C.data(:,ind) = data;
                catch
                    error('mbc:sweepset:InvalidAssignment', 'Incompatible assignment')
                end
            end
        else
            error('mbc:sweepset:InvalidArgument', ['Variable ',S(1).subs,' does not exist in Sweepset'])
        end
    case '()'
        if length(S)>1
            error('mbc:sweepset:InvalidArgument', 'Invalid assignment for sweep')
        end
        S1= S.subs{1};
        % If record argument is a guidarray convert S1 to real indexes
        if isa(S1, 'guidarray')
            % Note that guidarray indexed by guidarray returned double indicies
            S1 = A.guid(S1);
            % Check we have found everything
            if any(S1 == 0)
                error('mbc:sweepset:InvalidIndex', 'Requested GUID record identifiers not found in sweepset');
            end
        end
        % Is the record index argument a logical matrix for logical
        % indexing
        LOGICAL_MATRIX_INDEX = islogical(S1) && numel(S1) == numel(C.data) && length(S.subs) == 1;
        % Hold the Logical Matrix Index in a sensible fashion so that
        % i_LogicalAsgnBadData works properly
        if LOGICAL_MATRIX_INDEX
            Rec_Ind = S1;    
        else
        Rec_Ind = [S1(:)]';
        end
        if length(S.subs) == 3
            S3 = S.subs{3};
            % If sweep argument is a guidarray convert S1 to real indexes
            if isa(S3, 'guidarray')
                sweepGuidArray = getSweepGuids(A);
                % Note that guidarray indexed by guidarray returned double indicies
                S3 = sweepGuidArray(S3);
                % Check we have found everything
                if any(S3 == 0)
                    error('mbc:sweepset:InvalidIndex', 'Requested GUID sweep identifiers not found in sweepset');
                end
            end
            % Indexing Sweeps (Need to update Record Index)
            if  ~strcmp(S3,':')
                % Find Record Positions for selected sweeps
                Sw_Ind= RecPos(A,S3);
                if strcmp(S1,':')
                    % All records selected
                    Rec_Ind= Sw_Ind;
                else
                    if ~islogical(Sw_Ind) & ( length(Sw_Ind) == 1 | any(diff(Sw_Ind)<=0) )
                        error('mbc:sweepset:InvalidAssignment', 'Sweep Indices must be increasing')
                    end
                    %TRUE= ~0;
                    Sw_L= false(1,A.nrec);
                    Sw_L(Sw_Ind) = true;
                    if islogical(Rec_Ind)
                        % logical indexing of records
                        Rec_L = [Rec_Ind(:)' false(1,A.nrec-length(Rec_Ind)) ];
                        Rec_Ind= Rec_L & Sw_L;
                    else
                        if ~islogical(Rec_Ind) & (length(Rec_Ind) == 1 | any(diff(Rec_Ind)<=0) )
                            error('mbc:sweepset:InvalidAssignment', 'Record Indices must be increasing when indexing by sweep')
                        end
                        % indexing of records
                        % Find Record in Selected Sweeps
                        Rec_L= false(1,A.nrec);
                        Rec_L(Rec_Ind) = true;
                        Rec_Ind= Rec_L & Sw_L;
                    end
                end
            end   
        end
        
        switch length(S.subs)
            case {2,3}
                S2=S.subs{2};
                % Indexing Variable by cell array of names in 2nd dimension
                if strcmp(S2,':') | isa(S2,'double') | islogical(S2)
                    % Indexing Variable by index 2nd dimension
                    Var_Ind = S2;
                else
                    % isa(S2,'cell') | (isa(S.subs{2},'char') & ~strcmp(S2,':'))
                    [Var_Ind,NotFnd]=find(C,S2);
                    if isempty(Var_Ind);
                        if ~isa(S2,'cell')
                            S2= {S2};
                        end
                        error('mbc:sweepset:InvalidArgument',...
                            ['Variable(s) ',sprintf('%s, ',S(1).subs{2}{NotFnd==-1}),...
                                sprintf('\b\b'),' not found in sweepset'])
                    end
                end
            case 1
                % Indexing by records only
                Var_Ind = ':';
        end
        try
            if LOGICAL_MATRIX_INDEX
                C = i_LogicalAsgnBadData(C, Rec_Ind, data);
                C.data(Rec_Ind) = data;
            else
                C = i_AsgnBadData(C,Rec_Ind,Var_Ind,data);
                C.data(Rec_Ind,Var_Ind) = data;
            end
        catch
            error('mbc:sweepset:InvalidAssignment', 'Incompatible assignment')
        end
    otherwise
        error('mbc:sweepset:InvalidArguments', 'Invalid arguments for sweepset subsasgn')
end

if size(C.data)~=size(A.data);
    error('mbc:sweepset:InvalidAssignment', 'Assignment cannot be used to extend sweepset size')
end
%if ~all(all(~isnan(data)))
% All sub-assigned maps are workmaps if not all bad data
%   C.workmap = 1;
%end


% function Valid= i_IsValidSubAsgn(A,S)
% 
% Valid = 1;
% for i = 1:length(S.subs)
%     if isa(S.subs{i},'double');
%         Ind = S.subs{i};
%         if islogical(Ind)
%             Ind = find(Ind);
%         end
%         Valid = (max(Ind) <= size(A,i));
%     end
% end


function C = i_AsgnBadData(C,row,col,data);

BDind= isnan(data);
if any(any(BDind))    % scalar expansion => all NaN's
    OldData= C.data(row,col);
    OldBD= C.baddata(row,col);
    BadData= zeros(size(OldData)); 
    % don't want to write existing NaN's to baddata
    OldNaN = isnan(OldData);
    BadData(BDind & ~OldNaN)= OldData(BDind & ~OldNaN);
    BadData(OldNaN)= OldBD(OldNaN);
    C.baddata(row,col)=BadData; 
end   

function C = i_LogicalAsgnBadData(C, index, data);

BDind = isnan(data);
if any(any(BDind))    % scalar expansion => all NaN's
    OldData = C.data(index);
    OldBD   = C.baddata(index);
    BadData = zeros(size(OldData)); 
    % don't want to write existing NaN's to baddata
    OldNaN = isnan(OldData);
    BadData(BDind & ~OldNaN) = OldData(BDind & ~OldNaN);
    BadData(OldNaN)  = OldBD(OldNaN);
    C.baddata(index) = BadData; 
end   
% if 0
%     OldData= C.data(row,col);
%     OldBD= C.baddata(row,col);
%     % don't want to write existing NaN's to baddata
%     OldNaN = isnan(OldData);
%     BadData= zeros(size(data));   
%     BadData(BDind & ~OldNaN)= OldData(BDind & ~OldNaN);
%     BadData(OldNaN)= OldBD(OldNaN);
%     C.baddata(row,col)= BadData;
% end