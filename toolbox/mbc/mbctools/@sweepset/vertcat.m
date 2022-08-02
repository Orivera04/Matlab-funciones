function C = vertcat(A,varargin)
% SWEEPSET/VERTCAT add record(s) to sweepset
%
% [A;B]  
%   Concatenates 2 sweepset objects (adds records togther)
%   An error is returned if the sweepsets have a different number of variables
%   It is possible to add a double matrix to the end of a sweepset. In this case a 
%   sweep with type -1 and test number -1 is assumed.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.



C = A;
% Check that the first argument of the call is a sweepset
if ~isa(A, 'sweepset')
    error('mbc:sweepset:InvalidArgument', 'First element of a vertical concatenation must be a sweepset');
end

for i = 1:length(varargin)
    B = varargin{i};
    switch class(B)
        case 'sweepset'
            if size(C,2) == size(B,2)
                % Check that the variable names all match
                i = 1;
                while i <= size(C,2) & strcmp(C.var(i).name, B.var(i).name)
                    i = i + 1;
                end
                % If all variables have the same names then i = size(C, 2) + 1
                if i > size(C, 2)
                    % Concatenate the data
                    C.data        = [C.data       ; B.data];
                    C.baddata     = [C.baddata    ; B.baddata];
                    C.guid        = [C.guid       ; B.guid];
                    C.xregdataset = [C.xregdataset; B.xregdataset];
                    C.nrec        = size(C.data,1);
                    % Update the variable min and max
                    if size(B,1) > 0
                        for i = 1:C.nvar
                            C.var(i).min = min([ C.var(i).min; B.var(i).min ]);
                            C.var(i).max = max([ C.var(i).max; B.var(i).max ]);
                        end
                    end
                else
                    error('mbc:sweepset:InvalidArgument', 'Incompatible Sweepset Variables in input %d', i)
                end
            else
                error('mbc:sweepset:InvalidArgument', 'Incompatible Sweepset Object sizes in input %d', i)
            end
        case 'double'
            % Check that the correct number of columns exist
            if size(C,2) == size(B,2) & ndims(B) == 2
                % Concatenate the new data
                C.data        = [C.data       ; B];
                C.baddata     = [C.baddata    ; sparse(size(B, 1), size(B, 2))];
                C.guid        = [C.guid       ; guidarray(size(B, 1))];
                C.xregdataset = [C.xregdataset; xregdataset(-1, -1, size(B,1))];
                C.nrec        = size(C.data,1);
                % Update the variable min and max
                if size(B, 1) > 0
                    mindat = min(B, [], 1);
                    maxdat = max(B, [], 1);
                    for i = 1:C.nvar
                        C.var(i).min = min([ C.var(i).min; mindat(i) ]);
                        C.var(i).max = max([ C.var(i).max; maxdat(i) ]);
                    end
                end
            else
                error('mbc:sweepset:InvalidArgument', 'Incompatible Sweepset Object and Data sizes in input %d', i)
            end
        otherwise
            error('mbc:sweepset:InvalidArgument', 'Invalid concatenation: only sweepsets and doubles permited');
    end
end
% All concatenated maps are workmaps
C.workmap = 1;
