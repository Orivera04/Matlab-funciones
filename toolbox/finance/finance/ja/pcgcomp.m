% PCGCOMP   資産集合同士の比較制約に対する一次不等式を出力
%
% ある資産集合内の配分と他の資産集合内の配分の比率を、最小値は AtoBmin、
% 最大値は AtoBmax で設定します。比較は、NASSETS 個の利用可能な投資の部
% 分集合から構成される任意数 NGROUPS 間で行うことができます。
% 
%   [A,b] = pcgcomp(GroupA, AtoBmin, AtoBmax, GroupB)
% 
% 入力:
%   GroupA, GroupB  : 比較する集合を指定する NGROUPS 行 NASSETS 列の値。
%                     各行の値は、ある集合にどの資産が割り当てられている
%                     かを指定しています。Group(i,j)=1の場合、集合 i は
%                     資産 j を含んでいます。その他の場合、Group(i,j)= 0
%                     となります。
%
%   AtoBmin, AtoBmax：集合 A への資産配分と集合 B への資産配分との最小
%                     比率・最大比率を含むスカラ値、または、NGROUPS の
%                     長さのベクトルです。NaN が入力された場合、その方向
%                     への2つの集合間の資産配分には何ら制約がないことを
%                     意味します。スカラで設定された範囲は、全ての集合の
%                     ペアに適用されます。NGROUPS の数だけ存在する集合
%                     のペアのそれぞれについて、つぎの式が成立します。
% 
%          GroupA total >= GroubB total * AtoBmin
%          GroupA total <= GroubB total * AtoBmax
% 
% 出力:
% A*Pwts' <= b という制約関係を実現する行列 A 及びベクトル b を出力し
% ます。ここで、Pwts は 資産配分の1行NASSETS列のベクトルです。
%
% 別の使用法：
% 2つ以下の出力引数を伴う型で、この関数をコールした場合、A 及び b は
% 互いに連結されることになります。 
% 
%    Cons = [A, b]; Cons = pcgcomp(GroupA, AtoBmin, AtoBmax, GroupB)
% 
% 参考 : PORTOPT, PCALIMS, PCPVAL, PCGLIMS, PORTCONS


%   Author(s): J. Akao, M. Reyes-Kattar, 03/11/98
%   Copyright 1995-2002 The MathWorks, Inc. %
