% FINARGSZ   �X�J�������̊g���ɂ�苤�ʃT�C�Y�̔z����o��
%
% [AEXP, BEXP] = finargsz('scalar', A, B) �́A�X�J�� A�A�܂��́AB �����
% �̍ő�T�C�Y�܂Ŋg�����邱�Ƃɂ���āA�������T�C�Y�̏o�� AEXP �y�� 
% BEXP �𐶐����܂��B���̊֐��ւ̓��͂̓X�J���A�܂��́A�K������s��łȂ�
% �Ă͂Ȃ�܂���B
%
% [AEXP, BEXP] = finargsz(1, A, B) �́A����̍s�������o�� AEXP �� BEXP 
% ���o�͂��܂��B�P��̍s����Ȃ���͂́A��Ԗڂ̎����ɂ����Ċg������܂��B
% A ����� B �̈�Ԗڂ̎����̓X�J���A�܂��́A����T�C�Y�łȂ��Ă͂Ȃ��
% ����B
%
% [AEXP, BEXP] = finargsz(EXPDIMS, A, B) �́A�x�N�g�� EXPDIMS �ɋL�ڂ���
% ���S�Ă̎����ɂ����ċ��ʂ̃T�C�Y��L����o�� AEXP �� BEXP �𐶐����܂��B
%
% [AEXP, BEXP] = finargsz('all', A, B) �́A�S�Ă̎����ɂ����ċ��ʂ̃T�C�Y
% ��L����o�� AEXP �� BEXP �𐶐����܂��B�S�ẴX�J���������g���̑Ώۂ�
% �Ȃ�܂��B
%
% 2�����z��ɂ��ẮA FINARGSZ('all', A, B) ���AFINARGSZ([1 2], A, B) 
% �Ɠ����@�\�����s���܂��B���̏ꍇ�A�s�A��A�܂��́A�X�J�����͂��g����
% �ΏۂƂȂ�܂��B
%
% [AEXP1, AEXP2, AEXP3, ... ] = finargsz(EXPDIMS, A1, A2, A3, ...) �́A
% �z�� A1, A2,.....���g���̑ΏۂƂȂ�܂��B�Ȃ��AEXPDIMS �ɂ́A�g����
% �ΏۂƂȂ鎟����ݒ肷�邩�A�܂��́A'scalar' �� 'all' �̂悤�ȕ������
% �ݒ肷�邱�Ƃ��ł��܂��B
%
% ���:
%   1)�s�A��A�܂��́A���̑o�����g�����܂��B
%   a = [1 2 3; 4 5 6]
%   b = [10; 20]
%   c = [100 200 300]
%   d = [1000]
%   [ae,be,ce,de] = finargsz('all', a,b,c,d)
%   ae =
%       1    2     3
%       4    5     6
%   be =
%       10    10    10
%       20    20    20
%   ce =
%      100   200   300
%      100   200   300
%   de =
%      1000  1000  1000
%      1000  1000  1000
%           
%   2)�X�J�����g�����܂��B
%   [ae,be] = finargsz('scalar', 10, [1 2;3 4])
%   ae =
%       10    10
%       10    10
%   be =
%       1    2
%       3     4
%
%   3)�x�N�g�� [10;20] �́A�X�J���g���̑ΏۂƂȂ�܂���B���̂��߁A
%   [ae,be] = finargsz('scalar', [10; 20], [1 2;3 4])
%     �́A�G���[���o�͂��܂��B
% 
%   4)�x�N�g�� [10;20] �́A2�Ԗڂ̎����ɉ����Ċg�����s�����Ƃ��ł��܂��B
%   [ae,be] = finargsz(2, [10; 20], [1 2;3 4])
%   ae =
%       10    10
%       20    20
%   be =
%       1    2
%       3     4


%   Author(s): J. Akao, C. Bassignani, 03-30-98
%   Copyright 1995-2002 The MathWorks, Inc. 
