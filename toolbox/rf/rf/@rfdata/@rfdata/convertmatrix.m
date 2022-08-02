function outMatrix=convertmatrix(h,inMatrix,inType,outType,z0,z0_option,iteration)
%CONVERTMATRIX Convert the network parameters.
%   OUTMATRIX = CONVERTMATRIX(H, INMATRIX, INTYPE, OUTTYPE, Z0, Z0_OPTION)
%   converts the input network parameters INMATRIX to the specified output type
%   OUTTYPE and returns it. If there is only one S_PARAMETERS (either INTYPE or
%   OUTTYPE), Z0 is the reference impedance of the S-parameters. If both
%   INTYPE and OUTTYPE are S_PARAMETERS, Z0 is for INMATRIX while Z0_OPTION for
%   OUTMATRIX.
%
%   INMATRIX is a complex NxNxM array, representing M N-port network parameters.
%   INTYPE:    'ABCD_PARAMETERS', 'S_PARAMETERS', 'Y_PARAMETERS'
%               'Z_PARAMETERS', 'H_PARAMETERS', 'T_PARAMETERS'
%   OUTTYPE:    'ABCD_PARAMETERS', 'S_PARAMETERS', 'Y_PARAMETERS'
%               'Z_PARAMETERS', 'H_PARAMETERS', 'T_PARAMETERS'
%   Z0 is the reference impedance of S-parameters. If not given, 50 Ohms is
%   used. Z0_OPTION is an optional reference impedance of S-parameters
%   matrix. If not given, 50 Ohms is used.  
%   OUTMATRIX is a complex NxNxM array, representing M N-port network parameters.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision  $  $Date: 2004/04/12 23:38:45 $

% Check the input network parameters
if isempty(inMatrix)
    id = sprintf('rf:%s:convertmatrix:NoInput', strrep(class(h),'.',':'));
    error(id, 'There is not input network parameters.');
end
[n1,n2,m] = size(inMatrix);
if (n1 ~= n2)
    id = sprintf('rf:%s:convertmatrix:WrongMatrix', strrep(class(h),'.',':'));
    error(id, 'Input network parameters must be a complex NxNxM array.');
end

% Set the default result
outMatrix = [];

inType = upper(inType);
outType = upper(outType);

% Get Z0
if nargin < 5
    z0 = 50;
elseif ~isnumeric(z0) || ((length(z0) ~= 1)&&(length(z0) ~= m))
    id = sprintf('rf:%s:convertmatrix:WrongImpedance', strrep(class(h),'.',':'));
    error(id, 'The reference impedance must be a scalar or vector of length M.');
end
% Get Z0_OPTION
if nargin < 6
    z0_option = 50;
elseif ~isnumeric(z0_option) || ((length(z0_option) ~= 1) && ...
        (length(z0_option) ~= m))
    id = sprintf('rf:%s:convertmatrix:WrongImpedance', strrep(class(h),'.',':'));
    error(id, 'The reference impedance must be a scalar or vector of length M.');
end

% Do matrix conversion if the method is available
switch inType
case {'ABCD_PARAMETERS' 'ABCD-PARAMETERS' 'ABCD_PARAMS' 'ABCD-PARAMS' 'ABCD'}
    switch outType
    case {'S_PARAMETERS' 'S-PARAMETERS' 'S_PARAMS' 'S-PARAMS' 'S'}
        outMatrix = abcd2s(inMatrix, z0);
    case {'Y_PARAMETERS' 'Y-PARAMETERS' 'Y_PARAMS' 'Y-PARAMS' 'Y'}
        outMatrix = abcd2y(inMatrix);
    case {'Z_PARAMETERS' 'Z-PARAMETERS' 'Z_PARAMS' 'Z-PARAMS' 'Z'}
        outMatrix = abcd2z(inMatrix);
    case {'H_PARAMETERS' 'H-PARAMETERS' 'H_PARAMS' 'H-PARAMS' 'H'}
        outMatrix = abcd2h(inMatrix);
    case {'ABCD_PARAMETERS' 'ABCD-PARAMETERS' 'ABCD_PARAMS' 'ABCD-PARAMS' 'ABCD'}
        outMatrix = inMatrix;
        return;
    otherwise
         id = sprintf('rf:%s:convertmatrix:NoConversionMethod', strrep(class(h),'.',':'));
         error(id, sprintf('No method available for matrix conversion from %s to %s.', ...
             inType, outType));
    end
