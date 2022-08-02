function scroll_vtrans(maxdim)

% Scrolls vertically through Transition matrix & First Passage Time

global state_vector P fpt TransColLabelHandle TransRowLabelHandle ...
       TransMatrixHandle MeanFPTHandle VarFPTHandle

offset = floor((size(P, 2) - maxdim)*(1-get(gcbo, 'Value'))) ;

% Is the transition matrix currently visible?
trans_invisible = isempty(get(TransMatrixHandle(1,1), 'String')) ; 

% get state_vector index of current column label
lower_col_index = find(state_vector == str2num(get(TransColLabelHandle(1), 'String'))) ;

% Update Row Label, FPT, and Transition Matrix, in that order
% k=column, j=row
for j = 1:maxdim
  set(TransRowLabelHandle(j), 'String', sprintf('%d', state_vector(j+offset))) ;
  if not(isempty(fpt))
     if size(fpt,2) == 1 %the call came from gmm
        set(MeanFPTHandle(j), 'String', sprintf('%f', fpt(j+offset,1))) ;
     else %the call came from ctmm or dtmm
     set(MeanFPTHandle(j), 'String', sprintf('%f', fpt(j+offset,2))) ;
     set(VarFPTHandle(j), 'String', sprintf('%f', fpt(j+offset,3))) ;
     end;
  end
  if not(trans_invisible)
    for k = 1:maxdim
      set(TransMatrixHandle(j,k), 'String', sprintf('%10.8f', P(j+offset, k+lower_col_index-1))) ;
    end
  end
end


