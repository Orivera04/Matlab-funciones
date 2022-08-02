function varargout = scaleupvarg(varargin)
%SCALEUPVARG Scalar Expansion and Dimension Checking of Input Arguments
%
%    varargout = scaleupvarg(varargin)
%
% Summary: Given a variable input argument list, this function does scalar 
%          expansion each input argument where necessary and checks for
%          size consistency among all input arguments.
%
%  Inputs: vargin
%
% Outputs: vargout
%
%See also:

%Author(s): C. Bassignani, 03-30-98 
%   Copyright 1995-2002 The MathWorks, Inc. 
%$Revision: 1.4 $   $Date: 2002/04/14 21:48:08 $ 

%Get the number of arguments in
NumArgs = nargin;

%Preallocate the size matrix
SizeMatrix = zeros(NumArgs, 2);

%Get the input argument cell array
Inputs = varargin;

%Loop through all the input arguments and write their sizes in the
%size matrix
for (i = 1 : NumArgs)
     SizeMatrix(i, :) = size(Inputs{i});
end

%Get the max size of all arguments
MaxRows = max(SizeMatrix(:, 1));
MaxColumns = max(SizeMatrix(:, 2));

%Loop through the arguments again to do scalar expansion
for (i = 1 : NumArgs)
     
     %Find all scalar and expand them
     if (length(Inputs{i}) == 1)
          
          Content = Inputs{i};
          
          Content = Content .* ones(MaxRows, MaxColumns);
          
          Inputs{i} = Content;
          
     elseif (~isempty(Inputs{i}) & ~(all(size(Inputs{i}) == ...
               [MaxRows MaxColumns])))
          
          error('Vector dimensions are inconsistent!')
     end
end %loop

varargout = Inputs;

%end of SCALEUPVARG function