case {'Y_PARAMETERS' 'Y-PARAMETERS' 'Y_PARAMS' 'Y-PARAMS' 'Y'}
    switch outType
    case {'S_PARAMETERS' 'S-PARAMETERS' 'S_PARAMS' 'S-PARAMS' 'S'}
        outMatrix = y2s(inMatrix, z0);
    case {'Z_PARAMETERS' 'Z-PARAMETERS' 'Z_PARAMS' 'Z-PARAMS' 'Z'}
        outMatrix = y2z(inMatrix);
    case {'ABCD_PARAMETERS' 'ABCD-PARAMETERS' 'ABCD_PARAMS' 'ABCD-PARAMS' 'ABCD'}
        outMatrix = y2abcd(inMatrix);
    case {'H_PARAMETERS' 'H-PARAMETERS' 'H_PARAMS' 'H-PARAMS' 'H'}
        outMatrix = y2h(inMatrix);
    case {'Y_PARAMETERS' 'Y-PARAMETERS' 'Y_PARAMS' 'Y-PARAMS' 'Y'}
        outMatrix = inMatrix;
        return;
        otherwise
        id = sprintf('rf:%s:convertmatrix:NoConversionMethod', strrep(class(h),'.',':'));
        error(id, sprintf('No method available for matrix conversion from %s to %s.', ...
            inType, outType));
    end
case {'Z_PARAMETERS' 'Z-PARAMETERS' 'Z_PARAMS' 'Z-PARAMS' 'Z'}
    switch outType
    case {'S_PARAMETERS' 'S-PARAMETERS' 'S_PARAMS' 'S-PARAMS' 'S'}
        outMatrix = z2s(inMatrix, z0);
    case {'Y_PARAMETERS' 'Y-PARAMETERS' 'Y_PARAMS' 'Y-PARAMS' 'Y'}
        outMatrix = z2y(inMatrix);
    case {'ABCD_PARAMETERS' 'ABCD-PARAMETERS' 'ABCD_PARAMS' 'ABCD-PARAMS' 'ABCD'}
        outMatrix = z2abcd(inMatrix);
    case {'H_PARAMETERS' 'H-PARAMETERS' 'H_PARAMS' 'H-PARAMS' 'H'}
        outMatrix = z2h(inMatrix);
    case {'Z_PARAMETERS' 'Z-PARAMETERS' 'Z_PARAMS' 'Z-PARAMS' 'Z'}
        outMatrix = inMatrix;
        return;
    otherwise
        id = sprintf('rf:%s:convertmatrix:NoConversionMethod', strrep(class(h),'.',':'));
        error(id, sprintf('No method available for matrix conversion from %s to %s.', ...
            inType, outType));
    end
