%% Hüllkurvenspektrum bei 300 Hz Abtastrate
clear; clc; close all;

T = readmatrix('Sampler300Hz.csv');

t_raw = T(:,1);
x_raw = T(:,2);

% Ziel-Abtastzeit
fs_target = 300;
Ts = 1/fs_target;

% Sample-Indizes bestimmen
n = round(t_raw / Ts);

% Nur Punkte behalten, die auf dem 300-Hz-Raster liegen
idx = abs(t_raw - n*Ts) < 1e-7;

n_s = n(idx);
x_s = x_raw(idx);

% Für jeden Sample-Zeitpunkt den LETZTEN Wert nehmen
[n_unique, ia] = unique(n_s, 'last');

% Sortieren
[n_unique, order] = sort(n_unique);
ia = ia(order);

t = n_unique * Ts;
x = x_s(ia);

% Samplingfrequenz prüfen
fs = 1/mean(diff(t));
fN = fs/2;

fprintf('Anzahl Samples: %d\n', length(t));
fprintf('Samplingrate: %.2f Hz\n', fs);
fprintf('Nyquist-Frequenz: %.2f Hz\n', fN);

% DC entfernen
x = x - mean(x);

% Hüllkurve
env = abs(hilbert(x));
env = env - mean(env);

% FFT
N = length(env);
w = hann(N);

X = fft(env .* w);
X = X(1:floor(N/2)+1);

f = (0:floor(N/2))' * fs / N;

mag = abs(X);
mag = mag / max(mag + 1e-12);
Xdb = 20*log10(mag + 1e-12);

% Frequenzen
f_rot = 17;
f_2x  = 34;
FTF   = 6.784;
BSF   = 40.377;
BPFO  = 61.052;
BPFI  = 91.948;

% Plot
figure('Color','w','Position',[100 100 1000 500]);

plot(f, Xdb, 'k', 'LineWidth', 1.5);
grid on; hold on;

xline(f_rot ,'g--','1x shaft','LineWidth',1.2);
xline(f_2x  ,'g-' ,'2x shaft','LineWidth',1.2);
xline(FTF   ,'c--','FTF','LineWidth',1.2);
xline(BSF   ,'r--','BSF','LineWidth',1.2);
xline(BPFO  ,'k--','BPFO','LineWidth',1.2);
xline(BPFI  ,'b--','BPFI','LineWidth',1.2);
xline(fN    ,'m--','Nyquist','LineWidth',1.5);

xlabel('Frequenz [Hz]');
ylabel('Amplitude [dB rel.]');
title('Hüllkurvenspektrum bei Abtastrate 300 Hz');

xlim([0 fN]);
ylim([-80 5]);

exportgraphics(gcf, 'Envelope_300Hz_corrected.png', 'Resolution', 300);