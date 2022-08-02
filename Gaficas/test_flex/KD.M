function varargout=kd(varargin)
% function varargout=kd(varargin)
% keydown handler

k=varargin{3};

% it's our flexgrid handle
h=varargin{1};

if ~isempty(find([37:40]==k))

        % handle up, down, left and right

	r=h.Row;
	c=h.Col;
	switch k
              case 38 % go up
                  r=max(1,r-1);
              case 40 % go down
                  r=min(h.Rows-1,r+1);
              case 37 % go left
                  c=max(1,c-1);
              case 39 % go right
                 c=min(h.Cols-1,c+1);
	end
        h.Row=r; 
        h.Col=c;
end

if k==46 % DEL pressed
    h.Text='';
end
