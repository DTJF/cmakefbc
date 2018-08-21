/'* \file cmakefbc_deps.bas
\brief The source code of the tool cmakefbc_deps.
\since 0.0

Copyright (C) 2014-\Year, \Mail

Licence GPLv3

See page \ref PagCmakeFbDeps for a detailed description.

'/

'* The current version
#DEFINE VERSION "0.2"

#IFDEF __FB_UNIX__
  CONST SLASH = "/" '*< The directory separator.
#ELSE
  CONST SLASH = CHR(&h5C)
#ENDIF
CONST DirUp = ".." & SLASH  '*< The sequence to step a directory up.
DIM SHARED AS STRING DEPS _ '*< A global variable to collect file specific dependency file names.
               , ALL_DEPS _ '*< A global variable to collect all dependency file names.
               , FBC_FOLD _ '*< A global variable for the FreeBASIC include folder.
               , BAS_FOLD   '*< A global variable containing the folder of the current bas file.

'* Generate output in case of skipping a file
#DEFINE SKIP_FILE(_E_,_N_,_M_) ?COMMAND(0) & ": skipping " & _N_ & " (" & *_E_ & _M_ & ")"
'* Generate output for an error message
#DEFINE GEN_ERROR(_T_) ?COMMAND(0) & ": " & _T_
'* Generate version message
#DEFINE PRINT_VERS ?COMMAND(0) & ": version " & VERSION
'* Generate help message
#DEFINE PRINT_HELP ?COMMAND(0) & ": help is comming soon ..."


/'* \brief Add a file name two a directory.
\param P1 The path of the file.
\param P2 The path (relative or absolute) and name of the file to point to.
\returns A string of the combined file name.

Append a relative or a absolute path / name combination to a path, if
the combination isn't an absolute path. In case of an absolute path /
name combination it gets returned unchanged. Otherwise the relative
path gets mangled with the P1 path and all '..' sequences get removed.

'/
FUNCTION absNam(BYREF P1 AS STRING, BYREF P2 AS STRING = "") AS STRING
#IFDEF __FB_UNIX__
  IF LEFT(P2, 1) = "/" THEN RETURN absNam(P2)
  IF LEFT(P2, 2) = "./" THEN P2 = MID(P2, 3)
  IF LEFT(P1, 2) = "./" THEN P1 = MID(P1, 3)
  IF LEN(P1) ANDALSO RIGHT(P1, 1) <> SLASH THEN P1 &= SLASH
  VAR x = P1 & P2, s = INSTR(x, DirUp)
  DO
    SELECT CASE AS CONST s
    CASE 0, 1 : RETURN x
    CASE 2 : RETURN MID(x, s) ' invalid
#ELSE
  IF MID(P2, 2, 1) = ":" THEN RETURN absNam(P2)
  IF LEFT(P2, 2) = ".\" THEN P2 = MID(P2, 3)
  IF LEFT(P1, 2) = ".\" THEN P1 = MID(P1, 3)
  IF LEN(P1) ANDALSO RIGHT(P1, 1) <> SLASH THEN P1 &= SLASH
  VAR x = P1 & P2, s = INSTR(x, DirUp)
  DO
    SELECT CASE AS CONST s
    CASE 0 TO 2 : RETURN x
    CASE 3 : RETURN MID(x, s) ' invalid
#ENDIF
    END SELECT
    VAR p = INSTRREV(x, SLASH, s - 2)
    IF p THEN x = LEFT(x, p) & MID(x, s + 3) _
         ELSE x = MID(x, s + 3)
    s = INSTR(x, DirUp)
  LOOP
END FUNCTION


/'* \brief Scan a file for #`INCLUDE`s, follow further nested #`INCLUDE`s.
\param Fnam The path / name of the file to start.
\returns 0 (zero) on success, an error text otherwise.

Scan a file for #`INCLUDE` statements, and do

- nothing if the file isn't in the project (ie. "dir.bi" fbc header in separate folder),
- or scan then file and
  - add the file to the dependency list when readable and
  - find nested dependencies in the file (recursive),
- and add the file to the global dependency list ALL_DEPS (if not present yet).

