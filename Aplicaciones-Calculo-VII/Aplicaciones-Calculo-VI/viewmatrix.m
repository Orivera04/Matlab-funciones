function viewmatrix(x,c,alpha_value)
% VIEWMATRIX   Visualize 2d-matrices with colorful plots.
%     VIEWMATRIX(X) visualizes a NxM matrix by plotting each matrix entry
%     as a colored square. The entry value itself is also displayed. Since
%     the digits of the number are not plotted as regular text but as
%     bitmaps, the method scales the text for any matrix size.
%
%     VIEWMATRIX(X,C) uses the matrix C as the color matrix. Size of C
%     should be equal to the size of X.
%
%     VIEWMATRIX(X,C,ALPHA_VALUE) uses the number in aplha_value to make
%     the background transparent. Alpha_value must lie between 0.0 and 1.0, 
%     with 1.0 being opaque. Default value is 1.0.
% 
%     Examples:
%          x = magic(5), viewmatrix(x);
%          x = magic(5), c = rand(size(x)), viewmatrix(x,c);
%          viewmatrix(magic(5), [], 0.3);

%  Author : Mirza Faisal Baig
%  Version: 1.0
%  Date   : January 22, 2004

% Numbers defined as matrices to be diaplayed as textures
bitmapdata = { ...
         [0 0 0 0 0 0 0 0 0 0;
          0 0 0 0 1 1 0 0 0 0;
          0 0 0 1 1 1 0 0 0 0;
          0 0 1 1 1 1 0 0 0 0;
          0 1 1 0 1 1 0 0 0 0;
          0 0 0 0 1 1 0 0 0 0;
          0 0 0 0 1 1 0 0 0 0;
          0 0 0 0 1 1 0 0 0 0;
          0 0 0 0 1 1 0 0 0 0;
          0 0 0 0 1 1 0 0 0 0;
          0 0 0 0 1 1 0 0 0 0;
          0 0 0 0 1 1 0 0 0 0;
          0 0 0 0 1 1 0 0 0 0;
          0 1 1 1 1 1 1 1 1 0;
          0 0 0 0 0 0 0 0 0 0], 
 
         [0 0 0 0 0 0 0 0 0 0;
          0 0 0 1 1 1 1 0 0 0;
          0 0 1 1 0 0 1 1 0 0;
          0 1 1 0 0 0 0 1 1 0;
          0 1 1 0 0 0 0 1 1 0;
          0 0 0 0 0 0 0 1 1 0;
          0 0 0 0 0 0 0 1 1 0;
          0 0 0 0 0 0 1 1 0 0;
          0 0 0 0 1 1 1 0 0 0;
          0 0 0 1 1 0 0 0 0 0;
          0 0 1 1 0 0 0 0 0 0;
          0 1 1 0 0 0 0 0 0 0;
          0 1 1 0 0 0 0 0 0 0;
          0 1 1 1 1 1 1 1 1 0;
          0 0 0 0 0 0 0 0 0 0], 
 
         [0 0 0 0 0 0 0 0 0 0;
          0 0 0 1 1 1 1 0 0 0;
          0 0 1 1 0 0 1 1 0 0;
          0 1 1 0 0 0 0 1 1 0;
          0 1 1 0 0 0 0 1 1 0;
          0 0 0 0 0 0 0 1 1 0;
          0 0 0 0 0 0 1 1 0 0;
          0 0 0 0 1 1 1 0 0 0;
          0 0 0 0 0 0 1 1 0 0;
          0 0 0 0 0 0 0 1 1 0;
          0 1 1 0 0 0 0 1 1 0;
          0 1 1 0 0 0 0 1 1 0;
          0 0 1 1 0 0 1 1 0 0;
          0 0 0 1 1 1 1 0 0 0;
          0 0 0 0 0 0 0 0 0 0], 
      
         [0 0 0 0 0 0 0 0 0 0;
          0 0 0 0 0 0 0 1 0 0;
          0 0 0 0 0 0 1 1 0 0;
          0 0 0 0 0 1 1 1 0 0;
          0 0 0 0 1 1 1 1 0 0;
          0 0 0 1 1 0 1 1 0 0;
          0 0 1 1 0 0 1 1 0 0;
          0 1 1 0 0 0 1 1 0 0;
          0 1 1 0 0 0 1 1 0 0;
          0 1 1 1 1 1 1 1 1 0;
          0 0 0 0 0 0 1 1 0 0;
          0 0 0 0 0 0 1 1 0 0;
          0 0 0 0 0 0 1 1 0 0;
          0 0 0 0 0 0 1 1 0 0;
          0 0 0 0 0 0 0 0 0 0], 
      
         [0 0 0 0 0 0 0 0 0 0;
          0 1 1 1 1 1 1 1 1 0;
          0 1 1 0 0 0 0 0 0 0;
          0 1 1 0 0 0 0 0 0 0;
          0 1 1 0 0 0 0 0 0 0;
          0 1 1 0 0 0 0 0 0 0;
          0 1 1 0 1 1 1 0 0 0;
          0 1 1 1 0 0 1 1 0 0;
          0 0 0 0 0 0 0 1 1 0;
          0 0 0 0 0 0 0 1 1 0;
          0 0 0 0 0 0 0 1 1 0;
          0 1 1 0 0 0 0 1 1 0;
          0 0 1 1 0 0 1 1 0 0;
          0 0 0 1 1 1 1 0 0 0;
          0 0 0 0 0 0 0 0 0 0], 
      
         [0 0 0 0 0 0 0 0 0 0;
          0 0 0 1 1 1 1 0 0 0;
          0 0 1 1 0 0 1 1 0 0;
          0 1 1 0 0 0 0 1 0 0;
          0 1 1 0 0 0 0 0 0 0;
          0 1 1 0 0 0 0 0 0 0;
          0 1 1 0 1 1 1 0 0 0;
          0 1 1 1 0 0 1 1 0 0;
          0 1 1 0 0 0 0 1 1 0;
          0 1 1 0 0 0 0 1 1 0;
          0 1 1 0 0 0 0 1 1 0;
          0 1 1 0 0 0 0 1 1 0;
          0 0 1 1 0 0 1 1 0 0;
          0 0 0 1 1 1 1 0 0 0;
          0 0 0 0 0 0 0 0 0 0], 
      
         [0 0 0 0 0 0 0 0 0 0;
          0 1 1 1 1 1 1 1 1 0;
          0 0 0 0 0 0 0 1 1 0;
          0 0 0 0 0 0 0 1 1 0;
          0 0 0 0 0 0 1 1 0 0;
          0 0 0 0 0 0 1 1 0 0;
          0 0 0 0 0 1 1 0 0 0;
          0 0 0 0 0 1 1 0 0 0;
          0 0 0 0 1 1 0 0 0 0;
          0 0 0 0 1 1 0 0 0 0;
          0 0 0 1 1 0 0 0 0 0;
          0 0 0 1 1 0 0 0 0 0;
          0 0 1 1 0 0 0 0 0 0;
          0 0 1 1 0 0 0 0 0 0;
          0 0 0 0 0 0 0 0 0 0], 
        
         [0 0 0 0 0 0 0 0 0 0;
          0 0 0 1 1 1 1 0 0 0;
          0 0 1 1 0 0 1 1 0 0;
          0 1 1 0 0 0 0 1 1 0;
          0 1 1 0 0 0 0 1 1 0;
          0 1 1 0 0 0 0 1 1 0;
          0 0 1 1 0 0 1 1 0 0;
          0 0 0 1 1 1 1 0 0 0;
          0 0 1 1 0 0 1 1 0 0;
          0 1 1 0 0 0 0 1 1 0;
          0 1 1 0 0 0 0 1 1 0;
          0 1 1 0 0 0 0 1 1 0;
          0 0 1 1 0 0 1 1 0 0;
          0 0 0 1 1 1 1 0 0 0;
          0 0 0 0 0 0 0 0 0 0], 
         
         [0 0 0 0 0 0 0 0 0 0;
          0 0 0 1 1 1 1 0 0 0;
          0 0 1 1 0 0 1 1 0 0;
          0 1 1 0 0 0 0 1 1 0;
          0 1 1 0 0 0 0 1 1 0;
          0 1 1 0 0 0 0 1 1 0;
          0 1 1 0 0 0 0 1 1 0;
          0 0 1 1 0 0 1 1 1 0;
          0 0 0 1 1 1 0 1 1 0;
          0 0 0 0 0 0 0 1 1 0;
          0 0 0 0 0 0 0 1 1 0;
          0 0 1 0 0 0 0 1 1 0;
          0 0 1 1 0 0 1 1 0 0;
          0 0 0 1 1 1 1 0 0 0;
          0 0 0 0 0 0 0 0 0 0], 
         
         [0 0 0 0 0 0 0 0 0 0;
          0 0 0 0 1 1 0 0 0 0;
          0 0 0 1 1 1 1 0 0 0;
          0 0 1 1 0 0 1 1 0 0;
          0 0 1 1 0 0 1 1 0 0;
          0 1 1 0 0 0 0 1 1 0;
          0 1 1 0 0 0 0 1 1 0;
          0 1 1 0 0 0 0 1 1 0;
          0 1 1 0 0 0 0 1 1 0;
          0 1 1 0 0 0 0 1 1 0;
          0 0 1 1 0 0 1 1 0 0;
          0 0 1 1 0 0 1 1 0 0;
          0 0 0 1 1 1 1 0 0 0;
          0 0 0 0 1 1 0 0 0 0;
          0 0 0 0 0 0 0 0 0 0], 
        
         [0 0 0 0 0 0 0 0 0 0;
          0 0 0 0 0 0 0 0 0 0;
          0 0 0 0 0 0 0 0 0 0;
          0 0 0 0 0 0 0 0 0 0;
          0 0 0 0 0 0 0 0 0 0;
          0 0 0 0 0 0 0 0 0 0;
          0 0 0 0 0 0 0 0 0 0;
          0 0 0 0 0 0 0 0 0 0;
          0 0 0 0 0 0 0 0 0 0;
          0 0 0 0 0 0 0 0 0 0;
          0 0 0 0 0 0 0 0 0 0;
          0 0 0 1 1 1 1 0 0 0;
          0 0 0 1 1 1 1 0 0 0;
          0 0 0 1 1 1 1 0 0 0;
          0 0 0 0 0 0 0 0 0 0], 
         
         [0 0 0 0 0 0 0 0 0 0;
          0 0 0 0 0 0 0 0 0 0;
          0 0 0 0 0 0 0 0 0 0;
          0 0 0 0 0 0 0 0 0 0;
          0 0 0 0 0 0 0 0 0 0;
          0 0 0 0 0 0 0 0 0 0;
          0 0 0 0 0 0 0 0 0 0;
          0 1 1 1 1 1 1 1 1 0;
          0 0 0 0 0 0 0 0 0 0;
          0 0 0 0 0 0 0 0 0 0;
          0 0 0 0 0 0 0 0 0 0;
          0 0 0 0 0 0 0 0 0 0;
          0 0 0 0 0 0 0 0 0 0;
          0 0 0 0 0 0 0 0 0 0;
          0 0 0 0 0 0 0 0 0 0], 
         
         [0 0 0 0 0 0 0 0 0 0;
          0 0 0 0 0 0 0 0 0 0;
          0 0 0 0 0 0 0 0 0 0;
          0 0 0 0 0 0 0 0 0 0;
          0 0 0 0 0 0 0 0 0 0;
          0 0 0 1 1 1 1 0 0 0;
          0 0 1 1 0 0 0 1 1 0;
          0 1 1 0 0 0 0 1 1 0;
          0 1 1 1 1 1 1 1 1 0;
          0 1 0 0 1 0 0 0 0 0;
          0 1 1 0 0 0 0 0 0 0;
          0 1 1 0 0 0 0 0 0 0;
          0 0 1 1 0 0 0 1 1 0;
          0 0 0 1 1 1 1 1 0 0;
          0 0 0 0 0 0 0 0 0 0], 
                                 };

