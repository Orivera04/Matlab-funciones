function [locs,vals] = pickpeaks(A,Npeaks,plotting)

% PICKPEAKS Search for discrete peaks in a matrix.
%
%  [LOCS,VALS] = PICKPEAKS(A,N) returns the N highest discrete peaks.  The
%  algorithms finds the global maximum first, then searches for peaks by
%  blanking the pixels around the previous maximum.  The next peak must not
%  be immediately adjacent to the blanked area.
%  
%  The returned values are LOCS = [j_1 ... j_Npeaks ;
%                                  i_1 ... i_Npeaks]
%
%                      and VALS = [v_1 ... v_Npeaks],
%
%  where the j are column indeces, the i are row indeces and the v are peak
%  values. 
%
% If PLOTTING is present and equal to 1, the a progress plot of the search is done.
% 
% Example: 
%  [x,y,z]=peaks;
%  [locs,vals]=pickpeaks(z,3);
%  clf
%  mesh(z),hold on
%  for i=1:3,plot3(locs(1,i),locs(2,i),vals(i),'*'),end
%
% (See also PICKPEAK.)

% Andrew Knight, 24 September 1997

if nargin<3
   plotting = 0;
end

[M,N] = size(A);
bottom = min(min(A));
locs = NaN*ones(2,Npeaks);
vals = NaN*ones(1,Npeaks);

% Find global peak:
[v,j] = max(max(A));
[v,i] = max(A(:,j));
Nfound = 1;

locs(:,1) = [j ; i];
vals = v;

% Create first blank region:

A(i,j) = bottom;
Iblank = {i};
Jblank = {j};

while Nfound < Npeaks

  % Blank latest max (to get here the peak must not be adjacent)

  % Find new max
  [v,j] = max(max(A));
  [v,i] = max(A(:,j));
  
  % Check for adjacency to all previous blank regions
  adjacent = 0;
  this_blank = 0;
  while ~adjacent & this_blank<Nfound  % (quit loop at first adjacency)
    this_blank = this_blank + 1;
    iblank = Iblank{this_blank};
    jblank = Jblank{this_blank};
    % define adjacent 
    imin = min(iblank);
    imax = max(iblank);
    jmin = min(jblank);
    jmax = max(jblank);
    % There are eight possibilities...
    % 4 sides...
    up    = (i==imax+1) & (jmin<=j & j<=jmax);
    down  = (i==imin-1) & (jmin<=j & j<=jmax);
    left  = (j==jmin-1) & (imin<=i & i<=imax);
    right = (j==jmax+1) & (imin<=i & i<=imax);
    % and 4 corners:
    tl = (i==imax+1) & (j==jmin-1);
    tr = (i==imax+1) & (j==jmax+1);
    bl = (i==imin-1) & (j==jmin-1);
    br = (i==imin-1) & (j==jmax+1);
    adjacent = up | down | left | right | tl | tr | bl | br;
    if adjacent
      adj_blank = this_blank;
      if up 
	adj_type = 'up';
      elseif down
	adj_type = 'down';
      elseif left
	adj_type = 'left';
      elseif right
	adj_type = 'right';
      elseif tl
	adj_type = 'tl';
      elseif tr
	adj_type = 'tr';
      elseif bl
	adj_type = 'bl';
      elseif br
	adj_type = 'br';
      end
    end
  end
  if adjacent
    % Expand the relevant blank region in the appropriate direction
    iblank = Iblank{adj_blank};
    jblank = Jblank{adj_blank};
    imin = min(iblank);
    imax = max(iblank);
    jmin = min(jblank);
    jmax = max(jblank);
    if strcmp(adj_type,'up')
      iblank = [iblank imax+1];
      Iblank{adj_blank} = iblank;
      
    elseif strcmp(adj_type,'down')
      iblank = [imin-1 iblank];
      Iblank{adj_blank} = iblank;
      
    elseif strcmp(adj_type,'left')
      jblank = [jmin-1 jblank];
      Jblank{adj_blank} = jblank;
      
    elseif strcmp(adj_type,'right')
      jblank = [jblank jmax+1];
      Jblank{adj_blank} = jblank;
      
    elseif strcmp(adj_type,'tl')
      iblank = [iblank imax+1];
      jblank = [jmin-1 jblank];
      Iblank{adj_blank} = iblank;
      Jblank{adj_blank} = jblank;
      
    elseif strcmp(adj_type,'tr')
      iblank = [iblank imax+1];
      jblank = [jblank jmax+1];
      Iblank{adj_blank} = iblank;
      Jblank{adj_blank} = jblank;
      
    elseif strcmp(adj_type,'bl')
      iblank = [imin-1 iblank];
      jblank = [jmin-1 jblank];
      Iblank{adj_blank} = iblank;
      Jblank{adj_blank} = jblank;
      
    elseif strcmp(adj_type,'br')
      iblank = [imin-1 iblank];
      jblank = [jblank jmax+1];
      Iblank{adj_blank} = iblank;
      Jblank{adj_blank} = jblank;
      
    end
    A(iblank,jblank) = bottom;
    if plotting
      clf
      imagesc(A)
      set(gca,'xgrid','on','ygrid','on','layer','top',...
	  'ydir','normal')
      hold on
      plot(j,i,'x')
      for ii = 1:Nfound
	text(locs(1,ii),locs(2,ii),int2str(ii))
      end
      xlabel('J')
      ylabel('I')
      text(j,i,[' ' adj_type ' w.r.t. blank number ' int2str(adj_blank)])
      drawnow
    end
  else    
    % The candidate peak was not adjacent to any previous blanks, so
    % it is a good peak!  We add it to the list of good peaks and begin a
    % new blank region.
    Nfound = Nfound + 1;
    locs(:,Nfound) = [j ; i];
    vals(Nfound) = v;
    A(i,j) = bottom;
    Iblank{Nfound} = i;
    Jblank{Nfound} = j;
    if plotting
      clf
      imagesc(A)
      set(gca,'xgrid','on','ygrid','on','layer','top',...
	  'ydir','normal')
      hold on
      plot(j,i,'x')
      for ii = 1:Nfound
	text(locs(1,ii),locs(2,ii),int2str(ii))
      end
      xlabel('J')
      ylabel('I')
      drawnow
    end
  end
end