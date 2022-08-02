function [flag] = verifydata(data)
% VERIFYDATA Verify input data for use with the Marine Visualization Toolbox.
%    [FLAG] = VERIFYDATA(DATA) analyzes the structure of DATA. DATA must be
%    of class struct and the following requirements applies to the fields:
%
%       Field name:      Field class:
%           t              [nx1] double vector
%           x              [nx6] double array
%          type            char array
%          name            char array
%
%    Note: The fields 'type' and 'name' are optional, VERIFYDATA will return
%    FLAG = TRUE if they don't exist. If they do exist they must be of class 
%    char array, otherwise FLAG = FALSE is returned.
%
% See also STRUCT, CREATEVRML, TYPEDEF.
%
% Author:    Andreas Lund Danielsen
% Date:      5th November 2003
% Revisions: 


% set default return value
flag = false;

% is there any input at all
if ~nargin    
    % display warning and return FLAG = false
    warning('VISUAL:DataVerificationError', 'No input argument.');
    return;    
end

disp('% Started verifying data:');

% is input argument of class struct?
if ~isa(data, 'struct')    
    % display warning and return FLAG  = false
    warning('VISUAL:DataVerificationError', 'Input argument is not of class struct.');
    return;    
end

% loop through all entries in input argument
for entry = 1:length(data)
    
    % display progress information
    disp(['%   - data entry: ' num2str(entry)]);
    
    % verify time vector, structrue field 't'
    % is there a field 't'?
    if ~isfield(data, 't')
        warning('VISUAL:DataVerificationError', 'Field ''t'' not found');
        disp(['Error occured in data entry ' num2str(entry) '.']);
        return;
    end
    % is t strictly increasing?
    for sample = 1:length(data(entry).t)-1
        if data(entry).t(sample) - data(entry).t(sample+1) >= 0
            warning('VISUAL:DataVerificationError', 'Field ''t'' is not strictly increasing');
            disp(['Error occured at sample ' num2str(sample) ', in data entry ' num2str(entry) '.']);
            return;
        end
    end
    
    length_t = size(data(entry).t, 1);
    width_t = size(data(entry).t, 2);
    % is time vector not one dimensional
    if width_t ~= 1
        warning('VISUAL:DataVerificationError', ...
                 ['Time vector not a column vector! Time vector in SIMDATA(' ...
                 num2str(entry) ') has dimensions ' num2str(length_t) 'x' ...
                 num2str(width_t)]);
        return;
    end

    % verify vessel state dimensions, struct field x
    % is there a field 'x'?
    if ~isfield(data, 'x')
        warning('VISUAL:DataVerificationError', 'Field ''x'' not found');
        disp(['Error occured in data entry ' num2str(entry) '.']);
        return;
    end
    
    % is field 'x' double precision array?
    if ~isa(data(entry).x, 'double')
        warning('VISUAL:DataVerificationError', 'Field ''x'' is not a double precision array');
        disp(['Error occured in data entry ' num2str(entry) '.']);
        return;
    end

    % 'x' must be of same length as time vector
    % 'x' must have 6 columns/states: [x y z phi theta psi]
    if size(data(entry).x) ~= [length_t, 6]
        warning('VISUAL:DataVerificationError', ...
                 ['Dimension error in state array! Dimensions in SIMDATA('...
                 num2str(entry) ').x are (' num2str(size(data(entry).x))...
                 '), should be (' num2str(length_t) ' 6)']);
        return;
    end
    
    % verify class char in struct field type
    % is there a field 'type'?
    if isfield(data, 'type')
        
        % is field of class char?
        if ~isa(data(entry).type, 'char')
            warning('VISUAL:DataVerificationError', ...
                    ['Field DATA(' num2str(entry) ').type not of class char']);
            disp(['Error occured in data entry ' num2str(entry) '.']);
            return;
        end
        
    end
    
    % verify class char in struct field name
    % is there a field 'name'?
    if isfield(data, 'name')
        
        % is field of class char?
        if ~isa(data(entry).name, 'char')
            warning('VISUAL:DataVerificationError', ...
                    ['Field DATA(' num2str(entry) ').name not of class char']);
            disp(['Error occured in data entry ' num2str(entry) '.']);
            return;
        end
        
    end % if: field name

end % entry loop

% Finished verifying, return success!
flag = true;
disp('% All entries verified');