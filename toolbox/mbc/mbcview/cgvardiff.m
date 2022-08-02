function [OKleft,SpareLeft] = cgvardiff(left,right)
%CGVARDIFF  Identifies the common variables in two sets of expressions
%
% [OKleft,SpareLeft] = cgvardiff(left,right)
%  each of left and right is either:
%       1) an array of pointers to cgvalues, which are our "variables"
%       2) a pointer to a cgexpression.  we call getptrs on it, and
%         our "variables" are any cgvalues in these.
%
%  OKleft contains those variables in "left" which are also in "right".
%  SpareLeft contains those variables in "left" wich are NOT also in "right".

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.3 $  $Date: 2004/02/09 08:39:46 $

% First decompose left and right into their ddvariables
if length(left)==1 & ~left.isddvariable
    AllLeft = [];
    AllLeftnames = {};
    leftPtrs = unique(left.getsource);
    for j = 1:length(leftPtrs)
        if isddvariable(leftPtrs(j).info)
            AllLeft = [AllLeft leftPtrs(j)];
            AllLeftnames = [AllLeftnames, {leftPtrs(j).getname}];
        end
    end
    leftPtrs = unique(left.getptrs);
    for j = 1:length(leftPtrs)
        if isddvariable(leftPtrs(j).info) && ~any(strcmp(leftPtrs(j).getname, AllLeftnames))
            AllLeft = [AllLeft leftPtrs(j)];
            AllLeftnames = [AllLeftnames, {leftPtrs(j).getname}];
        end
    end
    left = AllLeft;
end
if length(right)==1 & ~right.isddvariable
    AllRight = [];
    AllRightnames = {};
    rightPtrs = unique(right.getsource);
    for j = 1:length(rightPtrs)
        if isddvariable(rightPtrs(j).info)
            AllRight = [AllRight rightPtrs(j)];
            AllRightnames = [AllRightnames, {rightPtrs(j).getname}];
        end
    end    
    rightPtrs = unique(right.getptrs);
    for j = 1:length(rightPtrs)
        if isddvariable(rightPtrs(j).info) && ~any(strcmp(rightPtrs(j).getname, AllRightnames))
            AllRight = [AllRight rightPtrs(j)];
            AllRightnames = [AllRightnames, {rightPtrs(j).getname}];
        end
    end
    right = AllRight;
end
left = double(left);
right = double(right);

% Analyse the ddvariable compatibility
spareleft = setdiff(left,right); % those in left which are NOT in right
spareright = setdiff(right,left);

if isempty(spareleft) & isempty(spareright)
    % all entries appear in both left and right
    SpareLeft = [];
    OKleft = assign(xregpointer,left);
    return
end

% Find all base variables on the right hand side
% i.e. remove all symvalues and replace them with their inputs
allright = [];
for i = 1:length(right)
    this = assign(xregpointer,right(i));
    allright = [allright,this.getrhsptrs]; % this only has any effect with symvalues
    if ~this.issymvalue
        allright = [allright,this];
    end
end
allright = unique(double(allright));

OKleft = [];
SpareLeft = [];

for i = 1:length(left)
    this = left(i);
    if ismember(this,right) | ismember(this,allright)
        % this entry appears on both sides
        OKleft = [OKleft,left(i)];
    else
        this = assign(xregpointer,this);
        if this.issymvalue
            % this entry is a symvalue (so won't be on the right): check its inputs
            thisRHS = this.getrhsptrs;
            OK = [];
            Spare = [];
            SpareConst = [];
            for j = 1:length(thisRHS)
                % Split inputs to this symvalue into three groups:
                %  1) those that appear on the right (OK)
                %  2) those that don't and are constant (SpareConst)
                %  3) those that don't and aren't constant (Spare)
                if ismember(double(thisRHS(j)),allright)
                    % this input appears on the right
                    OK = [OK,double(thisRHS(j))];
                elseif thisRHS(j).isconstant
                    % constant input to symvalue, which doesn't appear on the right
                    SpareConst = [SpareConst,double(thisRHS(j))];
                else
                    % non-constant input to symvalue.
                    Spare  = [Spare,double(thisRHS(j))];
                end
            end
            if isempty(OK)
                % none of the inputs to this symvalue appear on the right.
                SpareLeft = [SpareLeft,left(i)];
            elseif isempty(Spare)
                % all non-constant inputs to this symvalue appear on the right.
                % Return any constant inputs as "spare".
                OKleft = [OKleft,left(i)];
                SpareLeft = [SpareLeft,SpareConst];
            else
                % Not all the non-constant inputs to this symvalue appear on the right.
                % Return those that do as "overlap", and the rest as "spare".
                OKleft = [OKleft,OK];
                SpareLeft = [SpareLeft,Spare,SpareConst];
            end
        else
            % this entry appears only on the left
            SpareLeft = [SpareLeft, left(i)];
        end
    end
end

% convert outputs to arrays of xregpointers
if ~isempty(OKleft);
    OKleft = assign(xregpointer,unique(OKleft));
end
if ~isempty(SpareLeft);
    SpareLeft = assign(xregpointer,unique(SpareLeft));
end

return


    
