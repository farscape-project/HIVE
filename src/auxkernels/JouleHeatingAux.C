#include "JouleHeatingAux.h"

registerMooseObject("hiveApp", JouleHeatingAux);

InputParameters
JouleHeatingAux::validParams()
{
  InputParameters params = AuxKernel::validParams();
  params.addClassDescription("Computes (optionally, the time average of) the differential form of "
                             "the Joule heating equation (power per unit volume). "
                             "The user may specify a time interval only after which the kernel "
                             "starts computing. If computing the time average, the right endpoint "
                             "rectangle rule is used for integration.");
  params.addCoupledVar("vector_potential", "The vector potential variable");
  params.addParam<Real>("sigma", 1, "The electrical conductivity");
  params.addParam<Real>("skip", 0, "Time interval after which the kernel starts computing");
  params.addParam<bool>("average", true, "Whether to take the time average");
  return params;
}

JouleHeatingAux::JouleHeatingAux(const InputParameters & parameters)
  : AuxKernel(parameters),
    _electric_field(coupledVectorDot("vector_potential")),
    _sigma(getParam<Real>("sigma")),
    _skip(getParam<Real>("skip")),
    _avg(getParam<bool>("average"))
{
}

Real
JouleHeatingAux::computeValue()
{
  Real p = _sigma * _electric_field[_qp] * _electric_field[_qp];
  Real w = _t > _skip ? _avg ? _dt / (_t - _skip) : 1 : 0;
  return (1 - w) * _u[_qp] + w * p;
}
