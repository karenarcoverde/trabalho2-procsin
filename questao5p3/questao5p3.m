% frequencia de amostragem
Fs = 10000;

% frequencia do fim da faixa de passagem divivida por pi
Wp = 2*1000/Fs;                          

% frequencia do inicio da faixa de rejeicao dividida por pi
Wr = 2*1500/Fs;  

rp_db = 0.25;
rs_db = 50;
dev = [(10^(rp_db/20)-1)/(10^(rp_db/20)+1) 10^(-rs_db/20)]; 

A = 50; % atenuacao na faixa de rejeicao

%-----definindo o filtro-----%
Wn = (Wr+Wp)/2; % freq de corte

[n,fo,ao,w] = firpmord([Wp Wr],[1 0],dev);
b = firpm(n,fo,ao,w);               % b: coef. do numerador de H(z)
a = 1;

% carregando o sinais de audio
[~,Fs] = audioread('../musica.wav');
tempo_inicial_segundos = 85;
tempo_inicial_amostras = tempo_inicial_segundos*Fs;
start = tempo_inicial_amostras;
samples = [start,start+5*Fs];
clear Fs
[x1,sr1] = audioread('../musica.wav',samples);

[~,Fs] = audioread('../voz.wav');
samples = [1,5*Fs];
clear Fs
[x2,sr2] = audioread('../voz.wav',samples);

x1 = x1(:,1);
x2 = x2(:,1);

% --- Alterando a freq de amostragem para FS:
if sr1 ~= FS
   x1 = resample(x1, FS, sr1);
end
if sr2 ~= FS
   x2 = resample(x2, FS, sr2);
end

% Potencia dos sinais
pot_x2 = sum(x2.^2)/length(x2);
pot_x1 = sum(x1.^2)/length(x1);

% SNR = 10*log(pot_sinal/pot_ruido):
SNR = 10; 
pot_ruido_x2 = pot_x2/10^(SNR/10);
pot_ruido_x1 = pot_x1/10^(SNR/10);

% pot_ruido = desvio_padrao^(1/2):
desvio_x2 = pot_ruido_x2^(1/2);
desvio_x1 = pot_ruido_x1^(1/2);

% Colocando ruido branco nos sinais
contaminado_x2 = x2 + desvio_x2.*randn(length(x2),1);
contaminado_x1 = x1 + desvio_x1.*randn(length(x1),1);

t_contaminado_x2 = (1:length(contaminado_x2))/FS;
t_contaminado_x1 = (1:length(contaminado_x1))/FS;

% Usando o filtro da questao 1 nos sinais:
y1 = filter(b,a,contaminado_x1);
y2 = filter(b,a,contaminado_x2);

% salva os resultados:
audiowrite('musica_contaminada_filtrada.wav',y1,FS);
audiowrite('voz_contaminada_filtrada.wav',y2,FS);

% Espectogramas
N = 256;
window = hamming(N);
Noverlap = N/2;
figure('units', 'centimeters', 'position', [2, 2, 23, 10])
spectrogram(y1, window, Noverlap, N, 'yaxis')
title('musica.wav contaminada e filtrada')
colormap bone
figure('units', 'centimeters', 'position', [2, 2, 23, 10])
spectrogram(y2, window, Noverlap, N, 'yaxis')
title('voz.wav contaminada e filtrada')
colormap bone

%soundsc(y1, FS)
%soundsc(y2, FS)