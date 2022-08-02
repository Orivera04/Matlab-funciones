function varargout=kp(varargin)
% function varargout=kp(varargin)
% keypressed handler

% here we don't need it
% ev_arglist=varargin{3:(end-2)};

ev_structure=varargin{end-1};

% here we don't need it
% ev_name=varargin{1};

KeyAscii=ev_structure.KeyAscii;

% it's a handle to our flexgrid object
h=ev_structure.Source;

if KeyAscii == 8 

     % backspace pressed

     s = h.TextMatrix(h.Row, h.Col);
     s=regexprep(s,'^\s+','');
     s=regexprep(s,'\s+$','');
     if length(s) > 0 
         s=s(1:end-1);
          h.Text=s;
          return
    else
          return
    end
 elseif KeyAscii ==13 

       % ENTER pressed

       if  h.Col < h.Cols-1 
            h.Col=h.Col+1;
       elseif h.Row<h.Rows-1 
            h.Col=1;
            h.Row = h.Row + 1;
            return
        end 
    else

        % in this application everything but numbers is filtered away

        if KeyAscii ~= '.' & (KeyAscii < '0' | KeyAscii > '9') 
         return
       end 
   end 
  h.Text = strcat(h.Text,char(KeyAscii));

    


