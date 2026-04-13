%% Frequenzgang: Sensor vs. gesamte Messkette
clear; clc; close all;

% =========================================
% 1) Parameter des IEPE-Sensors
% =========================================
g_n   = 9.80665;
Sq    = 3.10e-12 / g_n;   % [C/(m/s^2)]
Cf    = 100e-12;          % [F]
Rf    = 1e9;              % [Ohm]
f_hp  = 0.5;              % [Hz]
f_res = 30000;            % [Hz]
zeta  = 0.01;             % [-]

% =========================================
% 2) Anti-Aliasing-Filter
% =========================================
Naa   = 4;                % Filterordnung
f_caa = 1000;             % Grenzfrequenz [Hz]

% =========================================
% 3) Sampling / ZOH
% =========================================
fs = 5120;                % [Hz]
Ts = 1/fs;
fN = fs/2;                % Nyquist-Frequenz

% =========================================
% 4) Frequenzachse
% =========================================
f = logspace(-1, 5, 6000);   % 0.1 Hz bis 100 kHz
w = 2*pi*f;
s = 1j*w;

% =========================================
% 5) Sensor-Modell
% =========================================
w_hp = 2*pi*f_hp;
w_n  = 2*pi*f_res;

% Hochpass
H_hp = s ./ (s + w_hp);

% Resonanzglied 2. Ordnung
H_res = (w_n^2) ./ (s.^2 + 2*zeta*w_n*s + w_n^2);

% Rückkopplungsimpedanz des Charge Amplifier
% Zf = (1/sCf || Rf) = Rf / (1 + s*Rf*Cf)
Zf = Rf ./ (1 + s*Rf*Cf);

% Gesamter Sensorsignalpfad
% v_out / acc = -Sq * s * H_hp * H_res * Zf
H_sensor = -(Sq .* s .* H_hp .* H_res .* Zf);   % [V/(m/s^2)]

% =========================================
% 6) Analoges Anti-Aliasing-Filter
% =========================================
Wc = 2*pi*f_caa;
[b,a] = butter(Naa, Wc, 's');
H_aa = freqs(b,a,w);

% Sensor + AA
H_sensor_aa = H_sensor .* H_aa;

% =========================================
% 7) Zero-Order-Hold
% =========================================
H_zoh = exp(-1j*w*Ts/2) .* (sin(pi*f*Ts) ./ (pi*f*Ts));
H_zoh(f == 0) = 1;

% gesamte Messkette
H_total = H_sensor_aa .* H_zoh;

% =========================================
% 8) Betrag in dB
% =========================================
magdB = @(H) 20*log10(abs(H));

% =========================================
% 9) Plot 1: Nur Sensor
% =========================================
figure('Color','w','Position',[100 100 1100 500]);
semilogx(f, magdB(H_sensor), 'k', 'LineWidth', 1.8); 
grid on; grid minor; hold on;
xline(f_hp,  'r--', 'f_{hp}');
xline(f_res, 'm--', 'f_{res}');
xlabel('Frequenz [Hz]');
ylabel('Amplitude [dB]');
title('Frequenzgang des modellierten IEPE-Beschleunigungssensors');
xlim([0.1 1e5]);

% =========================================
% 10) Plot 2: Sensor + Anti-Aliasing
% =========================================
figure('Color','w','Position',[120 120 1100 500]);
semilogx(f, magdB(H_sensor),    '--', 'Color',[0.5 0.5 0.5], 'LineWidth', 1.2, ...
    'DisplayName','Nur Sensor'); 
hold on;
semilogx(f, magdB(H_sensor_aa), 'k', 'LineWidth', 1.8, ...
    'DisplayName','Sensor + Anti-Aliasing');
grid on; grid minor;
xline(f_hp,   'r--', 'f_{hp}');
xline(f_caa,  'b--', 'f_c');
xline(f_res,  'm--', 'f_{res}');
xlabel('Frequenz [Hz]');
ylabel('Amplitude [dB]');
title('Frequenzgang von Sensor und analogem Anti-Aliasing-Filter');
legend('Location','southwest');
xlim([0.1 1e5]);

% =========================================
% 11) Plot 3: Gesamte Messkette
% =========================================
figure('Color','w','Position',[140 140 1100 500]);
semilogx(f, magdB(H_sensor),    '--', 'Color',[0.6 0.6 0.6], 'LineWidth', 1.0, ...
    'DisplayName','Nur Sensor'); 
hold on;
semilogx(f, magdB(H_sensor_aa), '--', 'Color',[0.2 0.2 0.8], 'LineWidth', 1.2, ...
    'DisplayName','Sensor + Anti-Aliasing');
semilogx(f, magdB(H_total),     'k', 'LineWidth', 1.8, ...
    'DisplayName','Gesamte Messkette inkl. ZOH');
grid on; grid minor;
xline(f_hp,   'r--', 'f_{hp}');
xline(f_caa,  'b--', 'f_c');
xline(fN,     'g--', 'f_N');
xline(f_res,  'm--', 'f_{res}');
xlabel('Frequenz [Hz]');
ylabel('Amplitude [dB]');
title('Frequenzgang der gesamten Messkette');
legend('Location','southwest');
xlim([0.1 1e5]);

% =========================================
% 12) Optional: Speichern
% =========================================
saveas(figure(1), 'bode_sensor_only.png');
saveas(figure(2), 'bode_sensor_aa.png');
saveas(figure(3), 'bode_total_chain.png');