case {'S_PARAMETERS' 'S-PARAMETERS' 'S_PARAMS' 'S-PARAMS' 'S'}
    switch outType
    case {'Y_PARAMETERS' 'Y-PARAMETERS' 'Y_PARAMS' 'Y-PARAMS' 'Y'}
        outMatrix = s2y(inMatrix, z0);
    case {'Z_PARAMETERS' 'Z-PARAMETERS' 'Z_PARAMS' 'Z-PARAMS' 'Z'}
        outMatrix = s2z(inMatrix, z0);
    case {'ABCD_PARAMETERS' 'ABCD-PARAMETERS' 'ABCD_PARAMS' 'ABCD-PARAMS' 'ABCD'}
        outMatrix = s2abcd(inMatrix, z0);
    case {'H_PARAMETERS' 'H-PARAMETERS' 'H_PARAMS' 'H-PARAMS' 'H'}
        outMatrix = s2h(inMatrix, z0);
    case {'T_PARAMETERS' 'T-PARAMETERS' 'T_PARAMS' 'T-PARAMS' 'T'}
        outMatrix = s2t(inMatrix);
    case {'S_PARAMETERS' 'S-PARAMETERS' 'S_PARAMS' 'S-PARAMS' 'S'}
        outMatrix = s2s(inMatrix, z0, z0_option);
        return;
    otherwise
        id = sprintf('rf:%s:convertmatrix:NoConversionMethod', strrep(class(h),'.',':'));
        error(id, sprintf('No method available for matrix conversion from %s to %s.', ...
            inType, outType));
    end
case {'H_PARAMETERS' 'H-PARAMETERS' 'H_PARAMS' 'H-PARAMS' 'H'}
    switch outType
    case {'Y_PARAMETERS' 'Y-PARAMETERS' 'Y_PARAMS' 'Y-PARAMS' 'Y'}
        outMatrix = h2y(inMatrix);
    case {'Z_PARAMETERS' 'Z-PARAMETERS' 'Z_PARAMS' 'Z-PARAMS' 'Z'}
        outMatrix = h2z(inMatrix);
    case {'S_PARAMETERS' 'S-PARAMETERS' 'S_PARAMS' 'S-PARAMS' 'S'}
        outMatrix = h2s(inMatrix, z0);
    case {'ABCD_PARAMETERS' 'ABCD-PARAMETERS' 'ABCD_PARAMS' 'ABCD-PARAMS' 'ABCD'}
        outMatrix = h2abcd(inMatrix);
    case {'H_PARAMETERS' 'H-PARAMETERS' 'H_PARAMS' 'H-PARAMS' 'H'}
        outMatrix = inMatrix;
        return;
    otherwise
        id = sprintf('rf:%s:convertmatrix:NoConversionMethod', strrep(class(h),'.',':'));
        error(id, sprintf('No method available for matrix conversion from %s to %s.', ...
            inType, outType));
    end
case {'T_PARAMETERS' 'T-PARAMETERS' 'T_PARAMS' 'T-PARAMS' 'T'}
    switch outType
    case {'S_PARAMETERS' 'S-PARAMETERS' 'S_PARAMS' 'S-PARAMS' 'S'}
        outMatrix = t2s(inMatrix);
    case {'T_PARAMETERS' 'T-PARAMETERS' 'T_PARAMS' 'T-PARAMS' 'T'}
        outMatrix = inMatrix;
        return;
    otherwise
        id = sprintf('rf:%s:convertmatrix:NoConversionMethod', strrep(class(h),'.',':'));
        error(id, sprintf('No method available for matrix conversion from %s to %s.', ...
            inType, outType));
    end
otherwise
     id = sprintf('rf:%s:convertmatrix:NoConversionMethod', strrep(class(h),'.',':'));
     error(id, sprintf('No method available for matrix conversion from %s to %s.', ...
         inType, outType));
end


% Check the output
index = any(any(isnan(outMatrix)));
if any(index)
    if nargin < 7
        iteration = 0;
    end
    iteration = iteration + 1;
    if iteration > 10
        id = sprintf('rf:%s:convertmatrix:MatrxNotExist', strrep(class(h),'.',':'));
        error(id, sprintf('%s matrix does not exist.', outType));
    end
    m = length(index);
    inMatrix(1,1,:) = inMatrix(1,1,:) + reshape(index(:) *eps, [1,1,m]);
    inMatrix(1,2,:) = inMatrix(1,2,:) - reshape(index(:) *eps, [1,1,m]);
    outMatrix = convertmatrix(h,inMatrix,inType,outType,z0,z0_option,iteration);
 end
