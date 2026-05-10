% --- Load ---
T = readmatrix("RacedefecttOuterFTData.csv");
t = T(:,1);
x = T(:,2);

% --- Sampling (must match your Samplerblock: Ts = 1/5120) ---
fs = 5120;
Ts = 1/fs;

% --- Remove duplicate time stamps (events) ---
[t_unique, idx_unique] = unique(t, 'stable');
x_unique = x(idx_unique);

% --- Resample to uniform grid ---
t_u = (t_unique(1):Ts:t_unique(end))';
x_u = interp1(t_unique, x_unique, t_u, 'linear', 'extrap');

% --- Use only stationary part (e.g., last 10 s) ---
idx = (t_u >= (t_u(end)-10)) & (t_u < t_u(end));
x_u = x_u(idx);

% --- Detrend / remove DC ---
x_u = x_u - mean(x_u);

% =========================
% 1) ENVELOPE ANALYSIS
% =========================

% Bandpass must be < Nyquist (= 2560 Hz)
bp = designfilt('bandpassiir', 'FilterOrder', 4, ...
    'HalfPowerFrequency1', 0.5, ...
    'HalfPowerFrequency2', 1000, ...
    'SampleRate', fs);

x_bp  = filtfilt(bp, x_u);

% Hilbert envelope
x_env = abs(hilbert(x_bp));
x_env = x_env - mean(x_env);

% Envelope FFT
N = length(x_env);
w = hann(N);
X = fft(x_env .* w);

P2 = abs(X) / sum(w);
P1 = P2(1:floor(N/2)+1);
P1(2:end-1) = 2*P1(2:end-1);
f = fs*(0:floor(N/2))/N;

% ---------- Pretty envelope plot with legend ----------
figure;
plot(f, 20*log10(P1), 'k', 'LineWidth', 1.2); 
grid on; xlim([0 200]);
xlabel('Frequency [Hz]');
ylabel('Envelope amplitude [dB] (rel.)');
title('Envelope Spectrum');

set(gca,'FontSize',12);
set(gcf,'Color','w');

hold on;

% Expected lines (for your bearing @ 17 Hz shaft speed)
xline(17,'--','Color',[0 0.6 0],'LineWidth',1.6,'DisplayName','1x shaft');
xline(34,'-','Color',[0 0.4 0],'LineWidth',1.6,'DisplayName','2x shaft');

xline(6.784,'--','Color',[0 0.7 0.7],'LineWidth',1.6,'DisplayName','FTF');
xline(13.567,'-','Color',[0 0.7 0.7],'LineWidth',1.6,'DisplayName','2x FTF');

xline(40.377,'--','Color',[0.9 0 0],'LineWidth',1.8,'DisplayName','BSF');
xline(80.754,'-','Color',[0.9 0 0],'LineWidth',1.8,'DisplayName','2x BSF');

xline(61.052,'--','Color',[0 0 0],'LineWidth',1.6,'DisplayName','BPFO');
xline(122.104,':','Color',[0 0 0],'LineWidth',1.6,'DisplayName','2x BPFO');

xline(91.948,'--','Color',[0 0.2 1],'LineWidth',1.6,'DisplayName','BPFI');
xline(183.896,'-','Color',[0 0.2 1],'LineWidth',1.6,'DisplayName','2x BPFI');

legend('Location','northeast');
hold off;

% =========================
% 2) OPTIONAL: show where the bandpass sits in raw spectrum
% =========================

% Raw FFT (for sanity)
N2 = length(x_u);
w2 = hann(N2);
X2 = fft(x_u .* w2);

P2r = abs(X2)/sum(w2);
P1r = P2r(1:floor(N2/2)+1);
P1r(2:end-1) = 2*P1r(2:end-1);
fr = fs*(0:floor(N2/2))/N2;

% ---------- Pretty raw spectrum plot with legend ----------
figure;
plot(fr, 20*log10(P1r), 'k', 'LineWidth', 1.2);
grid on; xlim([0 2560]);
xlabel('Frequency [Hz]'); ylabel('Raw amplitude [dB] (rel.)');
title('Raw Spectrum (for band selection)');

set(gca,'FontSize',12);
set(gcf,'Color','w');

hold on;
xline(1300,'--','Color',[0.8 0 0.8],'LineWidth',1.6,'DisplayName','Bandpass lower edge');
xline(1900,'--','Color',[0.8 0 0.8],'LineWidth',1.6,'DisplayName','Bandpass upper edge');
legend('Location','northeast');
hold off;

% Optional export (vector PDF for thesis)
% exportgraphics(gcf,'RawSpectrum.pdf','ContentType','vector')
% (run export for envelope figure similarly)