% frequencia de amostragem
FS = 10000;

% frequencia do fim da primeira faixa de rejeição dividida por pi
Wr1 = 2*1000/FS;                          

% frequencia do inicio da faixa de passagem dividida por pi
Wp1 = 2*1500/FS;                           

% frequencia do fim da faixa de passagem dividida por pi
Wp2 = 2*2500/FS;

% frequencia do inicio da segunda faixa de rejeição dividida por pi
Wr2 = 2*3000/FS;

% filtro escolhido 
% Como temos 50db de atenuacao, utilizaremos a janela de hamming
% que possui 53 dB de atenuacao

% ordem do filtro - n 
n = round(3.3*2/(Wp1 - Wr1)); 

% freqs de corte
Wn1 = (Wr1+Wp1)/2;
Wn2 = (Wr2+Wp2)/2;

% b: coeficientes do numerador de H(z)
% filtro FIR passa-faixa
b = fir1(n, [Wn1, Wn2], "bandpass", hamming(n+1));
% a: coeficiente do denominador de H(z)
a=1;

% carregando o sinais de audio
[~,Fs] = audioread('..\musica.wav');
tempo_inicial_segundos = 85;
tempo_inicial_amostras = tempo_inicial_segundos*Fs;
start = tempo_inicial_amostras;
samples = [start,start+5*Fs];
clear Fs
[x1,sr1] = audioread('..\musica.wav',samples);

[~,Fs] = audioread('..\voz.wav');
samples = [1,5*Fs];
clear Fs
[x2,sr2] = audioread('..\voz.wav',samples);

x1 = x1(:,1);
x2 = x2(:,1);

% --- Alterando a freq de amostragem para FS:
if sr1 ~= FS
   x1 = resample(x1, FS, sr1);
end
if sr2 ~= FS
   x2 = resample(x2, FS, sr2);
end

% Usando o filtro da questao 1 nos sinais:
y1 = filter(b,a,x1);
y2 = filter(b,a,x2);

% Descomente para ouvir os sinais:
%soundsc(y1,FS);
%soundsc(y2,FS);

% salva os resultados:
audiowrite('musica_filtrada.wav',y1,FS);
audiowrite('voz_filtrada.wav',y2,FS);

% espectrogramas
N = 256;
window = hamming(N);
Noverlap = N/2;

[sx1,fx1,tx1] = spectrogram(x1,window,Noverlap,N);
[sx2,fx2,tx2] = spectrogram(x2,window,Noverlap,N);
[sy1,fy1,ty1] = spectrogram(y1,window,Noverlap,N);
[sy2,fy2,ty2] = spectrogram(y2,window,Noverlap,N);

% Exibe os espectrogramas originais e filtrados:
f = figure('units', 'centimeters','position',[3,2,30,15]);
figure(f);
h = tiledlayout(2,2, 'Padding', 'compact');
nexttile
surf(tx1,fx1,20*log10(abs(sx1)),'LineStyle','none')
view(0,90)
title('Espectrograma de Potência do sinal musical original')
xlim([-inf inf]);
ylim([-inf inf]);
ylabel('frequência [Hz]')
colormap bone
colorbar
nexttile
surf(tx2,fx2,20*log10(abs(sx2)),'LineStyle','none')
view(0,90)
title('Espectrograma de Potência do sinal de voz original')
xlim([-inf inf])
ylim([-inf inf])
colormap bone
colorbar
nexttile
surf(ty1,fy1,20*log10(abs(sy1)),'LineStyle','none')
title('Espectrograma de Potência do sinal musical filtrado')
view(0,90)
xlim([-inf inf])
ylim([-inf inf])
ylabel('frequência [Hz]')
colormap bone
colorbar
nexttile
surf(ty2,fy2,20*log10(abs(sy2)),'LineStyle','none')
title('Espectrograma de Potência do sinal de voz filtrado')
view(0,90)
xlim([-inf inf])
ylim([-inf inf])
colormap bone
colorbar