OPTION EXPLICIT
OPTION DEFAULT NONE
OPTION BASE 0

CONST VERSION$ = "0.1"

DIM dirToRemove$, fileToRemove$
DIM recursionLevel% = 0
DIM errno% = 0
DIM didSomething% = 0

PRINT "Recursive Delete " VERSION$ " by Epsilon"

'Allow to pass in directory to remove as command line argument
IF (MM.CMDLINE$ = "") THEN
  INPUT "Directory to remove:"; dirToRemove$
ELSE
  dirToRemove$ = MM.CMDLINE$
ENDIF

DIM yesNo$

'Also handle the case of matching files
fileToRemove$ = DIR$(dirToRemove$, FILE)
IF fileToRemove$ <> "" THEN
  PRINT "Delete file(s) " dirToRemove$
  INPUT "Are you sure? (Y/N)"; yesNo$
  IF UCASE$(yesNo$) = "Y" THEN
    DO WHILE fileToRemove$ <> ""
      PRINT "Removing " fileToRemove$
      KILL fileToRemove$
      didSomeThing% = 1
      fileToRemove$ = DIR$()
    LOOP
  ENDIF
ENDIF

DIM matchingDir$ = DIR$(dirToRemove$, DIR)
IF (matchingDir$ = "") THEN
  IF didSomething% = 0 THEN
    PRINT "No matching directories found."
  ENDIF
  GOTO EndOfProg
ENDIF

PRINT "Delete dir(s) " dirToRemove$
INPUT "Are you sure? (Y/N)"; yesNo$
IF UCASE$(yesNo$) = "Y" THEN
  'This is the actual entry point into the recursive remove logic.
  processDir matchingDir$
ENDIF

EndOfProg:
IF errno% <> 0 THEN
  PRINT "errno=" errno%
ENDIF

PRINT "Done."


'This subroutine recursively removes the contents of given directory.
SUB processDir(dirToProcess$)
  recursionLevel% = recursionLevel% + 1

  LOCAL dirToProcess_l$ = dirToProcess$

  PRINT SPACE$(recursionLevel%*2) "Processing dir " dirToProcess_l$

  CHDIR dirToProcess_l$

  'Process the files
  LOCAL fileToRemove$ = DIR$("*", FILE)

  DO WHILE fileToRemove$ <> ""
    PRINT SPACE$(recursionLevel%*2) "Removing file " fileToRemove$
    KILL fileToRemove$
    fileToRemove$ = DIR$()
    IF errno% <> 0 THEN
      GOTO EndOfProg
    ENDIF
  LOOP

  'Process the subdirs  
  LOCAL subDir$ = DIR$("*", DIR)

  'DIR$/nextDir$ can't handle recursion in this while loop so we have to build a subDir list  
  LOCAL numSubDirs% = 0

  'First calculate how many subdirs there are in this directory
  DO WHILE subDir$ <> ""
    numSubDirs% = numSubDirs% + 1
    subDir$ = DIR$()
    IF errno% <> 0 THEN
      GOTO EndOfProg
    ENDIF
  LOOP

  IF numSubDirs% >= 1 THEN
    'Note: The size of this array is too big by 1 entry
    LOCAL subDirList$(numSubDirs%)

    subDir$ = DIR$("*", DIR)
    LOCAL listIdx% = 0

    DO WHILE subDir$ <> ""
      subDirList$(listIdx%) = subDir$
      subDir$ = DIR$()
      IF errno% <> 0 THEN
        GOTO EndOfProg
      ENDIF
      listIdx% = listIdx% + 1
    LOOP  

    'Now we recurse. For some reason this doesn't work with a while loop, 
    'but with a for loop it works just fine.
    FOR listIdx%=0 TO numSubDirs%-1
      processDir subDirList$(listIdx%)
    NEXT listIdx%
  ENDIF

  CHDIR ".."
  'Now the directory should be empty so we can remove it.
  RMDIR dirToProcess_l$

  recursionLevel% = recursionLevel% - 1
END SUB

                              