import nef
import timeview.funcrep
from java.lang.Math import random
from ca.nengo.math.impl import PiecewiseConstantFunction

###################
# File IO
###################

def readCSV(filename):
    # please change this line accordingly:
    filename = 'C:\\Users\\y227wu\\Documents\\My Dropbox\\research\\pubModel\\' + filename
    data = []
    for line in file(filename).readlines():
        row = [float(x) for x in line.strip().split(',')]
        data.append(row)
    return data

directions = readCSV('directions.csv')
transMatX = array(readCSV('transMatX.csv'))
transMatY = array(readCSV('transMatY.csv'))
freqX = array(readCSV('freqX.csv'))
freqY = array(readCSV('freqY.csv'))
# gauss = readCSV('gauss.csv')
samples = readCSV('samples.csv')

###################
# Initialization
###################
tau = 0.005
deltaT = 0.0001
population_size = 1600;
glength = len(transMatX) + 1 # number of dimensions that represent gaussian
Imat = eye(glength-1)
initial_input = [random()*2-1 for dummy in range(glength)]
zero = zeros(glength)

###################
# Path-integrator
###################

net = nef.Network('Path_Integrator')
place_input = net.make_input('place_input',zero)
place_input.functions=[PiecewiseConstantFunction([0.005],[initial_input[d],zero[d]]) for d in range(len(initial_input))]
control = net.make_input('control',[0,0])
PI = net.make('PI',population_size,glength + 2, radius = 1, encoders = directions, eval_points = samples, quick = True)

net.connect(place_input, PI, weight = tau * 20, pstc = tau, transform = concatenate([eye(glength), zeros([2, glength])],0))
net.connect(control, PI, pstc = tau, transform = concatenate([zeros([glength, 2]), eye(2)],0))

# rotation in the fourier space is shift in the original 2D space
def rotate(x):
    # return x[0:25]
    x=transpose(array([x])) #first convert to 2D matrix
    Anef = [tau/deltaT] * ((transMatX - Imat) * x[glength] + (transMatY - Imat) * x[glength + 1]) + Imat
    x[1:glength] = dot(Anef,x[1:glength,])
    return transpose(x[0:glength])[0]
    
# feedback transformation
trans = concatenate([eye(glength), zeros([2, glength],'f')],0)    
net.connect(PI, PI, pstc = tau, func = rotate, transform = trans)

###################
# Display
###################

net.add_to(world)

def basisFunc(x, freqs):
    const = ones([1,len(x[0])])
    basis = zeros([glength-1, len(x[0])],'f') # the first (constant) basis is not included
    empty = zeros([2, len(x[0])],'f')
    
    X = array(x[0])
    Y = array(x[1])
    for i in range(glength-1):
        iFreq = i/2 + 1  # the first index points to the constant term
        if i % 2 == 0:
            basis[i] = cos(X*2*pi*freqs[iFreq, 0] + Y*2*pi*freqs[iFreq, 1])
        else:
            basis[i] = sin(X*2*pi*freqs[iFreq, 0] + Y*2*pi*freqs[iFreq, 1])
    # return concatenate([const, basis], 0)    
    return concatenate([const, basis, empty], 0)
    
timeview.funcrep.define(PI,basisFunc,2, params = concatenate([freqX, freqY],1), time_step = 20)

"""
code for reload a Gaussian:

gauss = readCSV('gauss.csv')
place_input.functions=[PiecewiseConstantFunction([0.1],[gauss[0][d],zero[d]]) for d in range(len(initial_input))]
"""
