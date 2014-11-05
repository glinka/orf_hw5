import numpy as np
import matplotlib.pyplot as plt

def newton_fractal():
    spacing = 0.005
    b = 1.5
    xmesh, ymesh = np.meshgrid(np.arange(-b, b, spacing), np.arange(-b, b, spacing))
    n = xmesh.shape[0]
    z = 1j
    x = xmesh + z*ymesh
    f = lambda x: np.power(x, 3) - 1
    fprime = lambda x: 3*np.power(x, 2)
    iters = 0
    maxiter = 1000
    err = 1
    tol = 1e-5
    while err > tol and iters < maxiter:
        dx = -f(x)/fprime(x)
        x += dx
        err = np.linalg.norm(np.abs(dx))
        iters += 1
    print 'exited with error', err
    fig = plt.figure()
    ax = fig.add_subplot(111)
    ax.scatter(xmesh, ymesh, c=np.real(x)*np.imag(x), lw=0, s=2, cmap='autumn')
    ax.set_xlim((-b,b))
    ax.set_ylim((-b,b))
    plt.show()

if __name__=='__main__':
    newton_fractal()
