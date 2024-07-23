#include "TimeAveragedJouleHeatingAux.h"

registerMooseObject("hiveApp", TimeAveragedJouleHeatingAux);

InputParameters
TimeAveragedJouleHeatingAux::validParams()
{
  InputParameters params = AuxKernel::validParams();
  params.addClassDescription(
      "Computes the time-average of the differential form of the Joule heating "
      "equation (power per unit volume).");
  params.addRequiredCoupledVar(
      "power_prev", 
      "AuxVariable containing sum of power outputs from previous steps.");
  params.addCoupledVar("vector_potential", "The vector potential variable");
  params.addParam<Real>("sigma", 1, "The electrical conductivity");
  return params;
}

TimeAveragedJouleHeatingAux::TimeAveragedJouleHeatingAux(const InputParameters & parameters)
  : AuxKernel(parameters),
    _power_prev(coupledValue("power_prev")),
    _electric_field(coupledVectorDot("vector_potential")),
    _sigma(getParam<Real>("sigma"))
{
}

Real
TimeAveragedJouleHeatingAux::computeValue()
{
  Real beta = _dt / _t;
  return (1 - beta)* _power_prev[_qp] + (beta * _sigma * _electric_field[_qp] * _electric_field[_qp]);
}
