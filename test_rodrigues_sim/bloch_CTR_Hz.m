%
%	Bloch simulator that works in units of Hz (to treat all nuclei equally).
%
%	[mx,my,mz] = bloch_CTR_Hz(b1,gr,tp,t1,t2,df,dp,mode,mx,my,mz,spoiled)
%
%	Bloch simulation of rotations due to B1, gradient and
%	off-resonance, including relaxation effects.  At each time
%	point, the rotation matrix and decay matrix are calculated.
%	Simulation can simulate the steady-state if the sequence
%	is applied repeatedly, or the magnetization starting at m0.
%
%	INPUT:
%		b1 = (Mx1) RF pulse in Hz.  Can be complex.
%		gr = (Mx1,2,or 3) 1,2 or 3-dimensional gradient in Hz/cm.
%		tp = (Mx1) time duration of each b1 and gr point, in seconds,
%				or 1x1 time step if constant for all points
%				or monotonically INCREASING endtime of each
%				interval..
%		t1 = T1 relaxation time in seconds.
%		t2 = T2 relaxation time in seconds.
%		df = (Nx1) Array of off-resonance frequencies (Hz)
%		dp = (Px1,2,or 3) Array of spatial positions (cm).  
%			Width should match width of gr.
%		mode= Bitmask mode:
%			Bit 0:  0-Simulate from start or M0, 1-Steady State
%			Bit 1:  1-Record m at time points.  0-just end time.
%
%	(optional)
%		mx,my,mz (PxN) arrays of starting magnetization, where N
%			is the number of frequencies and P is the number
%			of spatial positions.
%       spoiled = (Mx1) Logical arra, which simulates the effect of spoiler
%                 gradients (Mx,My = 0) before the simulation of the current 
%                 timestep.
%
%	OUTPUT:
%		mx,my,mz = PxN arrays of the resulting magnetization
%				components at each position and frequency.
%
%	B. Hargreaves.	Nov 2003. (Downloaded in Feb 2013.)
%   M. Robson. REVERSED SIGN OF GYROMAGNETIC RATIO.
%   C. Rodgers.   Feb 2013. Add flag to control verbosity.
%                 Don't crash Matlab if called with insufficient parameters.
%                 SWAPPED SIGN OF GAMMA to match updated code on web.
%                 Jun 2013. Convert from G --> Hz units.
%   W. Clarke.    Add support for perfect simulated spoiling.
%
% SIGN convention. See M. Levitt. "Basics of Nuclear Magnetic Resonance". Page 250.
% An 90-x pulse (i.e. RF with 0 phase) moves spins from the x-axis to the
% MINUS y-axis. i.e. x --> -y.
% 
% The updated code here adheres to that convention.
%
function varargout = bloch_CTR_Hz(varargin)
warning('This code is a MEX file that must be compiled before use. Attempting to do that now...');

oldDir = pwd();
c = onCleanup(@() cd(oldDir));

try
    myDir = fileparts(mfilename('fullpath'));
    myFunc = mfilename();
    
    cd(myDir)
    res = mex(sprintf('%s.c',myFunc))
    
    if res ~= 0
        error('Error automatically compiling MEX. Must be done by hand.')
    end
catch ME
    error('Error automatically compiling MEX. Must be done by hand.')
end

clear c % Return to previous folder

rehash

warning('Compilation done. Continuing...')

myHandle = str2func(myFunc);
[varargout{1:nargout}] = myHandle(varargin{:});
