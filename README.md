Neural path integrator
======================

Cells in several areas of the hippocampal formation show place specific
firing patterns, and are thought to form a distributed representation
of an animal’s current location in an environment. Experimental
results suggest that this representation is continually updated even
in complete darkness, indicating the presence of a path integration
mechanism in the rat. Adopting the Neural Engineering Framework (NEF)
presented by Eliasmith and Anderson (2003) we derive a novel attractor
network model of path integration, using heterogeneous spiking
neurons. The network we derive incorporates representation and
updating of position into a single layer of neurons, eliminating the
need for a large external control population, and without making use
of multiplicative synapses. An efﬁcient and biologically plausible
control mechanism results directly from applying the principles of the
NEF. We simulate the network for a variety of inputs, analyze its
performance, and give three testable predictions of our model.

## Instructions

1. Run `makeData.m` in Matlab to generate data files needed.
2. Modify line 12 of `path_integrator.py` file, pointing it to the
   folder containing data files generated in the previous step.
3. Load `path_integrator.py` in Nengo and run.
4. In the simulation window (open by right-clicking "Path-Integrator"
   -> "run Interactive Plot"), right-click "PI"->"function" to open
   the function representation view. Then click the play button at the
   right bottom. Right-click "control"->"control" to the adjust input
   along two axis.

Note: an error may occur at the line 20 of `makeData.m` in old
versions of MATLAB or Octave. Please try to substitute the tildes in
line 20 with other variable names (e.g. "var1", "var2").
