function ico_genere(outputFile,dir2browse,filter,ico_dim,trans_clr)

% Check input arguments
switch nargin
  case 0
    dir2browse = 'C:\DATA\PERSO\pics\TMW\soft';
    filter = 'bmp';
    ico_dim = [16 16];
    trans_clr = [1 0 1];
  case 1
    filter = 'bmp';
    ico_dim = [16 16];
    trans_clr = [1 0 1];
  case 2
    ico_dim = [16 16];
    trans_clr = 'BL';
  case 3
    trans_clr = 'BL';
end

% List the directory
list = dir(fullfile(dir2browse,['*.' filter]));

% Browse all files listed
for indIco=1:length(list)
  
  % Full path of the current image
  icoFile = fullfile(dir2browse,list(indIco).name);
  
  % Read the image
  [pic,map,alpha] = imread(icoFile,filter);
  
  % Convert indexed image to RGB image
  if length(size(pic)) == 2
    pic = ind2rgb8(pic,map);
  end
  
  % Picture dimensions
  icoSize = size(pic);

  if all(icoSize(1:2) == ico_dim)

      % Convert the picture matrix to double
      pic = double(pic);
      
      % Scale matrix values to fit the MATLAB color standard
      if max(max(max(pic))) > 1
        pic = pic / 255;
      end
      
      % Top left corner pixel is used as transparent color
      if ischar(trans_clr)
        switch trans_clr
          case 'TL'
            transClr = reshape(pic(1,1,:),1,3);
          case 'TR'
            transClr = reshape(pic(1,end,:),1,3);
          case 'BL'
            transClr = reshape(pic(end,1,:),1,3);
          case 'BR'
            transClr = reshape(pic(end,end,:),1,3);
        end
      else
        transClr = trans_clr;
      end
      
      % Build the mask for transparent pixels
      if isempty(alpha)
        mask = ...
          (pic(:,:,1)==transClr(1)) & ...
          (pic(:,:,2)==transClr(2)) & ...
          (pic(:,:,3)==transClr(3));
      else
        mask = alpha == 0;
      end

      % Replace transparent pixels by NaN
      pic(repmat(mask,[1 1 3])) = NaN;
      
      % Name of the field
      iconame = list(indIco).name(1:end-length(filter)-1);
      iconame = strrep(iconame,'-','_');
      iconame = strrep(iconame,' ','_');
      while ~isnan(str2double(iconame(1)))
        iconame = iconame(2:end);
      end

      % Store the icon in the ico structure in the MATLAB format (color values
      % must be between 0 and 1)
      ico.(iconame) = pic;
    
  end

end

% Save Icon File
save(outputFile,'ico');
