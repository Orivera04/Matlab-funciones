% PORTVAR   ポートフォリオの分散を出力
%
% V = PORTVAR(ASSET,WS) は、資産のポートフォリオの分散を出力します。
% ASSET は、N 種の有価証券の M 行 N 列の行列で、ASSET の各列は、1つの有価
% 証券の時系列を表します。WS は1行 N 列の行列で、WS の各列は ASSET の
% 各有価証券の加重値に対応しています。WS が R 行 N 列の加重値行列の場合
% には、V は各行が WS の各行の分散計算値を表す R 行1列のベクトルとして
% 出力されます。
% 
% V = PORTVAR(ASSET) は、ポートフォリオの分散を計算する場合、各有価証券に
% 等しい加重値を割り当てます。
% 
% 参考 : FRONTIER, PORTROR, PORTRAND.
%
% 参考文献: Bodie, Kane, and Marcus, Investments, Chapter 7. 


%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
