% PORTVRISK   �|�[�g�t�H���I��Value-At-Risk
%
% ValueAtRisk = portvrisk(PortReturn, PortRisk, RiskThreshold, PortValue)
% �́A�����m�����x�� RiskThreshold �����ƂɁA����1���Ԃɂ�����|�[�g�t�H
% ���I�̉��l�̐��ݓI�������o�͂��܂��B 
%
% ����:
% PortReturn �́A���Y���Ԃɂ킽���Ċ��҂ł���e�|�[�g�t�H���I�̊��Ҏ��v
% ������ NPORTS �s1��̃x�N�g���A�܂��́A�X�J���l�ł��B
%
% PortRisk �́A���Y���Ԃɂ�����e�|�[�g�t�H���I�̕W���΍������� NPORTS 
% �s1��̃x�N�g���A�܂��́A�X�J���l�ł��B
%            
% RiskThreshold �́A�����̐�����m�����w�肷�� NPORTS �s1��x�N�g���A
% �܂��́A�X�J���l�ł��B�f�t�H���g��0.05 (5%)�ƂȂ��Ă��܂��B
%
% PortValue �́A���Y�|�[�g�t�H���I�̑����l���w�肷�� NPORTS �s1��x�N�g
% ���A�܂��́A�X�J���l�ł��B�f�t�H���g�l��1�ł��B
% 
% �o��:
% ValueAtRisk �́A1-RiskThreshold �̐M���m���������ė\�����ꂽ�A����ő�
% ���������� NPORTS �s1��x�N�g���ł��B
%
% 1-RiskThreshold�̊m���ŁA ValueAtRisk�A�܂��́A�������������������
% �����ARiskThreshold �̊m���ŁAValueAtRisk�A�܂��́A��������傫��
% �����������炳��܂��B
%
% ���ӁF 
% PortValue�ɓ��͂�ݒ肵�Ȃ��ꍇ�AValueAtRisk �͒P�ʂ�����x�[�X�ŕ\��
% ����܂��B�[���l�͑��������琶���Ȃ����Ƃ��Ӗ����Ă��܂��B
%    
% PortReturn �y�� PortRisk ���h���P�ʂ̏ꍇ�A PortValue ��1�Ƃ��܂��B
% PortReturn �� PortRisk ���S�����x�[�X�̏ꍇ�APortValue �ɂ̓|�[�g�t�H
% ���I�̑����l����͂��Ă��������B
% 
% �Q�l : PORTOPT, FRONTCON.


%  Author(s): M. Reyes-Kattar, 05/11/98
%  Copyright 1995-2002 The MathWorks, Inc.  
