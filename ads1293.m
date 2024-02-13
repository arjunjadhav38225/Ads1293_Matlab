fs=160;
a=0;

% Smooth the interval signal using a moving average filter
window_size = 6;  % Adjust the window size as needed
smooth_ecg = movmean(ecg1, window_size);

smooth_ecg(1:10) = [];

y=smooth_ecg ;
%plot(ecg2);
figure,plot(y);                                                                                                                                                                                                       
hold on
title('ECG signal');
xlabel('time');
ylabel('amplitude');
%% peak detection of ECG
j=1;
n=length(y);
pos = zeros(1,200);
val = zeros(1,200);
for i=2:n-1
    if y(i)> y(i-1) && y(i)>= y(i+1) && y(i) > 0.45 * max(y)
       val(j)= y(i);
       pos(j)=i;
       j=j+1;
     end
end
ecg_peaks=j-1;
ecg_pos = pos./200;
ecg_pos(ecg_pos == 0) = [];
plot(pos,val,'*r');
title('ECG peak');
RR_interval = zeros(1,200); 
for i=1:length(ecg_pos)
    if i < length(ecg_pos)
        RR_interval(i) = ecg_pos(i+1) - ecg_pos(i);
    end
end

RR_interval(RR_interval == 0) = [];
RR_interval(RR_interval < 0) = [];
RR_interval(RR_interval > 2) = [];
avg_RR = mean(RR_interval);

HR = 60/avg_RR;

%p peak detection of ECG
j=1;
k=1;
q=1;
n=length(y);
pos1 = zeros(1,200);
val1 = zeros(1,200);
for i=2:n-1
    if y(i)> y(i-1) && y(i)>= y(i+1) &&y(i)<=0.20*(max(y))&&y(i)>(0.0010)*(max(y))
            val1(j)= y(i);
            pos1(j)=i;
            j=j+1;
            k = k+1;
            q = q+1;
    end
end
p_ecg_peaks=j-1;
p_ecg_pos=pos1./200;
p_ecg_pos(p_ecg_pos == 0) = [];
plot(pos1,val1,'*g');
title('p ECG peak');
%% Q peak detection of ECG
j=1;
k=1;
q=1;
pos1 = zeros(1,200);
val1 = zeros(1,200);
for i=2:n-1
    if y(i)< y(i-1) && y(i)<= y(i+1) && y(i)>0.487909*min(y) && y(i)<0.13*min(y)&&y(i)>(-1.8)*max(y)&&i > pos1(q)     %%val(q) && i < pos(q)
            val1(j)= y(i);
            pos1(j)=i;
            j=j+1;
            k = k+1;
            q = q+1;
    end
end
q_ecg_peaks=j-1;
q_ecg_pos=pos1./200;
q_ecg_pos(q_ecg_pos == 0) = [];
plot(pos1,val1,'*b');
title('S ECG peak');
%% S peak detection of ECG
j=1;
k=1;
q=1;
n=length(y);
pos2 = zeros(1,200);
val2 = zeros(1,200);
for i=2:n-1
    if y(i)< y(i-1) && y(i)<= y(i+1) && y(i)< 0.4*min(y) && i > pos(q) && i < pos(q+1) 
            val2(j)= y(i);
            pos2(j)=i;
            j=j+1;
            k = k+1;
            q = q+1;
    end
end
s_ecg_peaks=j-1;

s_ecg_pos=pos2./200;
s_ecg_pos(s_ecg_pos == 0) = [];
plot(pos2,val2,'*m');
title('S ECG peak');
%% T peak detection of ECG
j=1;
k=1;
n=length(y);
pos3 = zeros(1,200);
val3 = zeros(1,200);
for i=2:n-1
    if y(i)> y(i-1) && y(i)>= y(i+1) && y(i)> 0.09*max(y) && y(i) < 0.25*max(y) 
       val3(j)= y(i);
       pos3(j)=i;
       j=j+1;
       k = k+1;
     end
end
t_ecg_peaks=j-1;
t_ecg_pos=pos3./200;
t_ecg_pos(t_ecg_pos == 0) = [];
plot(pos3,val3,'*b')

title('T ECG peak');

diff_t = zeros(1,20);
for i=1:length(t_ecg_pos)
    if(i < length(t_ecg_pos))
        diff_t(i) = t_ecg_pos(i+1) - t_ecg_pos(i);
    end
end
diff_t(diff_t == 0) = [];
diff_t(diff_t < 0) = [];

avg_TT = mean(diff_t);

