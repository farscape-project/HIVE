#include "JouleHeatingAux.h"

registerMooseObject("hiveApp", JouleHeatingAux);

InputParameters
JouleHeatingAux::validParams()
{
  InputParameters params = AuxKernel::validParams();
  params.addClassDescription("Computes (optionally, the time average of) the differential form of "
                             "the Joule heating equation (power per unit volume).");
  params.addCoupledVar("vector_potential", "The vector potential variable");
  params.addParam<Real>("sigma", 1, "The electrical conductivity");
  params.addParam<bool>("average", true, "Whether to take the time average");
  return params;
}

JouleHeatingAux::JouleHeatingAux(const InputParameters & parameters)
  : AuxKernel(parameters),
    _electric_field(coupledVectorDot("vector_potential")),
    _sigma(getParam<Real>("sigma")),
    _avg(getParam<bool>("average"))
{
}

Real
JouleHeatingAux::computeValue()
{
  Real beta = _avg ? _dt / _t : 1;
  return (1 - beta) * _u[_qp] + (beta * _sigma * _electric_field[_qp] * _electric_field[_qp]);
}
