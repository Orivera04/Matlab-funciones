function varargout=aeroicon(varargin)
% AEROICON Gateway function to the private directory of Aerospace Blockset.

%   Copyright 1990-2003 The MathWorks, Inc.
%   $Revision: 1.8.2.9 $  $Date: 2004/04/06 01:03:53 $

if nargin==0
    error('aeroblks:aeroicon:invalidusage', ...
    'AEROICON is a gateway function for Aerospace Blockset to access its private directory.');
end
action = varargin{1};
p={};

switch action
    % Icons for aerolib blocks:
case 'aeroblk3dofbody'
   if (length(varargin) < 2)
       aeroblk3dofbody;
   else
       p{1} = aeroblk3dofbody(varargin{2});
   end  
case 'aeroblk6dofbody'
   if (length(varargin) < 2)
       aeroblk6dofbody;
   else
       p{1} = aeroblk6dofbody(varargin{2});
   end  
case 'aeroblkascorr'
   if (length(varargin) < 2)
       aeroblkascorr;
   else
       [p{1},p{2}] = aeroblkascorr(varargin{2});
       p{3}=load('aeroblkascorrdata.mat');
   end  
case 'aeroblkatmos'
   if (length(varargin) < 2)
       aeroblkatmos;
   else
       [p{1}]= aeroblkatmos(varargin{2});
   end  
case 'aeroblkcoesa'
   if (length(varargin) < 2)
       aeroblkcoesa;
   else
       [p{1}]= aeroblkcoesa(varargin{2});
   end  
case 'aeroblkconversion'
   if (length(varargin) < 2)
       aeroblkconversion;
   else
       [p{1},p{2},p{3}]= aeroblkconversion(varargin{2});
   end  
case 'aeroblkgravity' 
   if (length(varargin) < 2)
       aeroblkgravity;
   else
       [p{1}, p{2}]= aeroblkgravity(varargin{2});
   end
case 'aeroblkhwind'
   if (length(varargin) < 2)
       aeroblkhwind;
   else
       [p{1}]= aeroblkhwind(varargin{2});
   end    
case 'aeroblkisa'
   if (length(varargin) < 2)
       aeroblkisa;
   else
       [p{1}]= aeroblkisa(varargin{2});
   end  
case 'aeroblkpalt' 
       [p{1}]= aeroblkpalt(varargin{2});
case 'aeroblkratio'
   if (length(varargin) < 2)
       aeroblkratio;
   elseif (length(varargin) < 3)
       [p{1}]=aeroblkratio(varargin{2});
   else
       aeroblkratio(varargin{3});
   end  
case 'aeroblkturbofan'
   if (length(varargin) < 2)
       aeroblkturbine;
   else
       [p{1}]= aeroblkturbine(varargin{2});
       [p{2},p{3},p{4}] = aeroblkturbofandata;
   end  
case 'aeroblkwindgust' 
   aeroblkwindgust;
case 'aeroblkwindshear' 
   aeroblkwindshear;
case 'aeroblkwindturb' 
   aeroblkwindturb;
case 'aeroblkwindgust2' 
   if (length(varargin) < 2)
       aeroblkwindgust2;
   else
       [p{1}]= aeroblkwindgust2(varargin{2});
   end  
case 'aeroblkwindshear2' 
   if (length(varargin) < 2)
       aeroblkwindshear2;
   else
       [p{1}]= aeroblkwindshear2(varargin{2});
   end  
case 'aeroblkwindturb2'
   if (length(varargin) < 2)
       aeroblkwindturb2;
   else
       [p{1}]= aeroblkwindturb2(varargin{2});
   end
case 'aeroblkwmm'
   persistent maxdef epoch c dc fn fm snorm k
   if (length(varargin) < 2)
       aeroblkwmm;
   else
       [p{1},p{2}]= aeroblkwmm(varargin{2});
       if isempty(maxdef)
           load aeroblkwmm2000;
       end
       p{3} = maxdef;
       p{4} = epoch;
       p{5} = c;
       p{6} = dc;
       p{7} = fn;
       p{8} = fm;
       p{9} = snorm;
       p{10} = k;
   end  
otherwise
    error('aeroblks:aeroicon:invalidblock', ...
    'AEROICON is a gateway function for Aerospace Blockset to access its private directory.');  
end

if nargout ~= 0
    varargout = cell(nargout,1);
end

if ~isempty(p)
    for i=1:nargout,
        varargout(i)={p{i}};
    end
else
    % return dummy values
    for i=1:nargout,
        varargout(i)={0};
    end
end














