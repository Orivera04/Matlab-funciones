function B = subsref(A, S)
% SWEEPSET/SUBSREF subreferencing of SWEEPSET objects
%
% Valid Indexing Schemes for SWEEPSET objects
%     B = A(recs, vars , sweeps);
%     B = A(recs, vars);      % all sweeps
%     B = A(recs);            % all variables and sweeps
%     B = A.varname;          % single variable, all records and sweeps
%     B = A.varname(recs);    % single variable and selected records for all sweeps
%     d = A{i};                % extracts data of a single sweep i as a double

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.6.4.4 $    $Date: 2004/04/04 03:31:58 $ 

B=A;
switch S(1).type
    case '{}'
        % data index for sweep
        if A.nrec>0
            ind= sindex(A,S.subs{1});
            % return data
            B= A.data(ind,:);
        else
            B=[];
        end
    case '.'
        % Indexing variable by fieldname  A.varname
        ind=find(A,S(1).subs);
        if ~isempty(ind);
            B.var  = A.var(1,ind);
            B.data = A.data(:,ind);
            B.baddata = A.baddata(:,ind);
            B.nvar = size(B.data,2);
            Valid_Index=0;
            if length(S)==2 && strcmp(S(2).type,'()')
                Valid_Index=1;
                % Indexing records in single variable    A.varname(recs)
                B.baddata = B.baddata(S(2).subs{1},:);
                B.data = B.data(S(2).subs{1},:);
                B.nrec= size(B.data,1);
                if ~(ischar(S(2).subs{1}) && strcmp(S(2).subs{1},':'))
                    % Update sweep sizes and selected sweeps
                    [B,ind] = sweeppos(B,S(2).subs{1});
                end
            end
            if ~(length(S)==1 || Valid_Index)
                help([mfilename('class') '/' mfilename])
                error('mbc:sweepset:InvalidIndex', 'Invalid Indexing Scheme ')
            end
        else
            error(['Variable ',S(1).subs,' does not exist in Sweepset'])
        end
        
    case '()'
        if length(S) > 1
            help([mfilename('class') '/' mfilename])
            error('mbc:sweepset:InvalidIndex', 'Invalid Indexing Scheme')
        end
        S1 = S.subs{1};
        % If record argument is a guidarray convert S1 to real indexes
        if isa(S1, 'guidarray')
            % Note that guidarray indexed by guidarray returned double indicies
            S1 = A.guid(S1);
            % Check we have found everything
            if any(S1 == 0)
                error('mbc:sweepset:InvalidIndex', 'Requested GUID record identifiers not found in sweepset');
            end
        end
        ALL_RECORDS = strcmp(S1, ':');
        ALL_SWEEPS  = 1;
        Rec_Ind = S1(:)';
        if length(S.subs) == 3
            % Indexing Sweeps (Need to update Record Index)
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
            if  ~strcmp(S3,':')
                ALL_SWEEPS = 0;
                % Find Record Positions for selected sweeps
                Sw_Ind= RecPos(B,S3);
                if ALL_RECORDS
                    % All records selected
                    Rec_Ind= Sw_Ind;
                else
                    % To CHECK - can Sw_Ind be logical?
                    if ~islogical(Sw_Ind) && ( length(Sw_Ind) > 1 && any(diff(Sw_Ind)<=0) )
                        error('mbc:sweepset:InvalidIndex', 'Sweep Indices must be increasing')
                    end
                    Sw_L= false(1, B.nrec);
                    Sw_L(Sw_Ind) = true;
                    if islogical(Rec_Ind)
                        % TO CHECK - really sensible to allow Rec_Inf to be
                        % logical and shorted than nrec?
                        % logical indexing of records
                        Rec_L = [Rec_Ind(:)' false(1,B.nrec-length(Rec_Ind))];
                        Rec_Ind= Rec_L & Sw_L;
                    else
                        % TO CHECK - isn't Rec_Ind definately not logical?
                        if ~islogical(Rec_Ind) && (length(Rec_Ind) > 1 && any(diff(Rec_Ind)<=0) )
                            error('mbc:sweepset:InvalidIndex', 'Record Indices must be increasing when indexing by sweep')
                        end
                        % indexing of records
                        % Find Record in Selected Sweeps
                        Rec_L= false(1,B.nrec);
                        Rec_L(Rec_Ind) = true;
                        Rec_Ind= Rec_L & Sw_L;
                    end
                end
            end   
        end
        
        switch length(S.subs)
            case {2,3}
                S2 = S.subs{2};
                if iscell(S2) && isempty(S2)
                    varIndex = [];
                elseif iscell(S2) || (ischar(S2) && ~strcmp(S2, ':'))
                    % Index is a string or a cell array of strings
                    [varIndex, NotFnd] = find(A, S2);
                    % Checkk that all th requested variables were found
                    if isempty(varIndex)
                        % If not convert to a cell array for displaying in
                        % an error, then throw the error
                        if ~isa(S2,'cell')
                            S2 = {S2};
                        end
                        error('mbc:sweepset:InvalidIndex',...
                            ['Variable(s) ',sprintf('%s, ',S2{NotFnd == -1}),...
                                sprintf('\b\b'),' not found in Sweepset'])
                    end
                else
                    % Index is ':' or double or logical
                    varIndex = S2;
                end
            case 1
                % Indexing by records only
                varIndex = ':';
        end
  
        % Update the data in the sweepset
        B.data = A.data(Rec_Ind, varIndex);
        % Note that this index into baddata works because of the struct
        % (sparse(1, ':') fails but a.sparse(1, ':') succeeds
        B.baddata = A.baddata(Rec_Ind, varIndex); 
        B.nrec = size(B.data, 1);
        % Note ~ischar(varIndex) implies variables could be changing
        if ~ischar(varIndex)
            B.var     = A.var(1, varIndex);
            B.nvar    = size(B.data, 2);
        end
        
        % Have the number or order of records changed?
        if ~(ALL_RECORDS && ALL_SWEEPS)
            % Need to update the guid array
            B.guid = A.guid(Rec_Ind);
            %B.guid = fastsubsref(A.guid, Rec_Ind);
        end
        % Need to update the underlying xregdataset
        if ~ALL_RECORDS
            % Update sweep sizes and selected sweeps
            [B,ind] = sweeppos(B,Rec_Ind);
        elseif length(S.subs)==3
            B.xregdataset  = B.xregdataset(S3);
        end
    otherwise
        help([mfilename('class') '/' mfilename])
        error('Invalid Indexing Scheme')
end
% All sub-referenced maps are workmaps
% B.workmap  = 1;
