#include "hiveApp.h"
#include "MooseMain.h"

// Begin the main program.
int
main(int argc, char * argv[])
{
  Moose::main<hiveApp>(argc, argv);

  return 0;
}