% Characters defined to identify the numbers                                 
chars = {'1', '2', '3','4', '5', '6', '7','8', '9','0','.','-','e'};

% If color matrix is not defined use default color matrix
if nargin < 2
    c = [];
end
if isempty(c)   
    c = x/max(x(:))*.9;
else
    c = c*.9;
end

%If alpha_value is not defined use default value 
if nargin < 3
    alpha_value = 1;
end

clf;

[numrow,numcol] = size(x); % number of rows and columns of the matrix x
%total_elements = numrow*numcol;
con = 1; % counter to find the maximum size of the texture matrix
for row=1:numrow
   for col=1:numcol,
       %To convert each number to its corresponding texture matrix
       num_matrix = number2matrix(x(row,col),chars,bitmapdata);
       p{row,col} = num_matrix;
       [rowdata,coldata] = size(num_matrix);     % number of rows and columns of the texture matrix
       max_dim_temp(con) = max(rowdata,coldata); % save the maximum
       con = con+1;                              % increment counter con
   end % end of "for col"
end % end of "for row"

max_dim = max(max_dim_temp); % pick the maximum size from all the texture matrices

for i = 1:numrow
    for k = 1:numcol
         % Assign the texture matrix to variable data starting from last row and first column
        data = p{numrow+1-i,k};        
        [rowdata,coldata] = size(data);
        factorY = rowdata/max_dim;   % scaling factor according to the dimenions of the texture matrix
        factorX = coldata/max_dim;   % scaling factor according to the dimenions of the texture matrix
        x_init_back = [k-1,k];       % column index for background box   
        y_init_back = [i-1,i];       % row index for background box
        a1 = x_init_back(1)+0.5-factorX/2;    % x-coor of bottom left corner of the texture
        a2 = x_init_back(1)+0.5+factorX/2;    % x-coor of bottom right corner of the texture
        b1 = y_init_back(1)+0.5-factorY/2;    % y-coor of bottom right corner of the texture
        b2 = y_init_back(1)+0.5+factorY/2;    % y-coor of upper right corner of the texture
        z_init = zeros(length(x_init_back),length(y_init_back)); % zeros matrix to plot surface
        
        % To plot the background color boxes
        back_ground = surface(x_init_back,y_init_back,z_init,c(numrow+1-i,k));
        
        % To plot the foreground box for the texture
        for_ground = surface([a1 a2],[b1 b2],z_init);
        set(back_ground,'FaceAlpha',alpha_value)  % to make background transparent
        
        % To set the texture to the foreground box
        set(for_ground,'Cdata',flipud(data),'AlphaData',flipud(data),'FaceColor','Texture',...
                                         'FaceAlpha','Texture','LineStyle','None') 
    end
end
a = colormap;       % current figure colormap
a(end,:) = [0 0 0]; % to change the last color value to back
colormap(a)         % change the colormap
axis equal          % make axis of the plot equal
box on              % make border line of the plot visible
axis off            % make the axis numbers and lines invisible
return % end of the main function

%-----------------------------------------------------------
% Function to convert number (real of intergers) into their corresponding
% texture matrices

function res = number2matrix(n, chars, bitmapdata)

n = num2str(n);                % change number to the string
res = [];                      % initialize res variable
for i = 1:length(n)        
    for k = 1:length(chars)
        if n(i) == chars{k}
            m = bitmapdata{k}; % assign texture to the variable
            break;             % if number found stop
        end % end "if n(i)"
    end % end "for k"
    res = [res m];             % concatenate the result
end % end "for i"
