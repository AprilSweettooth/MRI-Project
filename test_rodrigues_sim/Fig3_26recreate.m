%% Reproducing figure 3.26 from http://www-keeler.ch.cam.ac.uk/lectures/understanding/chapter_3.pdf 
% not using any of the BlochSim code
% 90 degree excitation pulse 


b1_Hz=500;
tp_ms=0.5;
b0_offset_Hz=[-10000:.2:10000].';
start_mag=[zeros(1,numel(b0_offset_Hz));zeros(1,numel(b0_offset_Hz));ones(1,numel(b0_offset_Hz))].';
end_mag=rodrigues_bloch(start_mag,b1_Hz,tp_ms,b0_offset_Hz);

%% Period of free precession



%% Calculate and plot the signals 

Mx=end_mag(:,1);
My=end_mag(:,2);
Mz=end_mag(:,3);
Mabs=sqrt(Mx.^2+My.^2);


figure(7901)
clf
subplot(3,1,1)
plot(b0_offset_Hz/b1_Hz,My)
title('M_y')
xlabel('\Omega / \omega_1')
subplot(3,1,2)
plot(b0_offset_Hz/b1_Hz,Mx)
title('M_x')
xlabel('\Omega / \omega_1')
subplot(3,1,3)
plot(b0_offset_Hz/b1_Hz,Mabs)
title('M_a_b_s')
xlabel('\Omega / \omega_1')

