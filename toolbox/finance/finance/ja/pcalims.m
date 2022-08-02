% PCALIMS   個々の資産の最小配分量、最大配分量に対する一次不等式
%
% この関数は、NASSETS個の使用可能な資産投資のそれぞれにおけるポートフォ
% リオ配分の下限、上限を指定します。
%
%    [A,b] = pcalims(AssetMin, AssetMax, NumAssets) 
% 
% 入力:
% AssetMin, AssetMax : 各資産における最小配分量、最大配分量のスカラ値、
%                      または、NASSETS の長さをもつベクトルです。NaN が
%                      入力されると、その方向への資産配分には、何ら制約
%                      が課せられていないと解釈されます。スカラによる範
%                      囲の設定は全ての資産に適用されます。
% NumAssets          : (オプション)資産の数 NASSETS です。資産の数を指定
%                      しない場合、NumAssets は、AssetMin、または、
%                      AssetMax の長さとなります。 
%
% 出力:
% A*Pwts' <= b という制約関係を実現する行列 A 及びベクトル b を出力しま
% す。ここで、Pwts は、資産配分の1行NASSETS列のベクトルです。
%
% 別な使用法：2つ以下の出力引数を伴う形で、この関数をコールした場合、A 
% 及び b は、互いに連結されることになります。
% 
%    Cons = [A, b]; Cons = pcalims(AssetMin, AssetMax, NumAssets)
% 
% 参考 : PORTOPT, PCPVAL, PCGLIMS, PCGCOMP, PORTCONS.


%   Author(s): J. Akao, M. Reyes-Kattar, 03/11/98
%   Copyright 1995-2002 The MathWorks, Inc. 
