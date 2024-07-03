#include "CoefVectorTimeDerivative.h"

registerMooseObject("MooseApp", CoefVectorTimeDerivative);

InputParameters
CoefVectorTimeDerivative::validParams()
{
  InputParameters params = VectorTimeDerivative::validParams();
  params.addParam<Real>("coeff", 1, "The coefficient for the time derivative kernel");
  return params;
}

CoefVectorTimeDerivative::CoefVectorTimeDerivative(const InputParameters & parameters)
  : VectorTimeDerivative(parameters), _coeff(getParam<Real>("coeff"))
{
}

Real
CoefVectorTimeDerivative::computeQpResidual()
{
  return _coeff * VectorTimeDerivative::computeQpResidual();
}

Real
CoefVectorTimeDerivative::computeQpJacobian()
{
  return _coeff * VectorTimeDerivative::computeQpJacobian();
}
