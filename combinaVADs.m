clc; clear all; close all

%% 

load erroBateria1_Sergio.mat
load VAD1.mat

if length(vecGabarito) == length(vad_DBN) &&...
        length(vecGabarito8k) == length(vad_DBN_8k)
   fprintf('Dados corretamente carregados\n') 
end

%% 8k
tic
gabaritoCombinado_8k = zeros(1,length(vecGabarito8k));
gabarito_flags_8k = zeros(1,length(vecGabarito8k));

for iSample = 1:length(vecGabarito8k)
    
    if vad_DBN_8k(iSample) == 1 && vad_G729_8k(iSample)&& vad_VADSOHN_8k(iSample) == 1
        gabaritoCombinado_8k(1,iSample) = 1;
        gabarito_flags_8k(iSample) = 1;
    elseif vad_DBN_8k(iSample) == 1 && vad_G729_8k(iSample) == 1
        gabaritoCombinado_8k(1,iSample) = 1;
        gabarito_flags_8k(iSample) = 2;
    elseif vad_DBN_8k(iSample) == 1 && vad_VADSOHN_8k(iSample) == 1
        gabaritoCombinado_8k(1,iSample) = 1;
        gabarito_flags_8k(iSample) = 3;
    elseif vad_VADSOHN_8k(iSample) == 1 && vad_G729_8k(iSample) == 1
        gabaritoCombinado_8k(1,iSample) = 1;
        gabarito_flags_8k(iSample) = 4;
    end
    
end

tVec8k = (1:length(signalResampled))/8000; 
figure()

plot(tVec8k,signalResampled)
set(gca,'fontsize',22,'fontweight','bold')
hold all
stairs(tVec8k,vecGabarito8k*1.35,'linewidth',1.3)                 %Gabarito 8k
ylim([-1 1.4])
stairs(tVec8k,gabaritoCombinado_8k*1.2,'linewidth',1.3)                
% stairs(tVec8k,vad_G729_8k*1.2,'linewidth',1.3)     %VAD 2
% stairs(tVec8k,vad_DBN_8k*1.3,'linewidth',1.3)     %VAD 2
% stairs(tVec8k,vad_VADSOHN_8k*1.4,'linewidth',1.3)     %VAD 2
% title(sprintf('VAD com audio em 8 k - Bateria %i',iBateria))
legend('Audio L','Gabarito','Gabarito combinado','location','south')

fprintf('Time Elapsed: %.2f [s]',toc)

%% 48k
tic
gabaritoCombinado = zeros(1,length(vecGabarito));
gabarito_flags = zeros(1,length(vecGabarito));

for iSample = 1:length(vecGabarito)
    
    if vad_DBN(iSample) == 1 && vad_G729(iSample)&& vad_VADSOHN(iSample) == 1
        gabaritoCombinado(1,iSample) = 1;
        gabarito_flags(iSample) = 1;
    elseif vad_DBN(iSample) == 1 && vad_G729(iSample) == 1
        gabaritoCombinado(1,iSample) = 1;
        gabarito_flags(iSample) = 2;
    elseif vad_DBN(iSample) == 1 && vad_VADSOHN(iSample) == 1
        gabaritoCombinado(1,iSample) = 1;
        gabarito_flags(iSample) = 3;
    elseif vad_VADSOHN(iSample) == 1 && vad_G729(iSample) == 1
        gabaritoCombinado(1,iSample) = 1;
        gabarito_flags(iSample) = 4;
    end
    
end

tVec = (1:length(signal))/48000; 
figure()

plot(tVec,signal)
set(gca,'fontsize',22,'fontweight','bold')
hold all
stairs(tVec,vecGabarito*1.35,'linewidth',1.3)                 %Gabarito 8k
ylim([-1 1.4])
stairs(tVec,gabaritoCombinado*1.2,'linewidth',1.3)                
% stairs(tVec8k,vad_G729_8k*1.2,'linewidth',1.3)     %VAD 2
% stairs(tVec8k,vad_DBN_8k*1.3,'linewidth',1.3)     %VAD 2
% stairs(tVec8k,vad_VADSOHN_8k*1.4,'linewidth',1.3)     %VAD 2
% title(sprintf('VAD com audio em 8 k - Bateria %i',iBateria))
legend('Audio L','Gabarito','Gabarito combinado','location','south')

fprintf('Time Elapsed: %.2f [s]',toc)





