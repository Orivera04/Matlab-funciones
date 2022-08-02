function varargout = set(varargin)
%SET

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.4 $  $Date: 2004/04/04 03:27:32 $

% Set command for LookupOne objects.
%
%  T = set(T,'values',v); will set the values array to the  column vector v.
% If the breakpoints field of the normaliser is empty, them v can be any length, if the 
% breakpoints field is not empty then the size of v must be the same size 
% as the existing field.
% 
% T = set(T,'values',{v,Information})
% sets the values field as above, and passes the argument 'Information'
% into the memory field. Will set the values field of the normaliser to match.
% 
% T = set(T,'breakpoints',v); will set the breakpoints array in the normaliser 
% to the column vector v. If the values field is empty, them v can be any length, 
% if the values field is not empty then the size of v must be the same 
% size as the existing field. Will set the values field of the normaliser appropriately.
% 
% T = set(T,'breakpoints',{v,Information})
% sets the breakpoints field as above, and passes the argument 'Information'
% into the memory field.
%
% T = set(T,'matrix',M); called with M an n by 2 matrix with increasing first
% column. Sets the breakpoints field of T to M(:,1) and the 
% values field to M(:,2). Ignores any locks.

% T = set(T,'matrix',{M,info}) sets the breakpoints field to the first column of M
% and the values field to the second column of M. Overrides any locks in place.
%
% T = set(T,'bp_element',[j,x]) sets the j entry in the breakpoints 
% vector to x provided that this is valid and theat element is not locked.
% 
% T = set(T,'bp_element',{[j,x],Information}) as above, and fills up 
% memory field.
%
% T = set(T,'bplocks',L) sets the bplocks field to the vector L. L should consist 
% of only 0's and 1's and must be the same size as the breakpoints field.
%
% T = set(T,'bplocks',[]) sets the bplocks field to the empty matrix thus allowing
% for resizing of the breakpoints field
%
% All other properties are set in the parents

LT = varargin{1};
if nargin == 1
    varargout{1} = set(LT.cgnormfunction);    
else
    if nargin < 3
        error('mbc:cglookupone:InvalidArgument', 'Insufficient arguments.');
    end
    for i = 2:2:nargin
        property = varargin{i};
        new_value = varargin{i+1};
        if ~isa(property , 'char')
            error('mbc:cglookupone:InvalidArgument', 'Property names must be a char array.');
        end 
        switch lower(property)
        case 'breakpoints'
            LT = i_breakpoints(LT,new_value);
        case 'bp_element'
           dummyNorm = get(LT.cgnormfunction, 'x');
           BP = dummyNorm.get('breakpoints');
           if isa(new_value,'double')
                j = new_value(1);
                x = new_value(2);
                BP(j) = x;
                LT = set(LT,'Breakpoints',BP);
           else
                V = new_value{1};
                j = V(1);
                x = V(2);
                info = new_value{2};
                BP(j) = x;
                LT = set(LT,'Breakpoints',{BP,info});
           end
        case 'values'
            LT = i_values(LT,new_value) ;        
        case 'bplocks'
            dummyNorm = get(LT.cgnormfunction, 'x');
            dummyNorm.info = dummyNorm.set('bplocks',new_value);
        case 'matrix'
            if isa(new_value,'double')
                M = new_value;
                info = 'No Information.';
            else
                M = new_value{1};
                info = new_value{2};
            end
            LT = i_matrix(LT,{M,info});
         otherwise % pass all others up to the parents
            LT.cgnormfunction = set(LT.cgnormfunction,property,new_value);
         end 
    end
end
if nargout > 0
    varargout{1} = LT;
elseif ~isempty(inputname(1))
    assignin('caller' , inputname(1) , LT);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% i_values                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function T = i_values(T,newvalue)

dummyNorm = get(T.cgnormfunction, 'x');
BP = dummyNorm.get('breakpoints');
val = get(T,'Values');
vlocks = get(T,'VLocks');

if ~isa(newvalue,'double')
    nval = newvalue{1};
    info = newvalue{2};
else
    nval = newvalue;
    info = [];
end
if isempty(nval)
    T.cgnormfunction = set(T.cgnormfunction,'Values',[]);
    T.cgnormfunction = set(T.cgnormfunction,'VLocks',[]);
