# FGrn_simulink
Simulink Library for the learning and inference using Factor Graph in Reduced Normal Form paradigm. 

---

Remember to add directory LibFactorGraph to the MATLAB path.

A tutorial is present in the <code>Tutorial/Example1.m</code>

The data observed (training set) are injected in the network (designed using Simulink and the objects present in <code>LibFactorGraph/LibFactorGraph.mdl</code> and the conditional probability tables (CPTs) are learned and printed on screen at the end of Learning process.

Using the learned CPTs and particular values for three variables (*A*, *S*, *C*) injected in the network as forward messages for *A* and *S* (<code>fA</code>, <code>fS</code>) and as backward message for *C* (<code>bC</code>), we obtain, after the belief propagation, the inference (<code>bA</code>, <code>bS</code>, <code>fC</code>).

---

If you use this library, please cite the paper https://link.springer.com/chapter/10.1007/978-3-319-18164-6_2

Buonanno, A., Palmieri, F.A.N. (2015). Simulink Implementation of Belief Propagation in Normal Factor Graphs. In: Bassis, S., Esposito, A., Morabito, F. (eds) Advances in Neural Networks: Computational and Theoretical Issues. Smart Innovation, Systems and Technologies, vol 37. Springer, Cham. https://doi.org/10.1007/978-3-319-18164-6_2

----


