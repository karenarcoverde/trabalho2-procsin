% frequencia de amostragem
Fs = 10000;

% frequencia do fim da primeira faixa de rejeição dividida por pi
Wr1 = 2*1000/Fs;                          

% frequencia do inicio da faixa de passagem dividida por pi
Wp1 = 2*1500/Fs;                           

% frequencia do fim da faixa de passagem dividida por pi
Wp2 = 2*2500/Fs;

% frequencia do inicio da segunda faixa de rejeição dividida por pi
Wr2 = 2*3000/Fs;

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


% resposta em frequencia
[h,w] = freqz(b,a);                 
freqz(b,a)                          

% grafico da resposta em escala linear
figure('units', 'centimeters', 'position', [3, 3, 20, 5])
plot(w/pi,abs(h))
grid on
xlabel('Normalized Frequency (\times\pi rad/sample)')
title('Magnitude |H(j\omega)|')

% digrama de polos e zeros
figure();
sys = tf(b,a);
pzplot(sys);
grid on;

figure();
zplane(b,a);
grid on