%47 Year Old Male ECG
load('14149m.mat');
%Loading Data
fs = 128; %sampling rate or frequency
T = 1/fs;
ecg = val(1,:);
N = length(ecg);
tx = [0:N-1]/fs;
figure
plot(tx,ecg);
xlabel('Time(s)')
ylabel('Amplitude (mV)')
title('ECG Signal of 47 Year Old Male')
axis([0 60 -400 400]);
%Finding R Peaks & Marking them on ECG
[qrs,locs_Rwave] = findpeaks(ecg,tx,'MinPeakHeight',27,...
'MinPeakDistance',0.36);
figure
hold on
plot(tx,ecg);
plot(locs_Rwave,qrs,'rv','MarkerFaceColor','r');
legend('ECG Signal','R-waves');
xlabel('Time(s)'); ylabel('Voltage(mV)')
title('R-waves in ECG Signal')
axis([0 60 -400 400])
%Finding RR Intervals & Storing them in an Array
rrint = [];
for i = 1 : length(locs_Rwave)-1
rr_interval = (locs_Rwave(i+1))-(locs_Rwave(i));
s = ['RR Interval ', num2str(i), ' is ', num2str(rr_interval)];
disp(s);
rrint(i) = rr_interval;
end
%Plotting Tachograms/RR Interval Plots
figure
ts = [0:1:97];
stem(ts,rrint,'filled');
xlabel('Index'); ylabel('RR Intervals (seconds)')
title('RR Interval Plot')
axis([0 75 0 2])
grid on
figure
plot(ts,rrint);
xlabel('Index');ylabel('RR Intervals (seconds)')
title('RR Intervals')
axis([0 75 -1 2])
grid on
53
figure
stem(locs_Rwave(2:99),rrint, 'filled');
hold on
plot(locs_Rwave(2:99),rrint);
xlabel('Time (seconds)');ylabel('RR Intervals (seconds)')
title('RR Intervals Time-Plot')
axis([0 60 0 2])
grid on
%Time-Domain calculations of RR intervals
RRmean = mean(rrint); %mean
RRmedian = median(rrint); %median
RRmode = mode(rrint); % mode
RRvariance = var(rrint); % variance
RRskew = skewness(rrint);
RRkurt = kurtosis(rrint); %
RRiqr = iqr(rrint); %
RRstd = std(rrint); % standard deviation
RRrms = rms(rrint); % root mean square
%Interpolating RR Interval Plot
XA = 0:0.5:48.5;
x = XA;
xq = 0:0.05:48.5;
interp_rrint = interp1(x, rrint,xq, 'spline');
figure()
plot(x, rrint, 'o')
hold on
plot(xq, interp_rrint, '-r')
hold off
grid
xlabel('Time (seconds)')
ylabel('RR Intervals')
legend('Original Data', 'Interpolation', 'Location', 'NE')
%Subtracting Mean to discard any DC
%Plotting Power Spectrum Density through FFT
final = interp_rrint - RRmean;
figure
fanalysis = fft(final);
L = length(final);
P2 = abs(fanalysis/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
freq = 0: 0.5: 242.5;
plot(freq/100,P1)
title('Single-Sided Amplitude Spectrum of Interpolated RR Intervals')
xlabel('f (Hz)')
ylabel('|P1(f)|')
axis([0 1 0 0.5])
grid on;
