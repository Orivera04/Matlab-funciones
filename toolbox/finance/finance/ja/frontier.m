% FRONTIER   �L���t�����e�B�A
%
% [RISK,ROR,WTS] = FRONTIER(ASSET,RET,PTS,TARGET) �́A�^����ꂽ�|�[�g
% �t�H���I�̗L���t�����e�B�A���\������W���΍� RISK �Ǝ��v�� ROR �̑��ɁA
% �t�����e�B�A�̊e�_�ɑ΂���e���Y�̉��d�l WTS ���o�͂��܂��BASSET ��
% ���n��f�[�^����Ȃ� M �s N ��̍s��ŁA�e��1�̎��Y��\���܂��BPTS
% �͌v�Z����L���t�����e�B�A�̃|�C���g�����w�肵�܂��B�f�t�H���g�� 
% PTS = 10�ł��BTARGET �́AASSET �� RET �̃f�[�^�Ɋ�Â��Ċ�]������v��
% ���w�肵�܂��BTARGET �̎��v������͂���Ƃ��ɂ́APTS �͋�s��Ƃ���
% ���͂��܂��BRISK �� ROR�� PTS �s1��̃x�N�g���ŁAWTS ��PTS�s(���Y��)��
% �̍s��ł��B
% 
% FRONTIER(ASSET,RET) �́AMATLAB�̃��[�N�X�y�[�X�Ƀf�[�^���o�͂����ɗL��
% �t�����e�B�A���v���b�g���܂��B
%        
% [RISK,ROR,WTS] = FRONTIER(ASSET,RET,PTS) �́A�L���t�����e�B�A�̊e�_��
% �W���΍��A���v���A���d�l���o�͂��܂��B
% 
% [RISK,ROR,WTS] = FRONTIER(ASSET,RET,[],TARGET) �́A�t�����e�B�A��̓���
% �̎��v���Ɗ֘A�����L���t�����e�B�A�̃f�[�^���o�͂��܂��B
% 
% �Q�l : PORTRAND, PORTVAR, PORTROR.
%
% �Q�l����: Bodie, Kane, and Marcus, Investments, Chapter 7. 


%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
