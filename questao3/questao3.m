[musica,Fs_musica] = audioread('musica_filtrada.wav');

[voz,Fs_voz] = audioread('voz_filtrada.wav');

voz = voz(:,1);
musica = musica(:,1);

FS = 10000;

% --- Alterando a freq de amostragem para FS:
if Fs_musica ~= FS
   musica = resample(musica, FS, Fs_musica);
end
if Fs_voz ~= FS
   voz = resample(voz, FS, Fs_voz);
end

% Potencia dos sinais
pot_voz = sum(voz.^2)/length(voz);
pot_musica = sum(musica.^2)/length(musica);

% SNR = 10*log(pot_sinal/pot_ruido):
SNR = 10; 
pot_ruido_voz = pot_voz/10^(SNR/10);
pot_ruido_musica = pot_musica/10^(SNR/10);

% pot_ruido = desvio_padrao^(1/2):
desvio_voz = pot_ruido_voz^(1/2);
desvio_musica = pot_ruido_musica^(1/2);

% Colocando ruido branco nos sinais
contaminado_voz = voz + desvio_voz.*randn(length(voz),1);
contaminado_musica = musica + desvio_musica.*randn(length(musica),1);

t_contaminado_voz = (1:length(contaminado_voz))/FS;
t_contaminado_musica = (1:length(contaminado_musica))/FS;

% Espectogramas
N = 512;
window = hamming(N);
Noverlap = N/2;
figure('units', 'centimeters', 'position', [2, 2, 23, 10])
spectrogram(contaminado_voz, window, Noverlap, N, 'yaxis')
title('voz.wav')
colormap bone
figure('units', 'centimeters', 'position', [2, 2, 23, 10])
spectrogram(contaminado_musica, window, Noverlap, N, 'yaxis')
title('musica.wav')
colormap bone

%soundsc(contaminado_voz, FS)
soundsc(contaminado_musica, FS)
