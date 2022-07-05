% frequencia de amostragem
Fs = 10000;

% frequencia do fim da faixa de passagem divivida por pi
Wp = 2*1000/Fs;                          

% frequencia do inicio da faixa de rejeicao dividida por pi
Wr = 2*1500/Fs;                           

% filtro escolhido 
% Como temos 50db de atenuacao, utilizaremos a janela de hamming
% que possui 53 dB de atenuacao

% ordem do filtro - n 
n = round(3.3*2/(Wr - Wp)); 

% freq de corte
Wn = (Wr+Wp)/2; 

% b: coeficientes do numerador de H(z)
% filtro FIR passa-baixas
b = fir1(n,Wn, 'low', hamming(n+1));    
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
sys = tf(b,a);
pzplot(sys);
zplane(b,a);
grid on
