%% RaceDefect Analyse - Außenring-Defekt (BUTTER-FIX!)
clear; close all; clc;

% 1. Daten laden
data = readtable('racedefect.csv');
t = data.time; 
acc_x = data.raceDefect_Output;

% Letzte 4000 Samples
N = 4000;
t = t(end-N+1:end);
acc_x = acc_x(end-N+1:end);
dt = t(2)-t(1);
fs = 1/dt;
f = (0:N/2-1)*(fs/N);

fprintf('=== RaceDefect Analyse ===\n');
fprintf('%d Samples, dt=%.1e s, fs=%.0f Hz\n', N, dt, fs);

%% 3 PLOTS
figure('Position',[50 50 1600 1000]);

% 1. ZEITBEREICH
subplot(3,1,1);
plot(t-t(1), acc_x, 'b-', 'LineWidth', 1.2);
xlim([0 2]); grid on; ylabel('acc_x [m/s²]');
title(sprintf('Zeitbereich - Außenring-Defekt (BPFO=152 Hz)'));

% 2. SPEKTRUM
subplot(3,1,2);
Y = fft(acc_x);
P = 2*abs(Y(1:N/2))/N;
plot(f, P, 'r-', 'LineWidth', 1.8); 
xlim([0 500]); grid on; ylabel('Amplitude');
hold on;
plot([25 25], [0 max(P)*0.8], 'g--', 'LineWidth', 3);
plot([50 50], [0 max(P)*0.6], 'g--', 'LineWidth', 3);
plot([75 75], [0 max(P)*0.4], 'g--', 'LineWidth', 3);
legend('Spektrum', '1×', '2×', '3×');

% 3. HÜLLKURVE (ROBUSTER BUTTER-FIX!)
subplot(3,1,3);
f_low = 500; f_high = min(5000, fs/2-100);  % Sichere Grenzen
Wn_low  = f_low  / (fs/2);
Wn_high = f_high / (fs/2);

% BUTTER-SICHERHEIT: Wn immer in (0,1)
if Wn_low > 0.01 && Wn_high < 0.99 && Wn_low < Wn_high
    [b,a] = butter(4, [Wn_low Wn_high], 'bandpass');
    acc_filt = filtfilt(b,a,acc_x);
else
    fprintf('Butter-Fallback: Breitband-Filter\n');
    [b,a] = butter(2, 0.3, 'high');  % Simple Hochpass
    acc_filt = filtfilt(b,a,acc_x);
end

env = abs(hilbert(acc_filt));
Y_env = fft(env);
P_env = 2*abs(Y_env(1:N/2))/N;
plot(f, P_env, 'm-', 'LineWidth', 2.5); 
xlim([0 500]); grid on; ylabel('Envelope'); xlabel('Frequenz [Hz]');
hold on;
plot(152, max(P_env)*0.9, 'ro', 'MarkerSize', 15, 'MarkerFaceColor', 'r');
text(160, max(P_env)*0.85, 'BPFO = 152 Hz', 'FontSize', 14, 'FontWeight', 'bold');

sgtitle('RaceDefect Validierung - Außenring-Defekt');

%% KENNZAHLEN
rms = sqrt(mean(acc_x.^2));
kurt = mean(acc_x.^4)/(rms^4);
crest = max(abs(acc_x))/rms;

fprintf('\n=== VALIDIERUNG ===\n');
fprintf('RMS:        %.3f m/s²\n', rms);
fprintf('Kurtosis:   %.2f\n', kurt);
fprintf('Crest:      %.2f\n', crest);
fprintf('fs:         %.0f Hz\n', fs);

% Speichern
saveas(gcf, 'racedefect_validation.png');
fprintf('Plot gespeichert: racedefect_validation.png\n');
