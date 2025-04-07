# HIVE: Heating by Induction to Verify Extremes

_Nuno Nobre and Karthikeyan Chockalingam_

###

[HIVE](https://ccfe.ukaea.uk/divisions/fusion-technology/hive/), located at
UKAEA's Culham campus, is a testing rig designed to stress small prototype
cooled and un-cooled fusion reactor components under high induction heat fluxes
in a high vacuum environment.

![HIVE at 100kHz: 100 time steps of 0.1us](img/demo.gif)

This repository hosts a [MOOSE](https://mooseframework.org) app that
aims to replicate the rig's behavior towards full digital twinning capability.

## Getting started

Installation is as usual for any MOOSE app:

1) Install MOOSE using
   [the installation method of your choice](https://mooseframework.org/getting_started/installation).

2) Clone this repo alongside MOOSE, 
   `git clone https://github.com/farscape-project/HIVE.git`.

3) Build the app with a no. of `jobs` of your choice,
   `cd HIVE && make [-j [jobs]]`.

4) Run it with a no. of `processes` of your choice,
   `mpirun [-n processes] ./hive-opt -w -i input/THeat.i`.

## A brief conceptual introduction

For simulation purposes, we discretize HIVE using a tetrahedral [mesh](mesh/)
and segment it into three components: a cuboid vacuum chamber, an
electromagnetic coil, and a target prototype component.
Both the coil and the target sit within the vacuum chamber and are assumed to
be made of electrically conductive materials.
Here we use copper for the coil and 316L stainless steel for the target, but
other conductors can also be used.

HIVE is, quite simply, an expensive induction hob, not unlike the one you might
have at home.
By applying a time-varying electric potential difference to the coil terminals,
a time-varying electric current flows through the coil, creating a time-varying
magnetic field which induces a time-varying electric current in the target
that gradually warms up via Joule heating.

Recall that the time-varying electric current flowing through the target will
self-induce a current, causing the (net) current to flow mostly along the outer
perimeter, or skin, of the target. This is known as the skin effect and is more
pronounced the higher the frequency. Furthermore, since induced currents lag
their sources by one-quarter cycle, i.e. $\pi/2$, the resulting current on the
target will, with increasing frequency, tend to lag the current on the coil by
one-half cycle, i.e. $\pi$.

## App design

This app leverages a linear, but time-dependent, finite element formulation
split into three sub-apps. Each sub-app solves a different equation for a
different field, and feeds the solution to the next sub-app. This one-way
coupling pipeline proceeds as follows:

