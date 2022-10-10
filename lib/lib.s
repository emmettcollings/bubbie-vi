/* lib.s
 * A big thing that includes all of the subroutines we make so that we only 
 * need one include in tests for now. May have some weird multiple includes 
 * thing, not sure if dasm handles this nicely.
 *
 * Considerations to think about:
 * - need to make better use of SUBROUTINE dasm directive so we don't have to 
 *   be super anal about unique labels
 */

include "globals.s"
include "printString.s"
include "busyLoop.s"