else
    % check that the new values are the same size as the breakpoints
   if ~isequal(size(BP),size(nval)) && ~isempty(BP)
        error('mbc:cglookupone:InvalidSize', 'New values vector not same size as breakpoints vector.');
    end
    
    % increase the size of the locks if necessary
    if ~isequal(size(vlocks),size(nval))
        vlocks = zeros(length(nval),1);
    end
    if ~isempty(vlocks)
        vlocks = logical(vlocks);
        nval(vlocks) = val(vlocks);
    end   
    
    prec = get(T,'precision');
    T.cgnormfunction = setVunofficial(T.cgnormfunction, resolve(prec,nval));
    T.cgnormfunction = setBPunofficial(T.cgnormfunction,(0:length(nval)-1)');
end

TMemory = get(T, 'Memory');
n = length(TMemory);

TMemory{n+1}.Values = get(T,'Values');
TMemory{n+1}.Breakpoints = (0:length(nval)-1);
TMemory{n+1}.Information = info;
TMemory{n+1}.Date = datestr(now,0);
set(T, 'Memory', TMemory); 

%this will change the history of the normaliser, but not the breakpoints 
dummyNorm.info = dummyNorm.set('breakpoints',BP); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% i_breakpoints               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function T = i_breakpoints(T,newvalue)

dummyNorm = get(T.cgnormfunction,'x');
BP = dummyNorm.get('breakpoints');
val = get(T,'Values');
bplocks = dummyNorm.get('BPLocks');

if ~isa(newvalue,'double')
    nval = newvalue{1};
    info = newvalue{2};
else
    nval = newvalue;
    info = 'No Information';
end

if isempty(nval)
    dummyNorm.info = dummyNorm.set('breakpoints',[]);
    dummyNorm.info = dummyNorm.set('values',[]);
    dummyNorm.info = dummyNorm.set('BPLocks',[]);
else
    prec = dummyNorm.get('Precision');
    nval = resolve(prec,nval);
    
    % check that the new breakpoints are the same size as the values
    if ~isequal(size(val),size(nval)) && ~isempty(val)
        error('mbc:cglookupone:InvalidSize', 'New values vector not same size as breakpoints vector.');
    elseif any(diff(nval)<0)
        error('mbc:cglookupone:InvalidPropertyValue', 'Breakpoints vector must be increasing.' );
    end
    
    % normaliser breakpoints, info, and memory set 
    
    if ~isempty(bplocks)
        bplocks = logical(bplocks);
        nval(bplocks) = BP(bplocks);
    end
    dummyNorm.info = dummyNorm.set('breakpoints', {nval, info});
    
    % make the values field of the normaliser match
    dummyNorm.info = dummyNorm.setVunofficial( (0:length(nval)-1)' );
end

TMemory = get(T, 'Memory');
n = length(TMemory);

TMemory{n+1}.Values = val; %no change
TMemory{n+1}.Breakpoints = (0:length(nval)-1); % no change 
TMemory{n+1}.Information = info; 
TMemory{n+1}.Date = datestr(now,0);
set(T, 'Memory', TMemory); 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% i_matrix                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function LT = i_matrix(LT,M)
   
if isempty(M{1})
    LT.cgnormfunction = set(LT.cgnormfunction,'matrix',[]);
    xNormaliser = get(LT.cgnormfunction,'x');
    xNormaliser.info = xNormaliser.set('matrix',[]);
    set(LT, 'VLocks',[]);
    set(LT, 'BPLocks',[]);
    LT = clearExtrapolationMask(LT);
    return
else
    % set the values and breakpoints

    % calling on parent bypasses the check that the newvalues are the same length as the old bps of normaliser
    LT.cgnormfunction = setVunofficial(LT.cgnormfunction,  M{1}(:,2)); %don't alter table history yet
    LT.cgnormfunction = setBPunofficial(LT.cgnormfunction, (0:length(M{1}(:,2))-1)'); %don't alter table history yet
    
    % set breakpoints, history, and information
    set(LT, 'Breakpoints', {M{1}(:,1), M{2}});
    set(LT, 'VLocks',zeros(length(M{1}(:,1)),1));
    set(LT, 'BPLocks',zeros(length(M{1}(:,1)),1));
    LT = clearExtrapolationMask(LT);
      
end


