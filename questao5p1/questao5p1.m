% frequencia de amostragem
Fs = 10000;

% frequencia do fim da faixa de passagem divivida por pi
Wp = 2*1000/Fs;                          

% frequencia do inicio da faixa de rejeicao dividida por pi
Wr = 2*1500/Fs;  

rp_db = 0.25;
rs_db = 55;
dev = [(10^(rp_db/20)-1)/(10^(rp_db/20)+1) 10^(-rs_db/20)]; 

A = 50; % atenuacao na faixa de rejeicao

%-----definindo o filtro-----%
Wn = (Wr+Wp)/2; % freq de corte

[n,fo,ao,w] = firpmord([Wp Wr],[1 0],dev);
b = firpm(n,fo,ao,w);               % b: coef. do numerador de H(z)
a = 1;

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