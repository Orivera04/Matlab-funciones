% CFPORT   �L���b�V���t���[�z�̃|�[�g�t�H���I�`��
%
% ���|�[�g�t�H���I�̑S�L���b�V���t���[���t�̃x�N�g���ƁA������
% �L���b�V���t���[���t�ɑ΂���e���̃L���b�V���t���[���ʑ������s���
% �o�͂��܂��B�o�͂��ꂽ�s��́A�����W���Ȑ��ɑ΂��č��̉��i�����肷��
% ���Ɏg�p���܂��B
% 
%   [CFBondDate, AllDates, AllTF, IndByBond] = cfport(...
%                                         CFlowAmounts, CFlowDates, TFactors)
%   
% ���́F
% CFlowAmounts  - CFlowDates �Ŏ����ꂽ�e���t�ɑΉ�����L���b�V���t���[
%                 �̑��z���������͂�����NUMBONDS�sM��̍s��ł��B 
%
% CFlowDates   - �e���̃L���b�V���t���[���t�������A�󔒕��� NaN ��
%                ���߂�ꂽ�s������NUMBONDS�sM��̍s��ł��B
%
% TFactors     - ���ϓ��Ɣ��N�N�[�|�����ԂŊ���o���ꂽ�L���b�V���t���[
%                ���t�Ԃ̎��Ԃ��������͂�����NUMBONDS�sM��̍s��ł��B
%
% �o�́F
% CFBondDate   - �e�،��A�y�сAAllDates �ɋL�ڂ̂�����t���ɃC���f�b�N�X
%                �t�����ꂽ�L���b�V���t���[�ō\�������NUMBONDS�s
%                NUMDATES��̍s��ł��B�e�s�́AAllDates �̓��͗v�f��
%                �Ή�����C���f�b�N�X�ɂ����铖�Y���̃L���b�V���t���[
%                �ō\������Ă��܂��B�e�s�ɂ����邻�̑��̃C���f�b�N�X�́A
%                �[���ō\������܂��B
%
% AllDates     - �،��|�[�g�t�H���I����L���b�V���t���[����������S�Ă�
%                ���t���L�ڂ��ꂽNUMDATES�s1��̃��X�g�ł��B
%
% AllTF        - AllDates �ɋL�ڂ��ꂽ�e���t�ɑΉ����鎞�ԌW�����L�ڂ���
%                NUMDATES�s1��̃��X�g�ł��B TFactors �ɓ��͂��Ȃ��ꍇ�A
%                AllTF �́AAllDates �ɋL�ڂ���Ă���ŏ��̓��t����̓���
%                ���������X�g�ƂȂ�܂��B
%
% IndByBond    - �C���f�b�N�X�� NUMBONDS �s NUMDATES ��̍s��ł��Bi�Ԗ�
%                �̍s�́Ai�Ԗڂ̍����L���b�V���t���[�𔭐����� AllDates
%                �̃C���f�b�N�X���������X�g���o�͂��܂��B�����������
%                �����������̃L���b�V���t���[�����ꍇ�A���̍s���
%                �󔒕��� NaN �Ŗ��߂��A�v�f���𑵂��܂��B
%
% �Q�l : CFAMOUNTS.


%   Author(s): J. Akao, 10-15-1998
%   Copyright 1995-2002 The MathWorks, Inc. 
