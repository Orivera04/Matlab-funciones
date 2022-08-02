function scroll_hocc(maxdim)

% Scrolls horizontally through Occupancy times matrix & Limiting/Occupancy Distribution

global state_vector P occ_times lim_occ OccColLabelHandle OccRowLabelHandle ...
       OccDistHandle OccMatrixHandle

offset = floor((size(P, 2) - maxdim)*(get(gcbo, 'Value'))) ;

% get state_vector index of current row label
lower_row_index = find(state_vector == str2num(get(OccRowLabelHandle(1), 'String'))) ;

% Update Column Label, Limiting Distribution, and Occupancy times Matrix, in that order
% k=column, j=row
for k = 1:maxdim
  set(OccColLabelHandle(k), 'String', sprintf('%d', state_vector(k+offset))) ;
  if not(isempty(lim_occ))
    set(OccDistHandle(k), 'String', sprintf('%10.8f', lim_occ(k+offset))) ;
  end
  if not(isempty(occ_times))
    for j = 1:maxdim
      set(OccMatrixHandle(j,k), 'String', sprintf('%10.8f', occ_times(j+lower_row_index-1, k+offset))) ;
    end
  end
end

