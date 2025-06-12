#include "MatVectorTimeDerivative.h"

registerMooseObject("MooseApp", MatVectorTimeDerivative);

InputParameters
MatVectorTimeDerivative::validParams()
{
  InputParameters params = VectorTimeDerivative::validParams();
  params.addRequiredParam<MaterialPropertyName>(
      "material",
      "The name of the material property that will be multiplied by the vector time derivative.");
  return params;
}

MatVectorTimeDerivative::MatVectorTimeDerivative(const InputParameters & parameters)
  : VectorTimeDerivative(parameters), _coeff(getMaterialProperty<Real>("material"))
{
}

Real
MatVectorTimeDerivative::computeQpResidual()
{
  return _coeff[_qp] * VectorTimeDerivative::computeQpResidual();
}

Real
MatVectorTimeDerivative::computeQpJacobian()
{
  return _coeff[_qp] * VectorTimeDerivative::computeQpJacobian();
}
