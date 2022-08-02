function varargout = set(varargin)
%SET

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.4 $  $Date: 2004/04/04 03:27:44 $

% cgnormfunction\set
%	out=set(N)	returns a list of properties and the required value type
%	N=set(N,'property',value,...) sets a property of N to the value given 
% 
%   set(T) displays possible properties to set.
%
%  T = set(T,'values',v); will set the values array to the  column vector v.
% If the breakpoints field is empty, them v can be any length, if the 
% breakpoints field is not empty then the size of v must be the same size 
% as the existing field.
% 
% T = set(T,'values',{v,Information})
% sets the values field as above, and passes the argument 'Information'
% into the memory field
% 
% T = set(T,'v_element',[j,x]) sets the j entry in the values vector to x 
% provided that this is valid and theat element is not locked.
% 
% T = set(T,'v_element',{[j,x],Information}) as above, and fills up memory field.
%
% T = set(T,'clips',[l,u]) sets the clips vector to be [l,u].
%
% T = set(T,'vlocks',L) sets the vlocks field to the vector L. L should consist 
% of only 0's and 1's and must be the same size as the values field.
%
% T = set(T,'vlocks',[]) sets the vlocks field to the empty matrix thus allowing
% for resizing of the values field
%
%
% T = set(T,'matrix',{M,info}) sets the values field to the vector M. Overrides 
% any locks in place.



if nargin == 1   
    varargout{1} = i_ShowFields;
else
    
    NF = varargin{1};
    if nargin < 3
        error('cgnormfunction\set: Insufficient arguments.');
    end
    for i = 2:2:nargin
        property = varargin{i};
        new_value = varargin{i+1};
        if ~isa(property , 'char')
            error('cgnormfunction\set: Non character array property name.');
        end
        switch lower(property)
        case 'clips';
            NF.Clips = new_value;  
        case 'v_element'
            
            val = NF.Values;
            
            if isa(new_value,'double')
                j = new_value(1);
                x = new_value(2);
                val(j) = x; 
                NF = set(NF,'values',val);
            else
                V = new_value{1};
                j = V(1);
                x = V(2);
                info = new_value{2};
                val(j) = x; 
                NF = set(NF,'values',{val,info});
            end
            
        case 'values'
            % same routine as above, double or cell.
            NF = i_values(NF,new_value);
            
        case 'vlocks'
            NF = i_vlocks(NF,new_value);
        case 'weights'
           % removed error checking 
            NF.Weights = new_value;
        case 'matrix'  
            NF = i_matrix(NF,new_value);
        case 'description'
            NF.Description = new_value;
        case 'input'
            NF.Input = new_value;
        case 'precision'
            NF.Precision = new_value;
        case 'range'
            NF.Range = new_value;
            if ~isempty(new_value)
                NF.Clips = new_value(end,:);
            end
        case 'memory'
            NF.Memory = new_value;
        otherwise
            warning('mbc:InvalidArgument',['cgnormfunction/set: invalid property '''...
                    property '''']);
        end
    end
end
if nargout > 0
    varargout{1} = NF;
elseif ~isempty(inputname(1))
    assignin('caller' , inputname(1) , NF);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% i_showfields                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function out = i_ShowFields
out.Breakpoints = 'n by 1 vector';
out.BP_Element = '';
out.Values = 'n by 1 Array';
out.V_Element = '';
out.Clips = '1 by 2 vector';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% i_values                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function T = i_values(T,newvalue)

BP = T.Breakpoints;
val = T.Values;
vlocks = T.VLocks;

if ~isa(newvalue,'double')
    nval = newvalue{1};
    info = newvalue{2};
else
    nval = newvalue;
    info = [];
end

if isempty(nval)
    T.Values = [];
    T.Breakpoints = [];
    T.VLocks = [];
else
       
    if ~isempty(vlocks)
        vlocks = logical(vlocks);
        nval(vlocks) = val(vlocks);
    end
    prec = get(T,'precision');
    T.Values = resolve(prec,nval);   
    if isempty(BP);
        n = length(T.Values);
        BP = (0:n-1)';
        T.Breakpoints = BP;
    end
end

n = length(T.Memory);

T.Memory{n+1}.Values = T.Values;
T.Memory{n+1}.Breakpoints = BP;
T.Memory{n+1}.Information = info;
T.Memory{n+1}.Date = datestr(now,0);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% i_vlocks                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function T = i_vlocks(T,L)

if isempty(L)
    T.VLocks  = [];
elseif ~isequal(size(L),size(T.Values))
    error('cgnormfunction\set: New vlock vector not right size');
elseif ~isequal(L, L.^2)
    error('cgnormfunction\set: locks vectors are to conist of 0''s and 1''s');
else
    T.VLocks = L;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% i_matrix                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function NF = i_matrix(NF,new_value)

if ~isnumeric(new_value);
    M = new_value{1};
    info = new_value{2};
else
    M = new_value;
    info = 'No information';
end
NF = set(NF,'vlocks',[]);
NF.Breakpoints = [];
if isempty(M)
    NF.Values = [];
    return
else
    NF = set(NF,'values',{M,info});
    NF = setBPunofficial(NF,(0:length(M)-1)');
    NF = set(NF,'vlocks',zeros(length(M(:,1)),1));
    NF = clearExtrapolationMask(NF);
end

return

