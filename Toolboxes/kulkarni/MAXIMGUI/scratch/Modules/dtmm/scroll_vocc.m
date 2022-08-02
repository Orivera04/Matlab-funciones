function scroll_vocc(maxdim)

% Scrolls vertically through Occupancy times matrix & Total Costs

global state_vector P total_cost occ_times OccColLabelHandle OccRowLabelHandle ...
       OccMatrixHandle MeanCostHandle 

offset = floor((size(P, 2) - maxdim)*(1-get(gcbo, 'Value'))) ;

% get state_vector index of current column label
lower_col_index = find(state_vector == str2num(get(OccColLabelHandle(1), 'String'))) ;

% Update Row Label, Total Costs, and Occupancy matrix in that order
% k=column, j=row
for j = 1:maxdim
  set(OccRowLabelHandle(j), 'String', sprintf('%d', state_vector(j+offset))) ;
  if not(isempty(total_cost))
    set(MeanCostHandle(j), 'String', sprintf('%f', total_cost(j+offset,1))) ;
  end
  if not(isempty(occ_times))
    for k = 1:maxdim
      set(OccMatrixHandle(j,k), 'String', sprintf('%10.8f', occ_times(j+offset, k+lower_col_index-1))) ;
    end
  end
end


