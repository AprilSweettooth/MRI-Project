function [end_mag] = rodrigues_bloch(start_mag,b1_Hz,tp_ms,b0_offset_Hz,b1_phase)
% Apply a rectangular pulse on spins on Bloch sphere without relaxation.

% start_mag is the starting magnetisation vector [mx my mz].
% b1_Hz B1(Hz) of the rectangular pulse
% b0_offset_Hz B0 offset frequency range (in Hz) 
% tp_ms length (in ms) of the rectangular pulse
% gamma_Hz_per_uT Gamma of the nuclues being simulated in Hz_per_uT 

% end_mag is the end magnetisation vector for all input b0_offset.

% Check size of inputs
if numel(size(start_mag))~=2 || size(start_mag,2)~=3, error('start_mag must be a B0 points x (Mx,My,Mz) matrix.'), end
if numel(size(b0_offset_Hz))~=2 || size(b0_offset_Hz,2)~=1 || size(b0_offset_Hz,1)~=size(start_mag,1), error('b0_offset must be a B0 points x 1 matrix.'), end

% Rotation that would be due to B1 alone (in radians):
B1_radians = b1_Hz * (tp_ms/1000) *2*pi; 
% Rotation that would be due to B0 alone (in radians):
DeltaB_radians = b0_offset_Hz * (tp_ms/1000) *2*pi;
% Rotation from effective B0 and B1 field (in radians):
Beff_radians = sqrt((DeltaB_radians.^2) + (B1_radians.^2));

rotationAxis=zeros(size(b0_offset_Hz,1),3);
end_mag=zeros(size(b0_offset_Hz,1),3);

for idx=1:size(b0_offset_Hz,1)
rotationAxis(idx,:)= [ B1_radians*cos(b1_phase) B1_radians*sin(b1_phase) DeltaB_radians(idx,1) ];
end_mag(idx,:)= rodrigues_rot(start_mag(idx,:), rotationAxis(idx,:), Beff_radians(idx,1));
end
