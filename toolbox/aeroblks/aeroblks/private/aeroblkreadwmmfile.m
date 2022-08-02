function [epoch,maxdef,c,dc,fn,fm,snorm,k] = aeroblkreadwmmfile(varargin)
% AEROBLKREADWMMFILE - Aerospace helper function to load .COF files for 
% the World Magnetic Model block.
% 
% [EPOCH,MAXDEF,C,DC,FN,FM,SNORM,K] = AEROBLKREADWMMFILE reads data from
% WMM.COF
%
% [EPOCH,MAXDEF,C,DC,FN,FM,SNORM,K] = AEROBLKREADWMMFILE('FILENAME') reads 
% data from file FILENAME

% Copyright 1990-2003 The MathWorks, Inc.
% $Revision: 1.1.6.3 $ $Date: 2004/04/06 01:04:12 $

if (nargin == 0)
    filename ='WMM.COF';
elseif (nargin == 1)
    filename = varargin{1};
else
    error('aeroblks:aeroblkreadwmmfile:invalidinput','Too many inputs.  Maximum number of inputs is one.')
end

% hardwired value from NIMA program
maxdef=12;

% read file information
[epoch, modelnumber, date] = textread(filename,'%n %s %s',1);

fid = fopen(filename,'rt');
fgetl(fid);
w_temp = fscanf(fid,'%g',540);

w = reshape(w_temp, 6 ,90)';
fclose(fid);

% process data
c(1,1) =0.0;
dc(1,1)=0.0;
r =size(w,1);
for i=1:r
    if (w(i,2)<=w(i,1))
        c(w(i,2)+1,w(i,1)+1) = w(i,3);
        dc(w(i,2)+1,w(i,1)+1) = w(i,5);
        if (w(i,2) ~= 0)
            c(w(i,1)+1,w(i,2)) = w(i,4);
            dc(w(i,1)+1,w(i,2)) = w(i,6);
        end
    end
end


snorm(1) = 1.0;
k = zeros(13);
fn = zeros(13,1);
fm = zeros(13,1);
for n=1:12 
    snorm(n+1) = snorm(n)*(2*n-1)/n;
    j = 2;
    m = 0;
    D1 = 1;
    for D2=(n-m+D1)/D1:-1:1
        k(m+1,n+1) = ((n-1)*(n-1)-(m*m))/((2*n-1)*(2*n-3));
        if (m > 0)
            flnmj = ((n-m+1)*j)/(n+m);
            snorm(n+1+m*13) = snorm(n+1+(m-1)*13)*sqrt(flnmj);
            j = 1;
            c(n+1,m) = snorm(n+1+m*13)*c(n+1,m);
            dc(n+1,m) = snorm(n+1+m*13)*dc(n+1,m);
        end
        c(m+1,n+1) = snorm(n+1+m*13)*c(m+1,n+1);
        dc(m+1,n+1) = snorm(n+1+m*13)*dc(m+1,n+1);
        m=m+D1;
    end
    fn(n+1) = n+1;
    fm(n+1) = n;
end
k(2,2) = 0.0;



