from typing import final
from numpy import asarray
import matplotlib.pyplot as plt
import numpy as np

# convert the function into class object
# add unit test for the blochsim function


# define the dataset
# all values except M0 set to default for now
# blochSim_CK(RF, g, dt, df, x,y,z, b1, M0, T1, T2)
#     'RF'    [nT, nCha]  RF-trajectory [V]
#     'g'     [nT, 3]     Gradient trajectory [T/m]
#     'dt'    [1]         Time step
#     'df'    [1]         Off resonance frequency [Hz]
#     'x'     [ny,nx,nz]  Meshgrid of x
#     'y'     [ny,nx,nz]  Meshgrid of y
#     'z'     [ny,nx,nz]  Meshgrid of z
#     'b1'    [ny,nx,nz,nCha] 
#     'M0'    [3,]        Initial magnetization
#     'T1'    [1]         
#     'T2'    [2]
dt = 1e-5
# nPoints = int(np.ceil(1e-3/dt))
# RF = 1 * np.ones((nPoints, 1))
# g = 40* 1e-3 * np.ones((nPoints, 1))

df = 0
b1 = 250 / (42.5e6)
M0 = [0, 0, 1]
T1 = 10**20
T2 = 10**20

nT = int(np.floor(0.001/1e-5))
totalRF = np.ones((nT, 1))

gamma = 267 * 10**6 # rad s-1 T-1
gammabar = gamma/(2*np.pi) # Hz T-1
R1 = 1/T1 
R2 = 1/T2

# blockSim function for single data point
# Quaternion based rotation following Pauli et al
# Reference: Pauly (1991) https://dx.doi.org/10.1109/42.75611
#
def blochSim_CK_iteration(totalRF, dt, df, b1, M0, T1, T2, end_only):
  finalMs = np.zeros((3,totalRF.shape[0]),dtype=np.cdouble) # Initialise output
  
  # Convert M0 to the (S+, S-, Sz) basis
  M0Quat = np.array([[M0[0]+1j*M0[1], M0[0]-1j*M0[1], M0[2]]]).T

  # Total accumulated quaternion rotation
  Q_tot = np.eye(2)
  
  # Loop over time points in the RF pulse
  for i in range(totalRF.shape[0]):

    # Rotation vector for B1 and B0 per timestep
    B = np.array([totalRF[i,0].real * b1,
                  totalRF[i,0].imag * b1,
                  df/gammabar])
      
    # Magnitude of rotation in units of radians
    phi = -gamma * dt * (np.linalg.norm(B) + 1e-30)
      
    # Axis of rotations (unit vector)
    n = [ (gamma * dt / abs(phi)) * b for b in B ]
      
    # Quaternion terms for this rotation
    alpha = np.cos(phi/2) - 1j* n[2] * np.sin(phi/2)
    beta = (-1j * n[0] + n[1]) * np.sin(phi/2)
  
    Q = np.array([ [alpha, -np.conj(beta)], [beta, np.conj(alpha)] ])

    # Compute total quaternion for all of pulse so far
    Q_tot = np.matmul(Q_tot, Q)
    
    # Convert to a rotation matrix
    alpha_tot = Q_tot[0][0]
    beta_tot = Q_tot[1][0]
    RotationMat = np.array([[np.conjugate(alpha_tot)**2, -beta_tot**2, 2*np.conjugate(alpha_tot)*beta_tot],
        [-(np.conjugate(beta_tot)**2), alpha_tot**2, 2*alpha_tot*np.conjugate(beta_tot)],
        [-np.conjugate(alpha_tot)*np.conjugate(beta_tot), -alpha_tot*beta_tot, alpha_tot*np.conjugate(alpha_tot)-beta_tot*np.conjugate(beta_tot)]])
    
    # Compute magnetisation at this timestep
    #print(Q_tot.shape)
    #print(RotationMat.shape)
    #print(M0Quat.shape)
    finalMs[:,[i]] = np.matmul(RotationMat, M0Quat)
    
  if end_only:
    return finalMs[:,[-1]]
  else:
    return finalMs


## Test 1. single output blochsim function, 90deg x rot, starting along z
finalMs = blochSim_CK_iteration(totalRF, dt, df, b1, [0, 0, 1], T1, T2, False)

