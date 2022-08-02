% PCGLIMS   資産集合の最小配分量、最大配分量に対する一次不等式を出力
%
% 資産集合に対する最小配分量、最大配分量を指定します。NASSETS の数だけ
% 存在する投資の部分集合からなる任意の数 NGROUPS 存在する集合のペアに
% ついて上限、下限を設定することができます。
% 
% [A,b] = pcglims(Groups, GroupMin, GroupMax)
%
% 入力:
%    Groups : 各集合にどの資産が属しているのかを指定するNGROUPS行NASSETS
%             列の行列です。各列の値は、ある集合にどの資産が割り当てられ
%             ているかを指定しています。Group(i,j) = 1の集合、集合 i は
%             資産 j を含んでいます。他の場合、Group(i,j) = 0 となります。
%    GroupMin, GroupMax : 各集合への最小及び最大結合配分量を示すスカラ値
%             または、NGROUPS の長さのベクトルです。NaN が入力されると、
%             当該資産に対して何ら制約が課せられないことを意味します。
%             スカラで設定した範囲は、全ての集合に対して適用されます。
%
% 出力:
% A*Pwts' <= b という制約関係を実現する行列 A 及びベクトル b を出力しま
% す。ここで、Pwts は、資産配分の1 行 NASSETS 列のベクトルです。
%
% 別の使用法：
% 2つ以下の出力引数を伴う形でこの関数をコールした場合、A 及び b は、互い
% に連結されることになります。
% 
%       Cons = [A, b]; Cons =  pcglims(Groups, GroupMin, GroupMax)
% 
% 参考 : PORTOPT, PCPVAL, PCALIMS, PCGCOMP, PORTCONS.


%   Author(s): J. Akao, M. Reyes-Kattar, 03/20/98
%   Copyright 1995-2002 The MathWorks, Inc. 
