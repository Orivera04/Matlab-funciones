% FINARGCAT   �T�C�Y�̈قȂ�z��Ƀp�f�B���O���s���ĘA��
%
% FINARGCAT(DIM,A,B) �́A�z�� A �� B ������ DIM �ɉ����ĘA�����܂��B�z�� 
% A �� B �̃T�C�Y�� DIM �ȊO�̎����œ������Ȃ��ꍇ�AA �� B �͊e������
% ������ŏ����ʃT�C�Y�� NaN �Ńp�f�B���O����܂��B���͈�����������̏ꍇ
% �p�f�B���O�ɂ́ANaN �̑���ɃX�y�[�X���p�����܂��B
%
% B = FINARGCAT(DIM,A1,A2,A3,A4,...)�́A���͂��ꂽ�z�� A1, A2,...������ 
% DIM �ɉ����ĘA�����܂��B
% 
% FINARGCAT �́ADIM �ȊO�̎����œ��͑S�ẴT�C�Y���������ꍇ�ACAT �Ɠ���
% �ł��B
%
% ���: 
% ���̏o�͂ɂ����āA�A�����ꂽ���C���[�ɂ͈󂪕t�����Ă��܂��B
%     A1 =   ones(2,3)
%     A2 = 2*ones(1,4)
%     A3 = 3*ones(3,1)
%     finargcat(1,A1,A2,A3)
% �́A���� (2+1+3)�s 4 ��̍s��𐶐����܂��B
%     1     1     1   NaN
%     1     1     1   NaN
%     -------------------
%     2     2     2     2
%     -------------------
%     3   NaN   NaN   NaN
%     3   NaN   NaN   NaN
%     3   NaN   NaN   NaN
%  
% ����ɑ΂��� finargcat(2,A1,A2,A3)�́A���� 3 �s (3+4+1)��̍s���
% �������܂��B
%      1     1     1 |   2     2     2     2  |  3
%      1     1     1 | NaN   NaN   NaN   NaN  |  3
%    NaN   NaN   NaN | NaN   NaN   NaN   NaN  |  3
%   
% �܂��Afinargcat(3,A1,A2,A3)�́A3 �~ 4 �~(1+1+1)�s��𐶐����܂��B
%
% �Q�l : CAT.


%   Author(s): J. Akao 12/18/98
%   Copyright 1995-2002 The MathWorks, Inc. 
