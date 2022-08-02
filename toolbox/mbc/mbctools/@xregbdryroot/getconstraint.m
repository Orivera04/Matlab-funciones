function [con] = getconstraint( root, nf, stages )
%GETCONSTRAINT Constraint object for the whole tree
%
%  C = GETCONSTRAINT(ROOT) is a constraint object for the tree with the
%  given ROOT. 
%
%  C = GETCONSTRAINT(ROOT,NF) forces the constraint to have NF input
%  factors. This can be used to promote a global level constraint to a
%  response level constraint. If any of the constraints in the tree have
%  more than NF input factors, then this will likely generate an error.
%
%  C = GETCONSTRAINT(ROOT,NF,STAGES) is the constraint for only the given
%  stages, 0 for response, 1 for local, and 2 for global.
%
%  See also: XREGBDRYROOT/GETBEST, MDEVTESTPLAN/BOUNDARYMODEL.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.6.1 $    $Date: 2004/02/09 08:13:28 $ 

if nargin < 2, 
    nf = size( getdata( root ), 2 );
end
if nargin < 3, 
    stages = 0;
end

if stages > 0, % Local or global constraint
    childStages = children( root, 'getstages' );
    childIsBest = children( root, 'isbest' );

    % Find those branches that are responsible for the deisired stages and
    % are selected as best constraints.
    branchIndices = find( [childStages{:}] == stages & [childIsBest{:}] );

    % Get the constraints from those branches
    con = children( root, branchIndices, 'getconstraint', nf );
    
    % Only the first constraint is required.
    if isempty( con ),
        con = [];
    else
        con = con{1};
    end
else, % Response constraint
    % All branches contribute to the reponse level boundary constraint.
    % Therefore we just collect all those constaints marked as best and
    % ensure that they have the correct number of input factors.
    nbest = size( root.Best, 2 );
    if nbest == 0,
        % No branches are selected as best.
        con = [];
    elseif nbest == 1,
        con = getconstraint( info( root.Best ), nf );
    else
        % Multiple best branches ==> need to combine these constraints with
        % a intersection (logical and).
        con = getconstraint( info( root.Best(1) ), nf );
        for i = 2:nbest,
            con2 = getconstraint( info( root.Best(i) ), nf );
            if isempty( con ),
                con = con2;
            elseif ~isempty( con2 ),
                con = con & con2;
            end
        end
    end
end
