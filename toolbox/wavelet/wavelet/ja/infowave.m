% INFOWAVE 　　ウェーブレットに関する情報
%
% ウェーブレット
%
% 1. Crude ウェーブレット
%
% ウェーブレット: gaussian ウェーブレット (gaus)、morlet、Mexican hat (mexihat)
%
% プロパティ：最小限の属性のみ
%    −phi は、存在しません。
%    −解析は、直交ではありません。
%    −psi は、コンパクトサポートされません。
%    −再構成のプロパティは、保証されません。
% 可能な解析：
%    −連続分解
% 優れた主要プロパティ： 対称性、psi は明示的に表現
% 主要な問題： 高速アルゴリズム及び再構成が利用不可能
%
% 2. 無限に規則的なウェーブレット
%
% ウェーブレット: meyer (meyr).
%
% プロパティ： 
%    −phi は、存在しており、解析は直交性をもちます。
%    −psi 及び phi は、共に無限回微分可能です。
%    −psi 及び phi は、共にコンパクトサポートされません。
% 可能な解析：
%    −連続変換
%    −FIRフィルタを利用しない離散変換
% 優れた主要プロパティ： 対称性、無限連続性
% 主要な問題： 高速アルゴリズムの利用が不可能
%
% ウェーブレット: 離散 Meyer ウェーブレット (dmey).
%
% プロパティ: 
%    − Meyer ウェーブレットの Approximation FIR フィルタ
%
% 可能な解析:
%    - 連続変換
%    - 離散変換
%
% 3. 直交性をもちコンパクトサポートされたウェーブレット
%
% ウェーブレット: Daubechies (dbN)、symlets (symN)、coiflets (coifN).
%
% プロパティ: 
%    −phi が、存在しており、解析は直交性をもちます。
%    −psi 及び phi は、共にコンパクトサポートされています。
%    −psi は、設定された数の vanishing モーメントを有しています。
% 可能な解析：
%    −連続変換
%    −FWT を用いた離散変換
% 優れた主要プロパティ： サポート、vanishing モーメント、FIR フィルタ
% 主要な問題： 低いレギュラリティ
%
% 個々のウェーブレット特有のプロパティ
%    dbN  : 非対称性
%    symN : ほぼ対称
%    coifN: ほぼ対称、phi 及び psi 共に、vanishing モーメントを有しています。
%
% 4. 双直交かつコンパクトサポートされたウェーブレットペア
%
% ウェーブレット：B スプライン双直交ウェーブレット(biorNr.Nd と rbioNr.Nd)
%
% プロパティ: 
%    −phi 関数が、存在しており、解析は双直交性をもちます。
%    −psi、phi 共に分解、再構成についてコンパクトサポートされます。
%    −psi、phi 共に分解については、vanishing モーメントを有しています。
%    −psi、phi 共に再構成については、既知のレギュラリティをもっています。
% 可能な解析：
%    - 連続変換
%    - FWT を用いた離散変換
% 主要な長所： FIR フィルタを伴う対称性、分解及び再構成に対して理想的なプロパテ
% ィが分離されており、的確な配分が可能となっています。
% 主要な問題： 直交性が失われています。



%   Copyright 1995-2002 The MathWorks, Inc.
