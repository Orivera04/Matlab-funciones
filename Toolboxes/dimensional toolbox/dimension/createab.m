function [A,B,order] = createab(RL,BaseVars)
% CREATEAB  creates A and B submatrices for dimensional analysis
%  [A,B,order] = CREATEAB(RL,BASEVARS)

% Dimensional Analysis Toolbox for Matlab
% Steffen Brückner, 2002-02-09

% check number of input arguments
msg = nargchk(2,2,nargin);
if msg
    error(msg);
    break;
end

% find the base vars in the relevance list,
% throw error if not found
bvars = [];
for ii=1:length(BaseVars)
    jj = strmatch(BaseVars{ii},{RL.Name},'exact');
    if isequal(jj,[])
        error('Base variable not in relevance list');
        break;
    end
    bvars(ii) = jj;
end

% build the submatrices B and A from the dimensional
% information and store order
A = []; a1 = [];
B = []; b1 = [];
for ii=1:length(RL)
    if find(bvars == ii)
        % base variable
        A  = [A RL(ii).Dimension];
        a1 = [a1 ii];
    else
        % no base variable
        B  = [B RL(ii).Dimension];
        b1 = [b1 ii];
    end
end


% create order array
order = [b1 a1];

% delete zero rows
[A,B] = formdm(A,B);
