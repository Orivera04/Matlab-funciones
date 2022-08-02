function [m,MD]= ChannelMatch(m,S,CheckUnits,CopyRanges);
% XREGMODEL/CHANNELMATCH

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/04/04 03:30:16 $


if nargin<4
    CopyRanges= 0;
end
nf= nfactors(m);
MD(1:nf) = {S};

VarNames= get(S,'name');
Units= get(S,'units');

xi= xinfo(m);
% find exact matches
ExactMatch= false(1,length(VarNames));
Matched= false(1,nf);
for i=1:nf
    if isempty(xi.Names{i}) 
        %use symbol if no name is defined
        xi.Names{i}= xi.Symbols{i};
    end
    dpos= strcmp(xi.Names{i},VarNames);
    if any(dpos)
        ExactMatch(dpos)= true;
        Matched(i)= true;
        % set units
        xi.Units{i} = Units{dpos};
    end
end

% unmatched data
DataNames= VarNames(~ExactMatch);
Units= Units(~ExactMatch);

for i= find(~Matched)
    % loop over unmatched input factors
	% check that the signal name exists
    
    j=1;
    lenName= length(xi.Names{i});
    pmatIndex= find(strncmp(xi.Names{i},DataNames,j));
    if isempty(pmatIndex)
        BestMatch= 1;
    else
        BestMatch= pmatIndex(1);
        while j<lenName &&  ~isempty(pmatIndex)
            j= j+1;
            BestMatch= pmatIndex(1);
            % partial comparison of first j elements
            pmatIndex= find(strncmp(xi.Names{i},DataNames,j));
        end
    end
    % set names and units
    xi.Names{i} = DataNames{BestMatch};
    xi.Units{i} = Units{BestMatch};
    
    % delete matched signal
    DataNames(BestMatch) = [];
    Units(BestMatch)     = [];

end

% Update Model Info
m= xinfo(m,xi);

if CopyRanges
    % set coding from data
    [Bnds,g,Tgt]=getcode(m);
    for i=1:nf
        X= double( S(:,xi.Names{i}) );
        X= X(isfinite(X));
        if ~isempty(X)
            Bnds(i,:)= [nanmin(X) nanmax(X)];
            if Bnds(i,2)-Bnds(i,1) < eps
               Bnds(i,2) = Bnds(i,1)*1.1;
               Bnds(i,1) = Bnds(i,1)*0.9;
               if Bnds(i,1)==0.0
                   Bnds(i,:)= [-1 1];
               end 
            end
        end
    end
    m= setcode(m,Bnds,g,Tgt)
end