1) Laplace's equation: $∇^2 V = 0$.
   See [input/VLaplace.i](https://github.com/farscape-project/HIVE/blob/main/input/VLaplace.i).

    Solved for the electric potential $V \in \mathcal{P}^1$
    [<sup>(*)</sup>](https://defelement.com/elements/examples/tetrahedron-lagrange-equispaced-1.html),
    only on the coil and only once, with Dirichlet boundary conditions on both
    its terminals, $V_\mathrm{in} = V_\mathrm{max}$ and
    $V_\mathrm{out} = 0$, and Neumann boundary conditions on its
    $\mathbf{n}$-oriented lateral surface, $\mathbf{∇}V \cdot \mathbf{n} = 0$.
    This sole solution can then be scaled appropriately for any time step if
    the time-dependent Dirichlet boundary condition is assumed uniform, i.e.
    $V_\mathrm{in}(\mathbf{r},t) \equiv V_\mathrm{in}(t)$. Here, we take
    $V_\mathrm{in}(t)=V_\mathrm{max}\mathrm{sin}(\omega t)$ for some angular
    frequency $\omega$.

2) The $\mathbf{A}$ formulation: $\mathbf{∇}× \left(ν \mathbf{∇}× \mathbf{A}\right) +σ \partial_t \mathbf{A} = -σ \mathbf{∇}V$.
   See [input/AForm.i](https://github.com/farscape-project/HIVE/blob/main/input/AForm.i).

    Solved for the magnetic vector potential $\mathbf{A} \in \mathcal{N}^0_I$
    [<sup>(*)</sup>](https://defelement.com/elements/examples/tetrahedron-nedelec1-lagrange-0.html),
    everywhere in space and for each time step, with Dirichlet boundary
    conditions on the $\mathbf{n}$-oriented plane boundary of the vacuum
    chamber where the coil terminals sit, $\mathbf{A} × \mathbf{n} = 0$, and
    Neumann boundary conditions on its remaining $\mathbf{n}$-oriented outer
    surfaces, $\mathbf{∇} × \mathbf{A} × \mathbf{n} = 0$.
    $ν$ is the magnetic reluctivity (the reciprocal of the magnetic
    permeability) and $σ$ is the electrical conductivity.
    The right-hand side is non-zero only within the coil, see (1), and is
    simply the current flowing through it.

3) The heat equation: $ρc \partial_t T - \mathbf{∇} \cdot (k \mathbf{∇}T) = σ ||\partial_t \mathbf{A}||^2$.
   See [input/THeat.i](https://github.com/farscape-project/HIVE/blob/main/input/THeat.i).

   Solved for the temperature $T \in \mathcal{P}^1$
   [<sup>(*)</sup>](https://defelement.com/elements/examples/tetrahedron-lagrange-equispaced-1.html),
   everywhere in space and for each time step, with Neumann boundary conditions
   on the $\mathbf{n}$-oriented outer surface of the vacuum chamber,
   $\mathbf{∇}T \cdot \mathbf{n} = 0$, and initial conditions everywhere in
   space, $T = T_\mathrm{room}$.
   $ρ$ is the density, $c$ is the specific heat capacity, and $k$ is the
   thermal conductivity.
   The right-hand side is the Joule heating term which, as of this writing, we
   compute only on the target.

See [input/Parameters.i](input/Parameters.i) for the set of parameters
influencing the simulation.
This file is included at the top of the input files for each of the three
sub-apps, [input/VLaplace.i](input/VLaplace.i), [input/AForm.i](input/AForm.i)
and [input/THeat.i](input/THeat.i).
Since none uses the entire parameter set, MOOSE issues a few warnings that
can be safely ignored (thus the need for the `-w` flag above).
All material properties are assumed uniform within each of the three components
and, as of this writing, also temperature-independent.

## Next steps

This app is under active development and is being updated frequently.
We are currently looking to improve its capability when it comes to solution
accuracy, time-to-solution and general usability.

### Solution accuracy

* Add two-way coupling between the heat equation and $\mathbf{A}$ formulation
  sub-apps so the material properties influencing the latter can be made
  temperature-dependent.

* Flow a coolant through the target's cooling pipe.

* Add support to MOOSE (+libMesh) for $\mathcal{N}^1_I$ variables on TET14s.

### Time-to-solution

* Switch to a time-averaged Joule heating source in the heat equation sub-app
  to keep the problem tractable when simulating over a long physical time span.
  The $\mathbf{A}$ formulation sub-app will then sub-cycle, i.e. perform
  multiple time steps for each time step of the heat equation sub-app.

* Study the potential gains of solving all, but most importantly the
  $\mathbf{A}$ formulation sub-app, on the GPU simply via PETSc/hypre flags.

* Add support to MOOSE for the hypre AMS preconditioner. This would allow the
  $\mathbf{A}$ formulation sub-app to drop LU, which is relatively slow, as its
  preconditioner.

* Add support to MOOSE to impose strong boundary conditions for
  $H(\mathrm{curl})$-conforming variables. This would allow the $\mathbf{A}$
  formulation sub-app to drop the penalty-method boundary conditions it
  currently uses.

### Usability

* Create a GUI for use by the people operating HIVE and looking to conduct
  virtual testing and qualification to understand operational ranges, plan
  experiments and quantify uncertainties.
