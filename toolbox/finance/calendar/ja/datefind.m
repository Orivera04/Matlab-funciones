% DATEFIND   �s����\��������t�ԍ��̃C���f�b�N�X
%
% IND = DATEFIND(SUB,SUPER,TOL)�́A���� SUPER �Őݒ肵�����t�v�f���ATOL 
% �Őݒ肵���g�������X�͈̔͂ŁA���� SUB �̗v�f�ƈ�v���� SUB �̃C��
% �f�b�N�X���x�N�g���ŏo�͂��܂��BSUPER �́A���t�ԍ����d�����Ȃ���ʏW��
% (superset)�s��ŁASUB �s��ɂ��T���̑ΏۂƂȂ�s��ł��BSUB �́ASUPER
% �s��v�f�𒊏o���邽�߂ɐݒ肷����t�ԍ���v�f�Ƃ��镔���s��ł��B
% TOL �́A��v�x�����̎ړx�ɂȂ�����ŁA���̐����ł��BTOL �̃f�t�H���g�l
% ��0�ł��B
% 
% ����:
%   �K��������t�ԍ����Ȃ��ꍇ�ɂ́A IND = [] �ƂȂ�܂��B
% 
%   SUB ���\������e�v�f�́A�����Ȃ��ŁASUPER �s��ɂ��܂܂�Ă��Ȃ����
%   �Ȃ�܂���B���̊֐��́A�J��Ԃ��̂Ȃ����t��̏������s���悤�ɐ݌v
%   ����Ă��܂��B
%
% ���Ƃ��΁A���̃f�[�^���^������ƁA
% 
%      Super = datenum(1997, 7, 1:31);
%      Sub = [datenum(1997, 7, 10); datenum(1997, 7, 20)];
%        
%      ind = datefind(Sub,Super,1) 
%
% �́A���̒l���o�͂��܂��B
%
%            ind =  9
%                  10
%                  11
%                  19
%                  20
%                  21
%
%
% �Q�l : DATENUM. 


%         Author(s): M. Reyes-Kattar, 06-04-97 
%   Copyright 1995-2002 The MathWorks, Inc. 
