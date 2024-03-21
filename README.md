# HIVE: Heating by Induction to Verify Extremes

_Karthikeyan Chockalingam and Nuno Nobre_ (equal contribution)

###

[HIVE](https://ccfe.ukaea.uk/divisions/fusion-technology/hive/), located at
UKAEA's Culham campus, is a testing rig designed to stress small prototype
cooled and un-cooled fusion reactor components under high induction heat fluxes
in a high vacuum environment.

This repository hosts a [MOOSE](https://mooseframework.org) application that
aims to replicate the rig's behaviour towards full digital twinning capability.

## Application design

For simulation purposes, we segment HIVE into three components: a cubic vacuum
chamber, an electromagnetic coil, and a target prototype component.
Both the coil and the target are assumed to be made of electrically conductive
materials.
Here we use copper for both, but other conductors would also work.

HIVE is, quite simply, an expensive induction hob, not unlike the one you might
have at home.
By applying a changing potential difference to the coil terminals, a changing
current flows through the coil, creating a changing magnetic field which, in
turn, induces a current in the target which gradually warms up via Joule
heating.

More specifically, this application leverages a linear, but time-dependent,
finite element formulation split into three sub-applications, each solving a
different equation, as follows:

1) Laplace's equation: $∇^2 V = 0$.

    Solved for the electric potential $V$, only on the coil and only once, with
    Dirichlet boundary conditions on both its terminals,
    $V_\mathrm{in} = 1\mathrm{V}$ and $V_\mathrm{out} = 0\mathrm{V}$, and
    Neumann boundary conditions on its $\mathbf{n}$-oriented lateral surface,
    $\mathbf{∇}V \cdot \mathbf{n} = 0$.
    This sole solution can then be scaled appropriately for any timestep if the
    time-dependent Dirichlet boundary condition is assumed uniform,
    i.e. $V_\mathrm{in,out}(\mathbf{r},t) \equiv V_\mathrm{in,out}(t)$.

2) The $\mathbf{A}$ formulation: $\mathbf{∇}× \left(ν \mathbf{∇}× \mathbf{A}\right) +σ \partial_t \mathbf{A} = -σ \mathbf{∇}V$

    Solved for the magnetic vector potential $\mathbf{A}$, everywhere in space
    and for each timestep, with Dirichlet boundary conditions on the 

3) The heat equation:

## Parameterisation


