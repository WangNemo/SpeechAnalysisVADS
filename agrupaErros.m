%% Agrupa erros

for iBateria = 1:5
    
    load(['Error/erroBateria',num2str(iBateria) '_Sergio','.mat'])
    load(['Error/VAD',num2str(iBateria),'.mat'])
    
    eval(['vecVADDBN',num2str(iBateria),'=vad_DBN;']);
    eval(['vecVADSohn',num2str(iBateria),'=vad_VADSOHN;']);
    eval(['vecVADG729',num2str(iBateria),'=vad_G729;']);
    
    eval(['vecVADDBN_8k',num2str(iBateria),'=vad_DBN_8k;']);
    eval(['vecVADSohn_8k',num2str(iBateria),'=vad_VADSOHN_8k;']);
    eval(['vecVADG729_8k',num2str(iBateria),'=vad_G729_8k;']);
    
    eval(['signal',num2str(iBateria),'=signal;']);
    eval(['signalResampled',num2str(iBateria),'=signalResampled;']);
    
    lengthSignal48 = length(eval(['signal' num2str(iBateria)]));
    lengthSignal8 =  length(eval(['signalResampled' num2str(iBateria)]));
    erroPondDBN_vec(iBateria) = erroPondDBN/lengthSignal48;
    erroPondG729_vec(iBateria) = erroPondG729/lengthSignal48;
    erroPondSohn_vec(iBateria) = erroPondSohn/lengthSignal48;
    erroPondComb_vec(iBateria) = erroPondComb/lengthSignal48;
    
    erroDBN_vec(iBateria) = erroVADDBN/lengthSignal48;
    erroSohn_vec(iBateria) = erroVADSohn/lengthSignal48;
    erroG729_vec(iBateria) = erroVADG729/lengthSignal48;
    erroCOMB_vec(iBateria) = erroCOMB/lengthSignal48;
    
    erroPondDBN_8k_vec(iBateria) = erroPondDBN_8k/lengthSignal8;
    erroPondG729_8k_vec(iBateria) = erroPondG729_8k/lengthSignal8;
    erroPondSohn_8k_vec(iBateria) = erroPondSohn_8k/lengthSignal8;
    erroPondComb_8k_vec(iBateria) = erroPondComb_8k/lengthSignal8;

    
    erroDBN_8k_vec(iBateria) = erroVADDBN_8k/lengthSignal8;
    erroSohn_8k_vec(iBateria) = erroVADSohn_8k/lengthSignal8;
    erroG729_8k_vec(iBateria) = erroVADG729_8k/lengthSignal8;
    erroCOMB_8k_vec(iBateria) = erroCOMB_8k/lengthSignal8;
    
    
end
%%
figure()
bpcombined = [erroDBN_vec(:), erroPondDBN_vec(:),...
    erroG729_vec(:), erroPondG729_vec(:), ...
    erroSohn_vec(:), erroPondSohn_vec(:),...
    erroCOMB_vec(:),erroPondComb_vec(:)];
hb = bar(1:5,bpcombined,'grouped');
xlabel('Bateria')
legend('DBN','DBN Ponderado','G729','G729 Ponderado',...
    'VADSohn','VADSohn Ponderado','Combinado', 'Combinado Ponderado')
title('Erros por bateria')
set(gca,'fontsize',30)
%%
figure()
bpcombined = [erroDBN_vec(:),...
    erroG729_vec(:), ...
    erroSohn_vec(:),erroCOMB_vec(:)];
hb = bar(1:5,bpcombined,'grouped');
xlabel('Bateria')
legend('DBN','G729','VADSohn','Combinado')
title('Erros por bateria fs = 48k')
set(gca,'fontsize',30)
%%
figure()
bpcombined = [erroPondDBN_vec(:), erroPondG729_vec(:), ...
    erroPondSohn_vec(:),erroPondComb_vec(:)];
hb = bar(1:5,bpcombined,'grouped');
xlabel('Bateria')
legend('DBN Ponderado','G729 Ponderado',...
    'VADSohn Ponderado','Combinado Ponderado')
title('Erros ponderados por bateria fs = 48k')
set(gca,'fontsize',30)

%% 8kHz
figure()
bpcombined = [erroPondDBN_8k_vec(:), erroPondG729_8k_vec(:), ...
    erroPondSohn_8k_vec(:),erroPondComb_8k_vec(:)];
hb = bar(1:5,bpcombined,'grouped');
xlabel('Bateria')
legend('DBN Ponderado','G729 Ponderado',...
    'VADSohn Ponderado', 'Combinado Ponderado')
title('Erros ponderados por bateria - fs 8kHz')
set(gca,'fontsize',30)

%%
figure()
bpcombined = [erroDBN_8k_vec(:),...
    erroG729_8k_vec(:), ...
    erroSohn_8k_vec(:),erroCOMB_8k_vec(:)];
hb = bar(1:5,bpcombined,'grouped');
xlabel('Bateria')
legend('DBN','G729','VADSohn','Combinado')
title('Erros por bateria 8 fs = kHz')
set(gca,'fontsize',30)