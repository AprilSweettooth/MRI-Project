# build the class for rotation function
import matplotlib.pyplot as plt
import numpy as np
from utils import init_rotation_matrix, convert_to_S_basis, normalisation, plot_2D

class BlochSim:
    def __init__(self, M0):
        # define the parameter
        # all values except M0 set to default for now

        #     'RF'    [nT, nCha]  RF-trajectory [V]
        self.nT = int(np.floor(0.001/1e-5))
        self.totalRF = np.ones((self.nT, 1))
        self.tShape = self.totalRF.shape[0]
        #     'g'     [nT, 3]     Gradient trajectory [T/m]
        # nPoints = int(np.ceil(1e-3/dt))
        # g = 40* 1e-3 * np.ones((nPoints, 1))
        #     'dt'    [1]         Time step
        self.dt = 1e-5
        #     'df'    [1]         Off resonance frequency [Hz]
        self.df = 0
        #     'x'     [ny,nx,nz]  Meshgrid of x
        #     'y'     [ny,nx,nz]  Meshgrid of y
        #     'z'     [ny,nx,nz]  Meshgrid of z
        # x, y, z = 0, 0, 0
        #     'b1'    [ny,nx,nz,nCha] 
        self.b1 = 250 / (42.5e6)
        #     'M0'    [3,]        Initial magnetization
        self.M0 = M0
        #     'T1'    [1]         
        self.T1 = 10**20
        #     'T2'    [2]
        self.T2 = 10**20
        # R1 = 1/T1 
        # R2 = 1/T2
        self.gamma = 267 * 10**6 # rad s-1 T-1
        self.gammabar = self.gamma/(2*np.pi) # Hz T-1

    # # Quaternion based rotation following Pauli et al
    # Reference: Pauly (1991) https://dx.doi.org/10.1109/42.75611
    def rotation(self, end_only):
        # Initialise output
        finalMs = np.zeros((3,self.tShape),dtype=np.cdouble)

        # Convert M0 to the (S+, S-, Sz) basis
        M0Quat = convert_to_S_basis(self.M0)

        # Total accumulated quaternion rotation
        Q_tot = np.eye(2)
        
        # Loop over time points in the RF pulse
        for i in range(self.tShape):

            # Rotation vector for B1 and B0 per timestep
            B = np.array(
                [
                self.totalRF[i,0].real * self.b1,
                self.totalRF[i,0].imag * self.b1,
                self.df/self.gammabar
                ])
            
            # Magnitude of rotation in units of radians
            phi = -self.gamma * self.dt * (normalisation(B) + 1e-30)
            
            # Axis of rotations (unit vector)
            n = [ (self.gamma * self.dt / abs(phi)) * b for b in B ]
            
            # Quaternion terms for this rotation
            alpha = np.cos(phi/2) - 1j* n[2] * np.sin(phi/2)
            beta = (-1j * n[0] + n[1]) * np.sin(phi/2)

            # initialise Quaternion
            Q = np.array([ [alpha, -np.conj(beta)], [beta, np.conj(alpha)] ])

            # Compute total quaternion for all of pulse so far
            Q_tot = np.matmul(Q_tot, Q)
            
            # Convert to a rotation matrix
            alpha_tot = Q_tot[0][0]
            beta_tot = Q_tot[1][0]

            RotationMat = init_rotation_matrix(alpha_tot, beta_tot)
            
            # Compute magnetisation at this timestep
            finalMs[:,[i]] = np.matmul(RotationMat, M0Quat)
        
        if end_only:
            return finalMs[:,[-1]]
        else:
            return finalMs
    
    # plots
    # 2D
    def plot(self, view, data):
        if view == '2D':
            return plot_2D(data, True, True)

if __name__ == '__main__':
    # B = BlochSim(np.array([1,0,0]))
    # data = B.rotation(False)
    # B.plot('2D', data)
    B = BlochSim(np.array([0.7,0.5,0.5]))
    magnitisation = B.rotation(True)
    print(magnitisation)