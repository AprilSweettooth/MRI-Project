
function [seqTiming] = sim_90_180hard

seqTiming = T2_blochSim_addEmpty();

% hard 1ms 90 pulse for excitation
 thisStart = 0;
       
seqTiming.tp_s     (1,end+1:end+4) = [thisStart thisStart+1e-9 thisStart+1e-3 thisStart+1e-3+1e-9];
seqTiming.b1_Hz     (1,end+1:end+4) = [0 250 250 0];
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
    


%% 1st refocusing

thisStart = 100e-3;
%         
seqTiming.tp_s    (1,end+1:end+4) = [thisStart thisStart+1e-9 thisStart+1e-3 thisStart+1e-3+1e-9];
seqTiming.b1_Hz     (1,end+1:end+4) = [0 500 500 0];
seqTiming.grad   (1,end+1:end+4) = [0 0 0 0];
seqTiming.spoil  (1,end+1:end+4) = false;
seqTiming.readout(1,end+1:end+4) = false;


% 1st Echo


thisStart = 200e-3;
        
seqTiming.tp_s(1,end+1:end+1) = thisStart;
seqTiming.b1_Hz(1,end+1:end+1) = 0;
seqTiming.grad(1,end+1) = 0;
seqTiming.spoil(1,end+1) = false;
seqTiming.readout(1,end+1) = true;
    
 
    
%Turn off all sp    
seqTiming.spoil(:) = 0;

   

seqTiming = T2_blochSim__fillGaps('out',seqTiming,'maxGap',1e-6); 


end 

