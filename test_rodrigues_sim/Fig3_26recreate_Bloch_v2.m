%% Sequence timing 

% N.B. This code needs RodgersSpectroTools on the path.
% e.g.: run('D:\Oxford\MATLAB\RodgersSpectroToolsV2\main\startup.m')

%% Do the Bloch calcn
seqTiming=sim_90excitation;

% chop off everything after the pulse!
lastpt = find(seqTiming.b1_Hz>450,1,'last');
seqTiming.b1_Hz   = seqTiming.b1_Hz  (1:lastpt); % maybe lastpt+1 ?
seqTiming.tp_s    = seqTiming.tp_s   (1:lastpt); % maybe lastpt+1 ?
seqTiming.grad    = seqTiming.grad   (1:lastpt); % maybe lastpt+1 ?
seqTiming.spoil   = seqTiming.spoil  (1:lastpt); % maybe lastpt+1 ?
seqTiming.readout = seqTiming.readout(1:lastpt); % maybe lastpt+1 ?

DeltaB0_Hz=[-10000:0.1:10000];
T1_s=100000000000;
T2_s=100000000000;
mx_start=zeros(1,numel(DeltaB0_Hz));
my_start=zeros(1,numel(DeltaB0_Hz));
mz_start=ones(1,numel(DeltaB0_Hz));

delta_tp_s = diff([0 seqTiming.tp_s]);


%% Simulate 
[mx, my, mz]...
    = bloch_CTR_Hz(seqTiming.b1_Hz,seqTiming.grad,delta_tp_s,T1_s,T2_s,DeltaB0_Hz,0,0,...
                      mx_start,... %mx
                       my_start,... %my
                        mz_start,...  %mz
                        double(seqTiming.spoil)); 

%% Make combined plot
% Plot the analytical sim first
Fig3_26recreate

% Plot results from this bloch_CTR_Hz run
Mabs=sqrt(mx.^2+my.^2);

figure(7901)
% clf
subplot(3,1,1)
hold on
plot(DeltaB0_Hz/max(seqTiming.b1_Hz),my,'.')
title('M_y')
xlabel('\Omega / \omega_1')
subplot(3,1,2)
hold on
plot(DeltaB0_Hz/max(seqTiming.b1_Hz),mx,'.')
title('M_x')
xlabel('\Omega / \omega_1')
subplot(3,1,3)
hold on
plot(DeltaB0_Hz/max(seqTiming.b1_Hz),Mabs,'.')
title('M_a_b_s')
xlabel('\Omega / \omega_1')

legend({'Analytical','bloch_CTR_Hz MEX'},'interpreter','none')

%% Plot the B1 waveform
figure(7903)
clf
plot(cumsum(delta_tp_s),seqTiming.b1_Hz)
