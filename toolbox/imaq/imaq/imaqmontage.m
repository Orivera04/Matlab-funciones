function h = imaqmontage(data, clim)
%IMAQMONTAGE Display a sequence of image frames as a montage.
% 
%    IMAQMONTAGE(FRAMES) displays a montage of image frames in a MATLAB 
%    figure window using IMAGESC.
%
%    FRAMES can be any data set returned by GETDATA, PEEKDATA, or 
%    GETSNAPSHOT.
% 
%    IMAQMONTAGE(OBJ) calls GETSNAPSHOT on video input object OBJ and displays 
%    a single image frame in a MATLAB figure window using IMAGESC. OBJ must 
%    be a 1x1 video input object.
% 
%    IMAQMONTAGE(..., CLIM) where CLIM = [CLOW CHIGH] can specify the
%    image scaling. See IMAGESC for more information.
%
%    H = IMAQMONTAGE(...) returns a handle to an IMAGE object.
%
%    See also IMAGESC, IMAQHELP, IMAQDEVICE/GETDATA, IMAQDEVICE/PEEKDATA, 
%             IMAQDEVICE/GETSNAPSHOT, COLORMAP.

%    CP 1-22-03
%    Copyright 2001-2004 The MathWorks, Inc. 
%    $Revision: 1.1.6.4 $  $Date: 2004/03/05 18:09:26 $

% Error check.
argsIn = nargin;
if argsIn==0,
    errID = 'imaq:imaqmontage:noFrames';
    error(errID, imaqgate('privateMsgLookup', errID));
elseif argsIn==1,
    % Initialize CLIM.
    clim = [];
elseif argsIn==2,
    if ~isnumeric(clim) || (numel(clim) ~= 2),
        errID = 'imaq:imaqmontage:invalidClim';
        error(errID, imaqgate('privateMsgLookup', errID));
    else
        % CLIM needs to be a row vector.
        clim = clim(:)';
    end
end

% Parse input.
isCellData = false;
errID = 'imaq:imaqmontage:inputInvalid';
if ~isnumeric(data) || isempty(data),
    
    if isa(data, 'videoinput')
        % OBJ provided, get a frame, and determine 
        % the dimensions of the data set.
        try
            data = getsnapshot(data);
            [width, height, bands, nFrames] = size(data);
        catch
            rethrow(lasterror);
        end
        
    elseif iscell(data),
        % Determine the number of elements.
        nFrames = length(data);
        
        % Verify each element is valid.
        for c = 1:nFrames,
            if ~isnumeric(data{c}),
                error(errID, imaqgate('privateMsgLookup', errID));
            elseif c==1,
                % Determine the dimensions of the data set.
                [width, height, bands] = size(data{1});
                numDims = ndims(data{1});
                isCellData = true;                
            else
                [w, h, b] = size(data{c});
                if ~all([w h b]==[width height bands]) || (numDims~=ndims(data{c}))
                    errID2 = 'imaq:imaqmontage:sizeMismatch';
                    error(errID2, imaqgate('privateMsgLookup', errID2));
                end
            end
        end
        
    else
        % Invalid input.
        error(errID, imaqgate('privateMsgLookup', errID));
    end
    
else
    % Determine the dimensions of the data set, 
    % and a native data value.
    [width, height, bands, nFrames] = size(data);
end

% Determine a native data type value for casting purposes.
% Safer to do inside a TRY-CATCH in case we encounter [], 
% i.e. caller provides:
%   - imaqmontage(cell(1))
%   - GETSNAPSHOT returns []
%   - etc.
try
    if isCellData,
        nativeVal = data{1}(1, 1);
    else
        nativeVal = data(1, 1);
    end    
catch
    error(errID, imaqgate('privateMsgLookup', errID));
end

% All we want is the data type, not the pixel value.
% Make sure not to use the pixel color value.
nativeVal(1, 1) = 0;

% Displaying image frames can lead to a 
% different set of errors.
try
    if nargout==1
        h = localDisplay(width, height, bands, nFrames, nativeVal, data, isCellData, clim);
    else
        localDisplay(width, height, bands, nFrames, nativeVal, data, isCellData, clim);        
    end
catch
    rethrow(lasterror);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function im = localDisplay(width, height, bands, nFrames, nativeVal, data, isCellData, clim)

% Determine the number of axis rows and columns.
axCols = sqrt(nFrames);
if (axCols<1)
    % In case we have a slim image.
    axCols = 1;
end
axRows = nFrames/axCols;
if (ceil(axCols)-axCols) < (ceil(axRows)-axRows),
    axCols = ceil(axCols);
    axRows = ceil(nFrames/axCols);
else
    axRows = ceil(axRows); 
    axCols = ceil(nFrames/axRows);
end

% Size the storage to hold all frames.
storage = repmat(nativeVal, [axRows*width, axCols*height, bands, 1]);

% Fill the storage up with data pixels.
rows = 1:width; 
cols = 1:height;
if isCellData,
    % Cell array of matrices.
    for i=0:axRows-1,
        for j=0:axCols-1,
            k = j+i*axCols+1;
            if k<=nFrames,
                storage(rows+i*width, cols+j*height, :) = data{k}(:,:,:);
            else
                break;
            end
        end
    end
else
    % Regular old matrices.
    for i=0:axRows-1,
        for j=0:axCols-1,
            k = j+i*axCols+1;
            if k<=nFrames,
                storage(rows+i*width, cols+j*height, :) = data(:,:,:,k);
            else
                break;
            end
        end
    end
end

% Display the tiled frames nicely and 
% pop the window forward.
if isempty(clim),
    im = imagesc(storage);
else
    im = imagesc(storage, clim);
end
ax = get(im, 'Parent');
fig = get(ax, 'Parent');
set(ax, 'XTick', [], 'YTick', [])
figure(fig)

% If working with single band images, update the colormap.
if bands==1,
    colormap(gray);
end
