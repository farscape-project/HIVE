#include "hiveApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "ModulesApp.h"
#include "MooseSyntax.h"

InputParameters
hiveApp::validParams()
{
  InputParameters params = MooseApp::validParams();
  params.set<bool>("use_legacy_material_output") = false;
  return params;
}

hiveApp::hiveApp(InputParameters parameters) : MooseApp(parameters)
{
  hiveApp::registerAll(_factory, _action_factory, _syntax);
}

hiveApp::~hiveApp() {}

void 
hiveApp::registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  ModulesApp::registerAllObjects<hiveApp>(f, af, s);
  Registry::registerObjectsTo(f, {"hiveApp"});
  Registry::registerActionsTo(af, {"hiveApp"});

  /* register custom execute flags, action syntax, etc. here */
}

void
hiveApp::registerApps()
{
  registerApp(hiveApp);
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
extern "C" void
hiveApp__registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  hiveApp::registerAll(f, af, s);
}
extern "C" void
hiveApp__registerApps()
{
  hiveApp::registerApps();
}
