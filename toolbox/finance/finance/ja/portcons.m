% PORTCONS   �ꎟ�s������p���Ď��Y�����̃|�[�g�t�H���I�̐���s��𐶐�
%
% ���̕s�����́A A*Wts' <= b �Ƃ����^�C�v�̂��̂ŁA�����ŁAWts �͉��d�l
% �̍s��ł��B�s�� ConSet �́AConSet = [A b] �ƒ�`����܂��B
%
% ConSet = portcons('ConstType', Data1, ..., DataN)�́A����^�C�v 
% ConstType �y�ѐ���p�����[�^ Data1, ..., DataN �Ɋ�Â��āA�s�� ConSet 
% �𐶐����܂��B����^�C�v�y�т���ɑΉ����鐧��p�����[�^�̃��X�g�ɂ���
% �́A�ȉ����Q�Ƃ��Ă��������B
% 
% ConSet = portcons('ConstType1', Data11, ..., Data1N, 'ConstType2', ...
% Data21, ..., Data2N, ...)�́A����^�C�v ConstTypeN �y�ѐ���p�����[�^ 
% DataN1, ..., DataNN �Ɋ�Â��āA�s�� ConSet �𐶐����܂��B����^�C�v
% �y�т���ɑΉ����鐧��p�����[�^�̃��X�g�ɂ��ẮA�ȉ����Q�Ƃ��Ă���
% �����B
%
% ����^�C�v�y�т���ɑΉ����鐧��f�[�^
%
%     ����^�C�v: 'Default'
% 
% �S�Ă̎��Y�z���ɂ��āA0���傫���Ȃ�܂��B���Ȃ킿�A�J������́A
% ���̏ꍇ�F�߂��܂���B�|�[�g�t�H���I�z���̌����l�́A1�ɐ��K������
% �܂��B
%
%     ����^�C�v: NumAssets (�K�{)
%     NumAssets �́A�|�[�g�t�H���I�̎��Y���������X�J���l�ł��B
%
%     ����^�C�v: 'PortValue'
%     �|�[�g�t�H���I�̑����l�� PVal �ɌŒ肷��K�v������܂��B
%
%     ����f�[�^: PVal (�K�{), NumAssets(�K�{)
%     PVal �́A�|�[�g�t�H���I�̑����l�������X�J���l�ł��BNumAssets �́A
%     �|�[�g�t�H���I�̎��Y���������X�J���l�ł��B�ڍׂɂ��ẮAPCPVAL 
%     ���Q�Ƃ��Ă��������B
% 
%     ����^�C�v: 'AssetLims'
%     ���Y���̍ŏ��z���ʁA�ő�z���ʂ��w�肵�܂��B
%
%     ����f�[�^: AssetMin (�K�{), AssetMax (�K�{), 
%                 NumAssets (�I�v�V����)
%        AssetMin �́A���Y���̍ŏ��z���ʂ��w�肷��NASSETS�̒����̃x�N
%                 �g���A�܂��́A�X�J���l
%        AssetMax �́A���Y���̍ő�z���ʂ��w�肷�� NASSETS �̒����̃x�N
%                 �g���܂��̓X�J���l
%        NumAssets �́A�|�[�g�t�H���I�̎��Y���������X�J���l
% 
%       �ڍׂɂ��ẮA�֐� PCALIMS ���Q�Ƃ��Ă��������B
%     
%    ����^�C�v: 'GroupLims'
%       ���Y�W���ɑ΂���ŏ��z���ʁA�ő�z���ʂ�ݒ肵�܂��B
% 
%    ����f�[�^ : Groups (�K�{), GroupMin (�K�{), GroupMax (�K�{)
%       Groups �́A�e�W���ɂǂ̎��Y��������̂������� NGROUPS �s NASSETS
%                  ��̍s��ł��B
%       GroupMin �́A�e�W���ɂ�����ŏ������z���ʂ��w�肷�钷��NGROUPS
%                  �̃x�N�g���A�܂��́A�X�J���l�ł��B
%       GroupMax �́A�e�W���ɂ�����ő匋���z���ʂ��w�肷�钷��NGROUPS
%                  �̃x�N�g���A�܂��́A�X�J���l�ł��B
%       �ڍׂɂ��ẮA�֐� PCGLIMS ���Q�Ƃ��Ă��������B
%
%    ����^�C�v: 'GroupComparison' 
%      ���Y�W�����m�̔�r�����ݒ肵�܂��B
%
%    ����f�[�^�F GroupA (�K�{), AtoBmin (�K�{), AtoBmax (�K�{), 
%                 GroupB (�K�{)
%       GroupA �y�� GroupB �́A��r����W�����w�肷�� NGROUPS �s NASSETS
%                 ��̍s��ł��B
%       AtoBmin �́A�W�� A �ւ̎��Y�z���ƏW�� B �ւ̎��Y�z���Ƃ̍ŏ��䗦
%                 �������X�J���l�A����NGROUPS �̃x�N�g���ł��B
%       AtoBmax �́A�W�� A �ւ̎��Y�z���ƏW�� B �ւ̎��Y�z���Ƃ̍ő�䗦
%                 �������X�J���l�A�܂��́A����NGROUPS �̃x�N�g���ł��B
%       �ڍׂɂ��ẮA�֐� PCGCOMP ���Q�Ƃ��Ă��������B
%
%     ����^�C�v: 'Custom'
%       �J�X�^���ꎟ�s�������� A*Wts' <= b  
%
%     ����f�[�^: A (�K�{), b (�K�{)
%       A �́A�e�s�����ɑg�ݍ��܂ꂽ���ꂼ��̎��Y�ɑ΂�����d�l������ 
%                 NCONSTRAINTS �s NASSETS ��̍s��ł��B
%       b �́A�s�����̉E�ӂ��w�肷�钷�� NCONSTRAINTS�̃x�N�g���ł��B
% 
% �Q�l : PORTOPT, PCPVAL, PCGLIMS, PCGCOMP, PCALIMS.


%   Author(s): M. Reyes-Kattar, J. Akao,  03/22/98
%   Copyright 1995-2002 The MathWorks, Inc. 