'/
FUNCTION Scan(BYREF Fnam AS STRING) AS ZSTRING PTR
  IF INSTRREV(DEPS, ";" & Fnam & ";") THEN  RETURN 0
  DEPS &= Fnam & ";"

  VAR fnr = FREEFILE
  IF OPEN(Fnam FOR INPUT AS fnr) THEN              RETURN @"open failed"

  VAR le = LOF(fnr), p = ALLOCATE(le)
  IF 0 = p THEN                    CLOSE #fnr : RETURN @ "out of memory"
  VAR  c = CAST(UBYTE PTR, p) _
    , fl = 0 _
  , fold = LEFT(Fnam, INSTRREV(Fnam, SLASH) - 1)
  GET #fnr, , *c, le
  FOR i AS INTEGER = 0 TO le - 1
    SELECT CASE AS CONST c[i]
    CASE ASC(":") : IF fl THEN fl = 0
    CASE ASC(!"_")
      SELECT CASE AS CONST c[i + 1] ' whitespace behind?
      CASE ASC(" "), ASC(!"\t"), ASC(!"\v") ', ASC(!"\n"), ASC(!"\l"), ASC(!"\r")
      CASE ELSE :                                            EXIT SELECT
      END SELECT

      IF i THEN
        SELECT CASE AS CONST c[i - 1] ' whitespace before?
        CASE ASC(" "), ASC(!"\t"), ASC(!"\v") ', ASC(!"\n"), ASC(!"\l"), ASC(!"\r")
        CASE ELSE :                                          EXIT SELECT
        END SELECT
      END IF
      i += 2 : WHILE c[i] > ASC(!"\n") : i += 1 : WEND ' skip white spaces
    CASE ASC(!"\n")
      IF fl ANDALSO _
         c[i - 1] <> ASC("_") THEN fl = 0
    CASE ASC("#")
      IF i ANDALSO c[i - 1] > ASC(" ") THEN                  EXIT SELECT
      i += 1 : WHILE c[i] <= ASC(" ") : i += 1 : WEND ' skip white spaces
      VAR p = 0 _
        , x = c + i _
        , t = "INCLUDE"
      IF le - i < LEN(t) + 3 THEN                               EXIT FOR
      FOR p = 0 TO LEN(t) - 1
        IF t[p] <> (x[p] AND &b11011111) THEN                EXIT SELECT
      NEXT
      SELECT CASE AS CONST x[p]
      CASE ASC(" "), ASC(!"\t"), ASC(!"\v"), ASC(!"""") : fl = 1
      END SELECT
    CASE ASC("""")
      VAR x = c + i + 1 _
      , esc = IIF(i, IIF(c[i - 1] = ASC("!"), 1, 0), 0)
      DO
        i += 1 : IF i >= le THEN                                EXIT FOR
        SELECT CASE AS CONST c[i]
        CASE 0 :                                                EXIT FOR
        CASE ASC(!"\n") : i -= 1 :                               EXIT DO
        CASE ASC("\") : IF esc THEN i += 1
        CASE ASC("""") : IF c[i + 1] = ASC("""") THEN i += 1 ELSE EXIT DO
        END SELECT
      LOOP : IF 0 = fl THEN EXIT SELECT
      VAR snam = LEFT(PEEK(ZSTRING, x), c + i - x) _
        , inam = absNam(fold, snam)
      VAR r = Scan(inam)
      IF r THEN '                        got an error, try fallback path
        IF BAS_FOLD <> fold THEN
          inam = absNam(BAS_FOLD, snam)
          r = Scan(inam)
        END IF
        IF r THEN '                    again error, try fbc include path
          VAR fd = FREEFILE
          IF OPEN(absNam(FBC_FOLD, snam) FOR INPUT AS #fd) _ ' in global headers?
                    THEN SKIP_FILE(r, snam, " in " & Fnam) : EXIT SELECT
          CLOSE #fd          /' global headers, drop it '/ : EXIT SELECT
        END IF
      END IF : inam = ";" & inam & ";"
      IF 0 = INSTR(ALL_DEPS, inam) THEN ALL_DEPS &= MID(inam, 2)
    CASE ASC("'")
      i += 1
      WHILE c[i] <> ASC(!"\n")
        i += 1 : IF i >= le THEN EXIT FOR
      WEND
    CASE ASC("/")
      IF c[i + 1] <> ASC("'") THEN                           EXIT SELECT
      i += 2
      DO
        SELECT CASE AS CONST c[i]
        CASE 0 :                                                EXIT FOR
        CASE ASC("'")
          SELECT CASE AS CONST c[i + 1]
          CASE 0 :                                              EXIT FOR
          CASE ASC("/") : i += 1 :                               EXIT DO
          END SELECT
        END SELECT : i += 1
      LOOP
    CASE ELSE
    END SELECT
  NEXT : DEALLOCATE(p) : CLOSE #fnr                           : RETURN 0
END FUNCTION


' ***** main *****

VAR cnr = 1
IF ASC(COMMAND(cnr)) = ASC("-") THEN
  SELECT CASE COMMAND(cnr)
  CASE "-p" : FBC_FOLD = absNam(COMMAND(cnr + 1)) : cnr += 2
  CASE "-v" : PRINT_VERS : END 0
  CASE "-h" : PRINT_HELP : END 0
  CASE ELSE : PRINT_HELP : END 1
  END SELECT
END IF

' we need at least two parameters
IF cnr + 1 >= __FB_ARGC__ THEN     GEN_ERROR("Too less parameters") : END 1

' open the output file
VAR fnr = FREEFILE '*< The file number for the output file.
IF OPEN(COMMAND(cnr) FOR OUTPUT AS fnr) THEN _
                          GEN_ERROR("Cannot open " & COMMAND(cnr)) : END 1

PRINT #fnr, "# Fbc header dependencies, auto generated by cmakefbc_deps-" & VERSION & ". DO NOT EDIT!"

' scan all specified source files and write putput
VAR fl = 1 '*< A flag if to interpret a string as file name to include.
ALL_DEPS = ";"
FOR i AS INTEGER = cnr + 1 TO __FB_ARGC__ - 1
  DEPS = ";"
  VAR fnam = absNam(CURDIR(), COMMAND(i)) '*< Full path / name of the file in process
  BAS_FOLD = LEFT(fnam, INSTRREV(fnam, SLASH) - 1)
  VAR r = Scan(fnam)  '*< Result of scanning process (<> 0 = error)
  SELECT CASE r
  CASE 0 : IF LEN(DEPS) < 2 THEN EXIT SELECT
    IF fl THEN ' write preamble (only once)
      PRINT #fnr, ""
      PRINT #fnr, "IF(NOT COMMAND ADD_FILE_DEPENDENCIES)"
      PRINT #fnr, "  INCLUDE(AddFileDependencies)"
      PRINT #fnr, "ENDIF()"
      fl = 0
    END IF
    PRINT #fnr, "" ' the entry for the current file
    MID(DEPS, INSTR(2, DEPS, ";"), 1) = " "
    PRINT #fnr, "ADD_FILE_DEPENDENCIES(" & MID(DEPS, 2, LEN(DEPS) - 2) & ")"
  CASE ELSE
    SKIP_FILE(r, fnam, " from input list")
    PRINT #fnr, !"\n# Dropped: " & COMMAND(i) & " (" & *r & ")"
  END SELECT
NEXT

' add the CMake command to re-create the file in case of any changes
IF LEN(ALL_DEPS) > 1 THEN
  PRINT #fnr, ""
  PRINT #fnr, "ADD_CUSTOM_COMMAND(OUTPUT " & COMMAND(cnr)
  PRINT #fnr, "  COMMAND ${CMAKE_COMMAND} -E ${CMAKE_Fbc_DEPS_TOOL} " & COMMAND
  PRINT #fnr, "  DEPENDS " & MID(ALL_DEPS, 2, LEN(ALL_DEPS) - 2)
  PRINT #fnr, "  )"
END IF
CLOSE #fnr

'' help Doxygen to dokument the main code
'&/** The main function. */
'&int main() {Scan();}
