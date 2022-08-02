% PORTCONS   一次不等式を用いて資産投資のポートフォリオの制約行列を生成
%
% この不等式は、 A*Wts' <= b というタイプのもので、ここで、Wts は加重値
% の行列です。行列 ConSet は、ConSet = [A b] と定義されます。
%
% ConSet = portcons('ConstType', Data1, ..., DataN)は、制約タイプ 
% ConstType 及び制約パラメータ Data1, ..., DataN に基づいて、行列 ConSet 
% を生成します。制約タイプ及びそれに対応する制約パラメータのリストについて
% は、以下を参照してください。
% 
% ConSet = portcons('ConstType1', Data11, ..., Data1N, 'ConstType2', ...
% Data21, ..., Data2N, ...)は、制約タイプ ConstTypeN 及び制約パラメータ 
% DataN1, ..., DataNN に基づいて、行列 ConSet を生成します。制約タイプ
% 及びそれに対応する制約パラメータのリストについては、以下を参照してくだ
% さい。
%
% 制約タイプ及びそれに対応する制約データ
%
%     制約タイプ: 'Default'
% 
% 全ての資産配分について、0より大きくなります。すなわち、カラ売りは、
% この場合認められません。ポートフォリオ配分の結合値は、1に正規化され
% ます。
%
%     制約タイプ: NumAssets (必須)
%     NumAssets は、ポートフォリオの資産数を示すスカラ値です。
%
%     制約タイプ: 'PortValue'
%     ポートフォリオの総価値を PVal に固定する必要があります。
%
%     制約データ: PVal (必須), NumAssets(必須)
%     PVal は、ポートフォリオの総価値を示すスカラ値です。NumAssets は、
%     ポートフォリオの資産数を示すスカラ値です。詳細については、PCPVAL 
%     を参照してください。
% 
%     制約タイプ: 'AssetLims'
%     資産毎の最小配分量、最大配分量を指定します。
%
%     制約データ: AssetMin (必須), AssetMax (必須), 
%                 NumAssets (オプション)
%        AssetMin は、資産毎の最小配分量を指定するNASSETSの長さのベク
%                 トル、または、スカラ値
%        AssetMax は、資産毎の最大配分量を指定する NASSETS の長さのベク
%                 トルまたはスカラ値
%        NumAssets は、ポートフォリオの資産数を示すスカラ値
% 
%       詳細については、関数 PCALIMS を参照してください。
%     
%    制約タイプ: 'GroupLims'
%       資産集合に対する最小配分量、最大配分量を設定します。
% 
%    制約データ : Groups (必須), GroupMin (必須), GroupMax (必須)
%       Groups は、各集合にどの資産が属するのかを示す NGROUPS 行 NASSETS
%                  列の行列です。
%       GroupMin は、各集合における最小結合配分量を指定する長さNGROUPS
%                  のベクトル、または、スカラ値です。
%       GroupMax は、各集合における最大結合配分量を指定する長さNGROUPS
%                  のベクトル、または、スカラ値です。
%       詳細については、関数 PCGLIMS を参照してください。
%
%    制約タイプ: 'GroupComparison' 
%      資産集合同士の比較制約を設定します。
%
%    制約データ： GroupA (必須), AtoBmin (必須), AtoBmax (必須), 
%                 GroupB (必須)
%       GroupA 及び GroupB は、比較する集合を指定する NGROUPS 行 NASSETS
%                 列の行列です。
%       AtoBmin は、集合 A への資産配分と集合 B への資産配分との最小比率
%                 を示すスカラ値、長さNGROUPS のベクトルです。
%       AtoBmax は、集合 A への資産配分と集合 B への資産配分との最大比率
%                 を示すスカラ値、または、長さNGROUPS のベクトルです。
%       詳細については、関数 PCGCOMP を参照してください。
%
%     制約タイプ: 'Custom'
%       カスタム一次不等式制約 A*Wts' <= b  
%
%     制約データ: A (必須), b (必須)
%       A は、各不等式に組み込まれたそれぞれの資産に対する加重値を示す 
%                 NCONSTRAINTS 行 NASSETS 列の行列です。
%       b は、不等式の右辺を指定する長さ NCONSTRAINTSのベクトルです。
% 
% 参考 : PORTOPT, PCPVAL, PCGLIMS, PCGCOMP, PCALIMS.


%   Author(s): M. Reyes-Kattar, J. Akao,  03/22/98
%   Copyright 1995-2002 The MathWorks, Inc. 