%% T-end peak detection of ECG
j=1;
k=1;
q=1;
m = 1;
n=length(y);
pos5 = zeros(1,200);
val5 = zeros(1,200);
for i=2:n-1
    if y(i)> y(i-1) && y(i)>= y(i+1) && y(i)<0.30*max(y) && y(i) >0.18*max(y) 
   % if y(i)< y(i-1) && y(i)<= y(i+1) && y(i)> 0.4*min(y) && y(i) < val3(q) && y(i)< 0.10*min(y) && i > pos3(q) 
            val5(j)= y(i);
            pos5(j)=i;
            j=j+1;
            k = k+1;
            q = q+1;
            m=m+1;
    end
end
te_ecg_peaks=j-1;

te_ecg_pos=pos5./200;
te_ecg_pos(te_ecg_pos == 0) = [];
plot(pos5,val5,'*c');
title('TE ECG peak');
%% QT interval count
n = 1;
qt_interval = zeros(1,20);

for i=1:min(length(te_ecg_pos),length(q_ecg_pos))
    if(te_ecg_pos(i) > q_ecg_pos(i))
        qt_interval(n) = te_ecg_pos(i) - q_ecg_pos(i);
        n = n+1;
    end
end
%qt_interval(qt_interval > 1) = [];
avg_QT = mean(qt_interval);


%% QRS interval
qr_interval = zeros(1,20);
for i=1:min(length(q_ecg_pos),length(ecg_pos))
    if(ecg_pos(i) > q_ecg_pos(i))
        qr_interval(i) = ecg_pos(i) - q_ecg_pos(i);
    end
end

rs_interval = zeros(1,20);
for i=1:min(length(s_ecg_pos),length(ecg_pos))
     if(s_ecg_pos(i) > ecg_pos(i))
        rs_interval(i) = s_ecg_pos(i) - ecg_pos(i);
     end
end

%% PR interval
pr_interval = zeros(1,20);
for i=1:min(length(p_ecg_pos),length(ecg_pos))
    if(ecg_pos(i) > p_ecg_pos(i))
        pr_interval(i) = ecg_pos(i) - p_ecg_pos(i);
    end
end


rs_interval(rs_interval == 0) = [];
qr_interval(qr_interval == 0) = [];
rs_interval(rs_interval < 0) = [];
qr_interval(qr_interval < 0) = [];
rs_interval(rs_interval > 0.5) = [];
qr_interval(qr_interval > 0.5)= [];
avg_QR = mean(qr_interval);
avg_RS = mean(rs_interval);
qrs_interval = (avg_QR + avg_RS)*1000;
disp(length(y));
disp(mean(pr_interval));
% 1.Ventricular tachycardia - Wide QRS complex (duration > 120 ms)
if mean(qrs_interval) > 0.122
    disp('Ventricular tachycardia type arrhythmia detected.');
    a = a + 1;
end

% 2.Torsades de pointes - QT interval > 500 ms
if mean(qt_interval) > 0.5
    disp('Torsades de pointes type arrhythmia detected.');
    a = a + 1;
end

% 3. Long QT syndrome (LQTS) - QT interval > 440 ms
if mean(avg_QT) > 0.44
    disp('Long QT syndrome (LQTS) type arrhythmia detected.');
    a = a + 1;
end

% 4. Atrial flutter - Heart rate between 240-340, sawtooth pattern, and narrow QRS duration
if HR > 240 && HR < 340 && mean(qrs_interval) < 0.12
    disp('Atrial flutter type arrhythmia detected.');
    a = a + 1;
end

% 5. Atrial fibrillation (AF) - Irregularly irregular rhythm, absence of P waves, and narrow QRS complexes
if mean(qrs_interval) < 0.11 && p
    disp('Atrial fibrillation (AF) type arrhythmia detected.');
    a = a + 1;
end

% 6. Supraventricular tachycardia (SVT) - Narrow QRS complexes with a heart rate greater than 150 bpm
if HR > 150 && mean(qrs_interval) < 0.12
    disp('Supraventricular tachycardia (SVT) type arrhythmia detected.');
    a = a + 1;
end

% 7. Atrioventricular block (AV block) - Prolonged PR interval (>200 ms) or intermittent absence of QRS complexes
if mean(pr_interval) > 0.2
    disp('Atrioventricular block (AV block) type arrhythmia detected.');
    a = a + 1;
end

% 8. Normal
if a == 0
    disp('Normal');
end
disp(min(y));
disp(max(y));

    