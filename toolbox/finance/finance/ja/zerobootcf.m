% ZEROBOOTCF   �[���Ȑ��u�[�g�X�g���b�v�G���W��
%
%  [ZeroRates, EndTimes, EndDates] = zeroboot(Prices, CFlowAmounts, ...
%               CFlowDates, TFactors)
%
% ����: 
% "help cfamounts" �ƃ^�C�v����ƁA�L���b�V���t���[�����̐������Q�Ƃł�
% �܂��B
%   Price        - ����0�ł� NINST �s1��̎s�ꉿ�i
%   CFlowAmounts - �L���b�V���t���[�̋��z������ NINST �s MOSTCFS ��̍s��
%   CFlowDates   - �L���b�V���t���[�̓��t������ NINST �s MOSTCFS ��̍s��
%   TFactors     - �L���b�V���t���[�̔��N���ԃt�@�N�^������NINST�s
%                  MOSTCFS��̍s��
%
% �o��:
%   ZeroRates    - ���͂��ꂽ���i�ł̃L���b�V���t���[�̗����]������
%                  �[������ NPOINTS �s1��̃x�N�g��
%   EndTimes     - ���[�g�̖����܂ł̔��N���ԃt�@�N�^������NPOINTS�s1��
%                  �̃x�N�g��
%   EndDates     - ���[�g�̖����̓��t������ NPOINTS �s1��̃x�N�g�� 
%                  EndDates �́ANINST �L���b�V���t���[�̗���ɌŗL�̖�����
%                  �ł��B
%
% ���:
%   [cfa,cfd,tf] = cfamounts(0.05,today,today+[300 (500:-200:100)])
%   zerobootcf(99:102, cfa, cfd, tf)
%
% �Q�l : CFBYZERO, ZBTPRICE.


%   Author(s) : J. Akao 23-Mar-1999
%   Copyright 1995-2002 The MathWorks, Inc. 
