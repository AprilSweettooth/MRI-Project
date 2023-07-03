start_mag=[ 0 0 1];
b0_offset_Hz=[-1000:0.2:1000].';
start_mag=[zeros(1,numel(b0_offset_Hz));zeros(1,numel(b0_offset_Hz));ones(1,numel(b0_offset_Hz))].';
%% Excitation
b1_Hz=2500;
tp_ms=0.1;

excitation_mag=rodrigues_bloch(start_mag,b1_Hz,tp_ms,b0_offset_Hz,0);

%% Period of free precession
tp_ms= 100;

freeprecess_mag=rodrigues_bloch(excitation_mag,0,tp_ms,b0_offset_Hz,0);

%% 180 degree refocusing pulse 
b1_Hz=5250;
tp_ms= 0.1;

refocussed_mag=rodrigues_bloch(freeprecess_mag,b1_Hz,tp_ms,b0_offset_Hz,0);

%% Second period of free precession before the echo
tp_ms= 100;

echo_mag=rodrigues_bloch(refocussed_mag,0,tp_ms,b0_offset_Hz,0);

%% Calculate and plot the signals 

Mx=echo_mag(:,1);
My=echo_mag(:,2);
Mz=echo_mag(:,3);
Mabs=sqrt(Mx.^2+My.^2);


figure(7901)
clf
subplot(3,1,1)
plot(b0_offset_Hz,My)
title('M_y')
xlabel('\Omega / Hz')
subplot(3,1,2)
plot(b0_offset_Hz,Mx)
title('M_x')
xlabel('\Omega')
subplot(3,1,3)
plot(b0_offset_Hz,Mabs)
title('M_a_b_s')
xlabel('\Omega')

