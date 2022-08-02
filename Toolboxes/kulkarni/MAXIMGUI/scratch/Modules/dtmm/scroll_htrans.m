function scroll_htrans(maxdim)

% Scrolls horizontally through Transition matrix & Transient Distribution

global state_vector P trans_dist TransColLabelHandle TransRowLabelHandle ...
       TransMatrixHandle TransDistHandle

offset = floor((size(P, 2) - maxdim)*(get(gcbo, 'Value'))) ;

% Is the transition matrix currently visible?
trans_invisible = isempty(get(TransMatrixHandle(1,1), 'String')) ;

% get state_vector index of current row label
lower_row_index = find(state_vector == str2num(get(TransRowLabelHandle(1), 'String'))) ;

% Update Column Label, Transient Distribution, and Transition Matrix, in that order
% k=column, j=row
for k = 1:maxdim
  set(TransColLabelHandle(k), 'String', sprintf('%d', state_vector(k+offset))) ;
  if not(isempty(trans_dist))
    set(TransDistHandle(k), 'String', sprintf('%10.8f', trans_dist(k+offset))) ;
  end
  if not(trans_invisible)
    for j = 1:maxdim
      set(TransMatrixHandle(j,k), 'String', sprintf('%10.8f', P(j+lower_row_index-1, k+offset))) ;
    end
  end
end