fig, axs = plt.subplots(3,1)
axs[0].plot(finalMs[0,:].real)
axs[0].set_xlabel('time steps')
axs[0].set_ylabel('Mx')

axs[1].plot(finalMs[0,:].imag)
axs[1].set_xlabel('time steps')
axs[1].set_ylabel('My')

axs[2].plot(finalMs[2,:])
axs[2].set_xlabel('time steps')
axs[2].set_ylabel('Mz')

## Now make a plot viewing along x axis
fig, axs = plt.subplots(1,1)
axs.plot(finalMs[0,:].imag,finalMs[2,:].real)
axs.set_xlabel('My')
axs.set_ylabel('Mz')
axs.set_aspect('equal')




## Test 2. single output blochsim function, 90deg x rot, starting along x
finalMs = blochSim_CK_iteration(totalRF, dt, df, b1, [1, 0, 0], T1, T2, False)

fig, axs = plt.subplots(3,1)
axs[0].plot(finalMs[0,:].real)
axs[0].set_xlabel('time steps')
axs[0].set_ylabel('Mx')

axs[1].plot(finalMs[0,:].imag)
axs[1].set_xlabel('time steps')
axs[1].set_ylabel('My')

axs[2].plot(finalMs[2,:])
axs[2].set_xlabel('time steps')
axs[2].set_ylabel('Mz')

## Now make a plot viewing along x axis
fig, axs = plt.subplots(1,1)
axs.plot(finalMs[0,:].imag,finalMs[2,:].real)
axs.set_xlabel('My')
axs.set_ylabel('Mz')
axs.set_aspect('equal')




## Test 3. single output blochsim function, 90deg x rot, starting along y
finalMs = blochSim_CK_iteration(totalRF, dt, df, b1, [0, 1, 0], T1, T2, False)

fig, axs = plt.subplots(3,1)
axs[0].plot(finalMs[0,:].real)
axs[0].set_xlabel('time steps')
axs[0].set_ylabel('Mx')

axs[1].plot(finalMs[0,:].imag)
axs[1].set_xlabel('time steps')
axs[1].set_ylabel('My')

axs[2].plot(finalMs[2,:])
axs[2].set_xlabel('time steps')
axs[2].set_ylabel('Mz')

# Now make a plot viewing along x axis
fig, axs = plt.subplots(1,1)
axs.plot(finalMs[0,:].imag,finalMs[2,:].real)
axs.set_xlabel('My')
axs.set_ylabel('Mz')
axs.set_aspect('equal')




## Test 4. single output blochsim function, 90deg x rot, starting along y at 50% mag
finalMs = blochSim_CK_iteration(totalRF, dt, df, b1, [0, 0.5, 0], T1, T2, False)

fig, axs = plt.subplots(3,1)
axs[0].plot(finalMs[0,:].real)
axs[0].set_xlabel('time steps')
axs[0].set_ylabel('Mx')

axs[1].plot(finalMs[0,:].imag)
axs[1].set_xlabel('time steps')
axs[1].set_ylabel('My')

axs[2].plot(finalMs[2,:])
axs[2].set_xlabel('time steps')
axs[2].set_ylabel('Mz')

# Now make a plot viewing along x axis
fig, axs = plt.subplots(1,1)
axs.plot(finalMs[0,:].imag,finalMs[2,:].real)
axs.set_xlabel('My')
axs.set_ylabel('Mz')
axs.set_aspect('equal')


## Test 5. single output blochsim function, 90deg x rot
finalMs = blochSim_CK_iteration(totalRF, dt, df, b1, [0, 0.5, 0.5], T1, T2, False)

fig, axs = plt.subplots(3,1)
axs[0].plot(finalMs[0,:].real)
axs[0].set_xlabel('time steps')
axs[0].set_ylabel('Mx')

axs[1].plot(finalMs[0,:].imag)
axs[1].set_xlabel('time steps')
axs[1].set_ylabel('My')

axs[2].plot(finalMs[2,:])
axs[2].set_xlabel('time steps')
axs[2].set_ylabel('Mz')

# Now make a plot viewing along x axis
fig, axs = plt.subplots(1,1)
axs.plot(finalMs[0,:].imag,finalMs[2,:].real)
axs.set_xlabel('My')
axs.set_ylabel('Mz')
axs.set_aspect('equal')

