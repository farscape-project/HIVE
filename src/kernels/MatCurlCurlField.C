#include "MatCurlCurlField.h"

registerMooseObject("MooseApp", MatCurlCurlField);

InputParameters
MatCurlCurlField::validParams()
{
  InputParameters params = CurlCurlField::validParams();
  params.addRequiredParam<MaterialPropertyName>(
      "material",
      "The name of the material property that will be multiplied by the curl-curl field.");
  return params;
}

MatCurlCurlField::MatCurlCurlField(const InputParameters & parameters)
  : CurlCurlField(parameters), _coeff(getMaterialProperty<Real>("material"))
{
}

Real
MatCurlCurlField::computeQpResidual()
{
  return _coeff[_qp] * CurlCurlField::computeQpResidual();
}

Real
MatCurlCurlField::computeQpJacobian()
{
  return _coeff[_qp] * CurlCurlField::computeQpJacobian();
}
