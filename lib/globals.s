/*
 * When we decide where we want to store things such as zero page indexes, mem
 * locations for characters, screen buffer etc. we should create variables and
 * store them here so they can be included everywhere.
 */

CHROUT = $ffd2
SM = $fb
CLS = $e55f                 ; kernal clear screen routine
