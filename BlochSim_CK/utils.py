import numpy as np
import matplotlib.pyplot as plt

# helper function for matrix rotation
def init_rotation_matrix(quaternion_a, quaternion_b):
    return np.array(
    [
        [np.conjugate(quaternion_a)**2, -quaternion_b**2, 2*np.conjugate(quaternion_a)*quaternion_b],
        [-(np.conjugate(quaternion_b)**2), quaternion_a**2, 2*quaternion_a*np.conjugate(quaternion_b)],
        [-np.conjugate(quaternion_a)*np.conjugate(quaternion_b), -quaternion_a*quaternion_b, quaternion_a*np.conjugate(quaternion_a)-quaternion_b*np.conjugate(quaternion_b)]
    ]
    )

# convert magnitisation to Spin basis
def convert_to_S_basis(M0):
    assert M0.shape[0] == 3, "Invalid Dimension"
    return np.array([[M0[0]+1j*M0[1], M0[0]-1j*M0[1], M0[2]]]).T 

# implement normalisation for unit sphere
def normalisation(vector):
    norm = np.sqrt(sum([element**2 for element in vector]))
    return norm

# plot 2D projection view
def plot_2D(data, timesteps, axis):
    if timesteps:
        fig, axs = plt.subplots(3,1, figsize=(10, 12))
        axs[0].plot(data[0,:].real)
        axs[0].set_xlabel('time steps')
        axs[0].set_ylabel('Mx')

        axs[1].plot(data[0,:].imag)
        axs[1].set_xlabel('time steps')
        axs[1].set_ylabel('My')

        axs[2].plot(data[2,:].real)
        axs[2].set_xlabel('time steps')
        axs[2].set_ylabel('Mz')

        plt.show()

    # Now make a plot viewing along x,y,z axis
    if axis:
        fig, axs = plt.subplots(3,1, figsize=(20, 6))
        axs[0].plot(data[0,:].imag,data[2,:].real)
        axs[0].set_xlabel('My')
        axs[0].set_ylabel('Mz')
        axs[0].set_aspect('equal')

        axs[1].plot(data[0,:].real,data[2,:].real)
        axs[1].set_xlabel('Mx')
        axs[1].set_ylabel('Mz')
        axs[1].set_aspect('equal')

        axs[2].plot(data[0,:].imag,data[0,:].real)
        axs[2].set_xlabel('My')
        axs[2].set_ylabel('Mx')
        axs[2].set_aspect('equal')

        plt.show()
