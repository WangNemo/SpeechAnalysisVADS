ccx %Limpeza XIRI
% Adicionar ao path a pasta de VADS e as subpastas
vadsPath = genpath('VADS');
matsPath = genpath('MATs');
bateria = 5; %%% MODIFICAR QUANDO RODAR OUTRA
addpath(vadsPath,matsPath); clear('matsPath','vadsPath')
% Carregar falas e determinar arquivo geral
controlGroup_bat2 =  dir([pwd,'/MATs/bat' num2str(bateria) '/*.mat']); %Listar diretório
bat2ControlG = cellstr({controlGroup_bat2.name});
tamanhoArquivoGeral = max([controlGroup_bat2.bytes]);
nArquivoGeral = find([controlGroup_bat2.bytes] == tamanhoArquivoGeral);
ArquivoGeral = controlGroup_bat2(nArquivoGeral).name;
 
%número de falas na bateria 
%(-1 pois o arquivo completo também está na pasta)
nFalas = length(bat2ControlG)-1; 
vecInicio = zeros(1,nFalas);
vecFim = zeros(1,nFalas);

% criar o vetor de tempo do gabarito
for falas = 1:nFalas 
load(['bat' num2str(bateria) '/bat' num2str(bateria) '.' num2str(falas) '.mat'])

    vecInicio(falas) = shdf.Tags.u_hppj_POINT_Mark_POINT_Start;
    vecFim(falas) = vecInicio(falas) + shdf.Tags.u_hppj_POINT_Mark_POINT_Duration;
end

vetorCompleto = sort([vecInicio vecFim]);
vecInicio = sort(vecInicio);
vecFim = sort(vecFim);
%% Carregar fala total
load(['bat' num2str(bateria) '/' (bat2ControlG{nArquivoGeral})])

fs = shdf.Chn.dSamplingrate;
len = length(shdf.Data(1,:));
durTotal = len/fs;
sinal = shdf.Data(1,:);
vecGabarito = zeros(1,len);

%Início da fala absoluto em segundos absoluto (arquivo exportado do Artemis
%envia o tempo relativo ao arquivo de audio gravado)
timeStart = shdf.Tags.u_hppj_POINT_Mark_POINT_Start; 
%% Criar vetor gabarito fs 48k

for iTrecho = 1:length(vecInicio)
    vecGabarito(1,(1+floor((vecInicio(iTrecho)-timeStart)*fs)):...
        floor((vecFim(iTrecho)-timeStart)*fs)) = ...
        ones(1,floor((vecFim(iTrecho)-timeStart)*fs)-...
        floor((vecInicio(iTrecho)-timeStart)*fs));
    
end

 %% VADSOHN
tic
vad_VADSOHN = vadsohn(sinal,shdf.Chn.dSamplingrate); %Aplicar VAD canal 1
tempoVadsohn = toc
%% VAD Robust
tic
VAD_DBN = vad_DNC(sinal);
tempoDBN = toc

%% Erros

% % Erro total
 

% 


% % Erro ponderado

vetErro_Sohn = vecGabarito(1:end-5)'-vad_VADSOHN;
vetErro_DBN = vecGabarito(1:end-5)'-VAD_DBN;
for i = 1:length(vetErro_Sohn)

    erro_pos_Sohn(i) = sum(1==vetErro_Sohn(i));
    erro_neg_Sohn(i) = sum(-1==vetErro_Sohn(i));
    
    erro_pos_DBN(i) = sum(1==vetErro_DBN(i));
    erro_neg_DBN(i) = sum(-1==vetErro_DBN(i));
    
end


erroPondSohn = 2*sum(erro_neg_Sohn) + sum(erro_pos_Sohn)
erroPondDBN = 2*sum(erro_neg_DBN) + sum(erro_pos_DBN)

erroVADSohn = (sum(vecGabarito(1:end-5)'-vad_VADSOHN))^2
erroVADDBN = (sum(vecGabarito(1:end-5)'-VAD_DBN))^2

difPond = erroPondDBN - erroPondSohn
difTotal = erroVADDBN - erroVADSohn

save(['erroBateria',num2str(bateria)],'erroPondSohn','erroPondDBN','erroVADSohn',...
    'erroVADDBN','difPond','difTotal')

%%
% Precisamos implementar isso 
% %% Tentativa de resample sem transformar em wav
% % vecResampleAux = 1:(1/48000):(shdf.Tags.u_hppj_POINT_Mark_POINT_Duration);
% % vecResampleAux2 = linspace(vecResampleAux(1),vecResampleAux(end),length(vecResampleAux));
% % teste_resample = resample(shdf.Data,48000,vecResampleAux2,8000);
% %%

[dados8k, fs8k] = audioread('Waves/bateria28k.wav');
uiopen('bateria28k.wav',1) %Esse arquivo eu transformei em wav previamente
len8k = length(dados8k);
durTotal8k = len8k/fs8k;
vecGabarito8k = zeros(1,len8k);
% 
 %% Criar vetor gabarito de fs = 8k
for iTrecho = 1:length(vecInicio)
    vecGabarito8k(1,1+floor(((vecInicio(iTrecho)-timeStart)*fs8k)):...
        floor((vecFim(iTrecho)-timeStart)*fs8k)) = ...
        ones(1,floor((vecFim(iTrecho)-timeStart)*fs8k)-floor((vecInicio(iTrecho)-timeStart)*fs8k));
end
vetorCompleto8k = sort([vecInicio vecFim]);


 tic
 vadG729 = G729Net(dados8k(:,1),8000,240,10);
 tempoG729 = toc
% 

%% Plot 
figure()
set(gcf, 'Position', get(0,'Screensize'));
plot(shdf.Absc1Data,shdf.Data(1,:)/max(abs(shdf.Data(1,:))))    %Sinal 
hold all
stairs(shdf.Absc1Data(1,:),((vecGabarito(1,1:(length(vecGabarito)-5))))*1.4,'k','linewidth',1.4) %Gabarito
stairs(shdf.Absc1Data(1,:),vad_VADSOHN*1.3,'linewidth',1.3) %VAD 1
stairs(shdf.Absc1Data(1,:),VAD_DBN*1.2,'linewidth',1.2) %VAD 1
               
legend('Audio L','Gabarito','VAD VADSOHN','VAD Robust')
%%
figure()
set(gcf, 'Position', get(0,'Screensize'));
plot(1:length(dados8k),dados8k(:,1))
hold on
stairs(1:length(dados8k),vecGabarito8k*1.4,'linewidth',1.3)                 %Gabarito 8k
stairs(1:length(dados8k),vadG729*1.2,'linewidth',1.3)     %VAD 2
legend('Audio L','Gabarito','VAD')
% %%
