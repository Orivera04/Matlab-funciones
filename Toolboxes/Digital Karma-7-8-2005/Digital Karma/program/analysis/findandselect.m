analysis_area;
if exist('analysisarea');

if findandselectnext==0;  
findandreplacevalues=inputdlg(...
{'Enter find parameters.  Read ''Find Help'' for explanation','To set search size enter one of above matrices. Not a scalar if mixed.'},...
        'Find',1,{'findarea==[ ]','[ ]'});
if isempty(findandreplacevalues)==0; % means you entered something in the boxes

findexpression=findandreplacevalues{1};
findingmatrix=eval(findandreplacevalues{2});
findandselectcounter=1;

% Keep order
foundvaluelocations=0; foundvaluelocations2=0; trial=[0,0,0];
[findingrows, findingcolumns, findingplanes]=size(analysisarea);
finding=multi_dimension_transpose(analysisarea);
findingmatrix2=multi_dimension_transpose(findingmatrix);
findingplanessize=findingrows*findingcolumns;
[finding2rows, finding2columns, finding2planes]=size(finding);
[findingmatrixrows, findingmatrixcols, findingmatrixplanes]=size(findingmatrix2);


% This computes the find.  There was a one-line find for values.
% This complicated version does matricies or values.
% Rows & columns are reversed since the matrix was transposed!
% Its fixed again during selection at bottom.
% The transpose is because foundvaluelocations goes by element number,
% left to right.  And I want the search to go top to bottom. So we
% transpose everything.
for findcheckingplanes=1:finding2planes-(findingmatrixplanes-1);
    for findcheckingcol=1:finding2columns-(findingmatrixcols-1);
        for findcheckingrows=1:finding2rows-(findingmatrixrows-1);
            findarea=multi_dimension_transpose(finding(findcheckingrows:findcheckingrows+findingmatrixrows-1, findcheckingcol:findcheckingcol+findingmatrixcols-1,findcheckingplanes:findcheckingplanes+findingmatrixplanes-1));
            if findfeedbackdisplay==1; currentlyfindandselecting=1; CA_Display; end;
            if eval(findexpression);
                foundvaluelocations(end+1,:)=coordinate2element_num(finding,findcheckingrows,findcheckingcol,findcheckingplanes);
            end;
        end;
    end;
end;
foundvaluelocations=foundvaluelocations(2:end,:);  foundvaluelocations2=foundvaluelocations;
[findingmatrixrows, findingmatrixcols, findingmatrixplanes]=size(findingmatrix);

end;
end;

% Find Next counter
if findandselectnext==1;
    findandselectcounter=findandselectcounter+1;
    % Resets counter at end
    if findandselectcounter>length(foundvaluelocations);
        findandselectcounter=1;
    end;
end;

if exist('foundvaluelocations');

% Below calculates the selection area
if strcmp(analysisarealabel,'matrix') & isempty(foundvaluelocations)==0;
    if dimension==2; currentiterationspot=fix(foundvaluelocations(findandselectcounter)/findingplanessize);
        if mod(foundvaluelocations(findandselectcounter),findingplanessize)==0;
            currentiterationspot=fix(foundvaluelocations(findandselectcounter)/findingplanessize)-1; end;
    end;
    if foundvaluelocations(findandselectcounter)>findingplanessize;
        foundvaluelocations2(findandselectcounter)=foundvaluelocations(findandselectcounter)-(findingplanessize*currentiterationspot); end;
    currentxspot=mod(foundvaluelocations2(findandselectcounter),findingcolumns); if currentxspot==0; currentxspot=findingcolumns; end;
    currentyspot=ceil(foundvaluelocations2(findandselectcounter)/findingcolumns);
    currentx=currentxspot; currenty=currentyspot; if dimension==2; currentiteration=currentiterationspot; end;
    lastclicktype=['normal']; currentlyfindandselecting=1; selecting_button_down_script;
    if dimension==2; currentiteration=currentiterationspot+findingmatrixplanes-1; end;
    currentx=currentxspot+findingmatrixcols-1; currenty=currentyspot+findingmatrixrows-1;
    lastclicktype=['alt']; currentlyfindandselecting=1; selecting_button_down_script;
        
elseif strcmp(analysisarealabel,'graphed') & isempty(foundvaluelocations)==0;
    currentxspot=mod(foundvaluelocations2(findandselectcounter),findingcolumns); if currentxspot==0; currentx=findingcolumns; end;
    currentyspot=ceil(foundvaluelocations2(findandselectcounter)/findingcolumns);
    currentx=currentxspot+firstcolumn-1;
    if dimension==2; currenty=currentyspot+firstrow-1; 
    elseif dimension==1; if agraphingrows>=rows; currenty=currentyspot+currentiteration-rows+1; else; currenty=currentyspot; end
    end;
    lastclicktype=['normal']; currentlyfindandselecting=1; selecting_button_down_script;
    currentx=currentxspot+firstcolumn-1+findingmatrixcols-1;
    if dimension==2; currenty=currentyspot+firstrow-1+findingmatrixrows-1;
    elseif dimension==1;
        if agraphingrows>=rows; currenty=currentyspot+currentiteration-rows+1+findingmatrixrows-1;
        else; currenty=currentyspot+findingmatrixrows-1; end
    end;
    %currentx=currentxspot+findingmatrixcols-1; currenty=currentyspot+findingmatrixrows-1;
    lastclicktype=['alt']; currentlyfindandselecting=1; selecting_button_down_script;
        
elseif strcmp(analysisarealabel,'selection') & isempty(foundvaluelocations)==0;
    % 2-D stuff
    if dimension==2; currentiterationspot=fix(foundvaluelocations(findandselectcounter)/findingplanessize)+selectedoriginiteration2-1;
        if mod(foundvaluelocations(findandselectcounter),findingplanessize)==0;
            currentiterationspot=fix(foundvaluelocations(findandselectcounter)/findingplanessize)+selectedoriginiteration2-2; end;
    end;
    if foundvaluelocations(findandselectcounter)>findingplanessize;
        if mod(foundvaluelocations(findandselectcounter),findingplanessize)~=0;
            selectionplane=fix(foundvaluelocations(findandselectcounter)/findingplanessize);
        else; selectionplane=fix(foundvaluelocations(findandselectcounter)/findingplanessize)-1; end
        foundvaluelocations2(findandselectcounter)=foundvaluelocations(findandselectcounter)-(findingplanessize*selectionplane);
    end;
    currentxspot=mod(foundvaluelocations2(findandselectcounter),findingcolumns); if currentx==0; currentxspot=findingcolumns; end;
    currentyspot=ceil(foundvaluelocations2(findandselectcounter)/findingcolumns);
    currentx=currentxspot+selectedorigincol2-1; currenty=currentyspot+selectedoriginrow2-1; if dimension==2; currentiteration=currentiterationspot; end;
%   a(selectedoriginrow2:selectedendrow2,selectedorigincol2:selectedendcol2,selectedoriginiteration2:selectedenditeration2);
    lastclicktype=['normal']; currentlyfindandselecting=1; selecting_button_down_script;
    if dimension==2; currentiteration=currentiterationspot+findingmatrixplanes-1; end;
    currentx=selectedorigincol2+findingmatrixcols-1; currenty=selectedoriginrow2+findingmatrixrows-1;
    lastclicktype=['alt']; currentlyfindandselecting=1; selecting_button_down_script;
end;
end;

else;
    errordlg('Analysis area is Selection, but nothing selected','Error');
end;