function val=oneovrei(x,EIdata,BeamProp)
% [val]=oneovrei(x,EIdata,BeamProp) 
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% This function computes 1/EI by piecewise 
% linear interpolation through a set of data 
% values.
%
% x        - location along beam
% EIdata   - EI or depth values
% BeamProp - null or width values
%
% val      - computed value for 1/EI
%
% User m functions required: none
%----------------------------------------------

if size(EIdata,1) < 2  % uniform depth case
  v=EIdata(1,1); 
  EIdata=[v,min(x);v,max(x)]; 
end
if ( nargin > 2 ) & ( sum(size(BeamProp)) > 0)
  % Compute properties assuming the cross 
  % section is rectangular and EIdata(:,1) 
  % contains depth values
  width=BeamProp(1); E=BeamProp(2);
  EIdata(:,1)=E*width/12*EIdata(:,1).^3; 
end
val=1./lintrp(EIdata(:,2),EIdata(:,1),x);