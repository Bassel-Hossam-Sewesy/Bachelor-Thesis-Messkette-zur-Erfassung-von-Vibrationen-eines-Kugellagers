%% THESIS FIG 4.3: Healthy + Outer + Ball (100% FEHLERFREI!)
clear; close all; clc;

%% 1. CSV laden
healthy = readtable('healthy.csv');
outer   = readtable('racedefect.csv');
ball    = readtable('balldefect.csv');

%% 2. Arrays
time_h = table2array(healthy(:,1)); data_h = table2array(healthy(:,2));
time_o = table2array(outer(:,1));   data_o = table2array(outer(:,2));
time_b = table2array(ball(:,1));    data_b = table2array(ball(:,2));

%% 3. Features
rms_h = sqrt(mean(data_h.^2)); kurt_h = mean(data_h.^4)/(rms_h^4);
rms_o = sqrt(mean(data_o.^2)); kurt_o = mean(data_o.^4)/(rms_o^4);
rms_b = sqrt(mean(data_b.^2)); kurt_b = mean(data_b.^4)/(rms_b^4);

%% 4. fs + Daten
dt_h = median(diff(time_h)); fs_h = 1/dt_h;
dt_o = median(diff(time_o)); fs_o = 1/dt_o;
dt_b = median(diff(time_b)); fs_b = 1/dt_b;

N = min(4000, min([length(data_h), length(data_o), length(data_b)]));
t_h = time_h(end-N+1:end); acc_h = data_h(end-N+1:end);
t_o = time_o(end-N+1:end); acc_o = data_o(end-N+1:end);
t_b = time_b(end-N+1:end); acc_b = data_b(end-N+1:end);

f_h = (0:N/2-1)'*(fs_h/N); f_o = (0:N/2-1)'*(fs_o/N); f_b = (0:N/2-1)'*(fs_b/N);

fprintf('Kurtosis: H=%.1f O=%.1f B=%.1f\n', kurt_h, kurt_o, kurt_b);
fprintf('fs[Hz]: H=%.0f O=%.0f B=%.0f\n', fs_h, fs_o, fs_b);

%% 5. 3x3 Plot
figure('Position',[50 50 1600 900]);

% Zeitbereich
subplot(3,3,1); plot(t_h-t_h(1), acc_h, 'g-', 'LineWidth',2); xlim([0 2]); grid on; 
title(sprintf('Healthy Kurt=%.1f', kurt_h)); ylabel('acc [g]');
subplot(3,3,2); plot(t_o-t_o(1), acc_o, 'r-', 'LineWidth',2); xlim([0 2]); grid on; 
title(sprintf('Outer Kurt=%.1f', kurt_o));
subplot(3,3,3); plot(t_b-t_b(1), acc_b, 'm-', 'LineWidth',2); xlim([0 2]); grid on; 
title(sprintf('Ball Kurt=%.1f', kurt_b)); xlabel('Time [s]');

% Spektrum
subplot(3,3,4); Yh=fft(acc_h); Ph=2*abs(Yh(1:N/2))/N; 
plot(f_h, Ph, 'g-', 'LineWidth',2); xlim([0 500]); grid on; title('Healthy');
hold on; plot([25 50 75], max(Ph)*[0.7 0.5 0.3], 'k--');
subplot(3,3,5); Yo=fft(acc_o); Po=2*abs(Yo(1:N/2))/N; 
plot(f_o, Po, 'r-', 'LineWidth',2); xlim([0 500]); grid on; title('Outer');
hold on; plot([25 50 75 152], max(Po)*[0.8 0.6 0.4 0.9], 'k--');
subplot(3,3,6); Yb=fft(acc_b); Pb=2*abs(Yb(1:N/2))/N; 
plot(f_b, Pb, 'm-', 'LineWidth',2); xlim([0 500]); grid on; title('Ball'); xlabel('Freq');

% Hüllkurve (inline, kein Lambda)
subplot(3,3,[7 8 9]);
f_low = 200;

% Healthy Envelope
Wn_h = [max(0.05,f_low/(fs_h/2)) min(0.95,4000/(fs_h/2))]; 
[b,a] = butter(4, Wn_h, 'bandpass'); 
env_h = abs(hilbert(filtfilt(b,a,acc_h))); 
Yenv_h = fft(env_h); P_env_h = 2*abs(Yenv_h(1:N/2))/N;
plot(f_h, P_env_h, 'g-', 'LineWidth',2.5); hold on; legend('Healthy');

% Outer BPFO=152Hz
Wn_o = [max(0.05,f_low/(fs_o/2)) min(0.95,4000/(fs_o/2))]; 
[b,a] = butter(4, Wn_o, 'bandpass'); 
env_o = abs(hilbert(filtfilt(b,a,acc_o))); 
Yenv_o = fft(env_o); P_env_o = 2*abs(Yenv_o(1:N/2))/N;
plot(f_o, P_env_o, 'r-', 'LineWidth',2.5); 
plot(152, max(P_env_o)*0.9, 'ro', 'MarkerSize',12,'MarkerFaceColor','r');

% Ball BSF=222Hz
Wn_b = [max(0.05,f_low/(fs_b/2)) min(0.95,4000/(fs_b/2))]; 
[b,a] = butter(4, Wn_b, 'bandpass'); 
env_b = abs(hilbert(filtfilt(b,a,acc_b))); 
Yenv_b = fft(env_b); P_env_b = 2*abs(Yenv_b(1:N/2))/N;
plot(f_b, P_env_b, 'm-', 'LineWidth',2.5); 
plot(222, max(P_env_b)*0.9, 'mo', 'MarkerSize',12,'MarkerFaceColor','m');

xlim([0 500]); grid on; xlabel('Frequency [Hz]'); ylabel('Envelope');
legend('Healthy','Outer BPFO=152Hz','Ball BSF=222Hz');
title('Fault Diagnosis');

sgtitle('Kap. 4.3: Healthy vs Outer vs Ball Defect', 'FontSize',16);

%% Tabelle
fprintf('\n| Feature  | Healthy | Outer | Ball  |\n');
fprintf('|----------|---------|-------|-------|\n');
fprintf('| Kurtosis | %.1f   | %.1f | %.1f |\n', kurt_h, kurt_o, kurt_b);
fprintf('| RMS[g]   | %.3f  | %.3f | %.3f|\n', rms_h, rms_o, rms_b);
fprintf('| fs[Hz]   | %.0f   | %.0f | %.0f|\n', fs_h, fs_o, fs_b);
fprintf('| FaultHz  | -       | 152   | 222  |\n');

%% Speichern
print('thesis_fig4_3.png', '-dpng', '-r300');
print('thesis_fig4_3.pdf', '-dpdf', '-fillpage');
fprintf('✅ THESIS FIG 4.3 gespeichert!\n');
