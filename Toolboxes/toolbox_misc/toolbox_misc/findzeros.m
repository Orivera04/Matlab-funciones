function varargout = findzeros(varargin)

%FINDZEROS  Find zeros in a vector.
%  IND=FINDZEROS(Y) finds the indices (IND) which are close to local zeros in the vector Y.  
%  [IND,YZEROS]=FINDZEROS(X,Y), besides IND finds the values of local zeros (YZEROS) in the 
%  vector X by linear interpolation of the vector Y.
%  Inputs:
%   X: vector
%   Y: vector
%  Outputs:
%   IND: indices of the zeros values in the vector Y
%   YZEROS: values in the vector X of zeros in the vector Y
%  Marcos Duarte  mduarte@usp.br 11oct1998 

if nargin==1
    y=varargin{1};
    if size(y,2)==1
        y=y';
    end
elseif nargin ==2
    x=varargin{1}; 
    y=varargin{2}; 
    if ~isequal(size(x),size(y))
        error('Vectors must have the same lengths')
        return
    elseif size(x,2)==1
        x=x'; y=y';
    end
else
    error('Incorrect number of inputs')
    return
end

% find +- transitions (approximate values for zeros):
%ind(i): the first number AFTER the zero value
ind = sort( find( ( [y 0]<0 & [0 y]>0 ) | ( [y 0]>0 & [0 y]<0 ) ) );
% find who is near zero:
ind1=find( ( abs(y(ind)) - abs(y(ind-1)) )<= 0 );
ind2=find( ( abs(y(ind)) - abs(y(ind-1)) )> 0 );
indzero = sort([ind(ind1) ind(ind2)-1 find(y==0)]);
varargout{1}=indzero;
if exist('x')
    % find better approximation of zeros values using linear interpolation:
    yzeros=zeros(1,length(ind));
    for i=1:length(ind)
        p=polyfit( y(ind(i)-1:ind(i)),x(ind(i)-1:ind(i)),1 );
        yzeros(i)=polyval(p,0);
    end
    yzeros=sort([yzeros x(find(y==0))]);
    varargout{2}=yzeros;
end