% SEOPTION   オプションポートフォリオの感応度測度を計算
%
% O = SEOPTION(PRANGE,STRIKE,RATE,MATS,SIG,CONTRACT,MEASURE) は、オプ
% ションポートフォリオの感応度測度を計算します。PRANGE は原資産の価格
% 範囲 STRIKE は権利行使価格のベクトル、RATE はリスクフリー利率、MATS は
% 満期までの期間を示すベクトル、SIG はポートフォリオの総合ボラティリティ、
% CONTRACT は各有価証券のオプション数(オプション/契約*契約)です。


%       Author(s): C.F. Garvin, 3-10-95
%       Copyright 1995-2002 The MathWorks, Inc. 
