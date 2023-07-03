%% Sequence timing for 90 degree rectangular pulse 
% $Id$

function [seqTiming] = sim_90excitation

seqTiming = T2_blochSim_addEmpty();

% hard 0.5ms 90 pulse for excitation
thisStart = 0;
       
seqTiming.tp_s    (1,end+1:end+4) = [thisStart thisStart+1e-9 thisStart+(1e-3)/2 thisStart+(1e-3)/2+1e-9];
seqTiming.b1_Hz    (1,end+1:end+4) = [0 500 500 0];
seqTiming.grad   (1,end+1:end+4) = [0 0 0 0];
seqTiming.spoil  (1,end+1:end+4) = false;
seqTiming.readout(1,end+1:end+4) = false;


% FID readout 
thisStart = 1e-3+2e-9;       
seqTiming.tp_s(1,end+1:end+1) = thisStart;
seqTiming.b1_Hz(1,end+1:end+1) = 0;
seqTiming.grad(1,end+1) = 0;
seqTiming.spoil(1,end+1) = false;
seqTiming.readout(1,end+1) = true;
    
seqTiming.spoil(:) = 0;     
seqTiming = T2_blochSim__fillGaps('out',seqTiming,'maxGap',1e-5); 


end 

