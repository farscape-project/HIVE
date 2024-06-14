#include "JouleHeatingAux.h"

registerMooseObject("hiveApp", JouleHeatingAux);

InputParameters
JouleHeatingAux::validParams()
{
  InputParameters params = AuxKernel::validParams();
  params.addClassDescription(
      "Computes the differential form of the Joule heating equation (power per unit volume).");
  params.addCoupledVar("vector_potential", "The vector potential variable");
  params.addParam<Real>("sigma", 1, "The electrical conductivity");
  return params;
}

JouleHeatingAux::JouleHeatingAux(const InputParameters & parameters)
  : AuxKernel(parameters),
    _electric_field(coupledVectorDot("vector_potential")),
    _sigma(getParam<Real>("sigma"))
{
}

Real
JouleHeatingAux::computeValue()
{
  return _sigma * _electric_field[_qp] * _electric_field[_qp];
}
