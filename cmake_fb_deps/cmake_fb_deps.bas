/'* \file cmake_fb_deps.bas
\brief The source code of the tool cmake_fb_deps.
\since 0.0

Copyright (C) 2014, Thomas{ dOt ]Freiherr[ aT ]gmx[ DoT }net

Licence GPLv3

See page \ref PagCmakeFbDeps for a detailed description.

'/

#IFDEF __FB_UNIX__
  CONST SLASH = "/" '*< The directory separator.
#ELSE
  CONST SLASH = CHR(&h5C)
#ENDIF
CONST DirUp = ".." & SLASH  '*< The sequence to step a directory up.
DIM SHARED AS STRING DEPS _ '*< A global variable to collect file specific dependency file names.
               , ALL_DEPS   '*< A global variable to collect all dependency file names.

/'* \brief Add a file name two a directory.
\param P1 The path of the file.
\param P2 The path (relative or absolute) and name of the file to point to.
\returns A string of the combined file name.

Append a relative or a absolute path / name combination to a path, if
the combination isn't an absolute path. In case of an absolute path /
name combination it gets returned unchanged. Otherwise the relative
path gets mangled with the P1 path and all '..' sequences get removed.

'/
FUNCTION absNam(BYREF P1 AS STRING, BYREF P2 AS STRING) AS STRING
#IFDEF __FB_UNIX__
  IF LEFT(P2, 1) = "/" THEN RETURN P2
#ELSE
  IF MID(P2, 2, 1) = ":" THEN RETURN P2
#ENDIF
  IF LEN(P1) ANDALSO RIGHT(P1, 1) <> SLASH THEN P1 &= SLASH
  VAR i = INSTRREV(P2, SLASH)
  IF i THEN i = LEN(P1) ELSE RETURN P1 & P2
  IF LEFT(P2, 2) = MID(DirUp, 2) THEN RETURN P1 & MID(P2, 3)
  VAR s = 1
  WHILE MID(P2, s, 3) = DirUp
    i = INSTRREV(P1, SLASH, i - 1) : IF 0 = i THEN RETURN MID(P2, s)
    s += 3
  WEND
  IF MID(P2, s, 2) = MID(DirUp, 2) THEN s += 2
  RETURN LEFT(P1, i) & MID(P2, s)
END FUNCTION


/'* \fn FUNCTION_AS_ZSTRING_PTR Scan (BYREF_AS_STRING Fnam)
\brief Scan a file for #`INCLUDE`s, follow further nested #`INCLUDE`s.
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
  VAR fnr = FREEFILE
  IF OPEN(Fnam FOR INPUT AS fnr) THEN              RETURN @"Open failed"
  VAR le = LOF(fnr), p = ALLOCATE(le)
  IF 0 = p THEN                    CLOSE #fnr : RETURN @ "Out of memory"

  VAR  c = CAST(UBYTE PTR, p) _
    , fl = 0 _
  , fold = LEFT(Fnam, INSTRREV(Fnam, SLASH) - 1)

  GET #fnr, , *c, le
  FOR i AS INTEGER = 0 TO le - 1
    SELECT CASE AS CONST c[i]
    CASE ASC(":") : IF fl THEN fl = 0
    CASE ASC(!"\n")
      IF fl ANDALSO _
         c[i - 1] <> ASC("_") THEN fl = 0
    CASE ASC("#")
      IF i ANDALSO c[i - 1] > ASC(" ") THEN                   EXIT SELECT
      i += 1 : WHILE c[i] <= ASC(" ") : i += 1 : WEND ' skip white spaces
      VAR p = 0 _
        , x = c + i _
        , t = "INCLUDE"
      IF le - i < LEN(t) + 3 THEN                                  EXIT FOR
      FOR p = 0 TO LEN(t) - 1
        IF t[p] <> (x[p] AND &b11011111) THEN                 EXIT SELECT
      NEXT
      SELECT CASE AS CONST x[p]
      CASE ASC(" "), ASC(!"\t"), ASC(!"\v"), ASC(!"""") : fl = 1
      END SELECT
    CASE ASC("""")
      VAR x = c + i + 1 _
      , esc = IIF(i, IIF(c[i - 1] = ASC("!"), 1, 0), 0)
      DO
        i += 1 : IF i >= le THEN                                   EXIT FOR
        SELECT CASE AS CONST c[i]
        CASE 0 :                                                   EXIT FOR
        CASE ASC(!"\n") : i -= 1 :                                EXIT DO
        CASE ASC("\") : IF esc THEN i += 1
        CASE ASC("""") : IF c[i + 1] = ASC("""") THEN i += 1 ELSE EXIT DO
        END SELECT
      LOOP : IF 0 = fl THEN EXIT SELECT
      VAR inam = absNam(fold, LEFT(PEEK(ZSTRING, x), c + i - x))
      IF Scan(inam) THEN                                      EXIT SELECT
      inam = ";" & inam & ";"
      IF 0 = INSTR(DEPS, inam) THEN DEPS &= MID(inam, 2) ELSE EXIT SELECT
      IF 0 = INSTR(ALL_DEPS, inam) THEN ALL_DEPS &= MID(inam, 2)
    CASE ASC("'")
      i += 1
      WHILE c[i] <> ASC(!"\n")
        i += 1 : IF i >= le THEN EXIT FOR
      WEND
    CASE ASC("/")
      IF c[i + 1] <> ASC("'") THEN                            EXIT SELECT
      i += 2
      DO
        SELECT CASE AS CONST c[i]
        CASE 0 :                                                   EXIT FOR
        CASE ASC("'")
          SELECT CASE AS CONST c[i + 1]
          CASE 0 :                                                 EXIT FOR
          CASE ASC("/") : i += 1 :                                EXIT DO
          END SELECT
        END SELECT : i += 1
      LOOP
    CASE ELSE
    END SELECT
  NEXT
  DEALLOCATE(p)
  CLOSE #fnr
  RETURN 0
END FUNCTION


' ***** main *****

' we need at least two parameters
IF __FB_ARGC__ < 2 THEN                   ?"Too less parameters" : END 1

' open the output file
VAR fnr = FREEFILE '*< The file number for the output file.
IF OPEN(COMMAND(1) FOR OUTPUT AS fnr) THEN _
                                    ?"Cannot open " & COMMAND(1) : END 1
PRINT #fnr, "# Fbc header dependencies, auto generated by cmake_fb_deps. DO NOT EDIT!"

' scan all specified source files and write putput
VAR fl = 1 '*< A flag if to interpret a string as file name to include.
ALL_DEPS = ";"
FOR i AS INTEGER = 2 TO __FB_ARGC__ - 1
  DEPS = ";"
  IF 0 = Scan(absNam(CURDIR(), COMMAND(i))) ANDALSO _
         LEN(DEPS) > 1 THEN
    IF fl THEN ' write preamble (only once)
      PRINT #fnr, ""
      PRINT #fnr, "IF(NOT COMMAND ADD_FILE_DEPENDENCIES)"
      PRINT #fnr, "  INCLUDE(AddFileDependencies)"
      PRINT #fnr, "ENDIF()"
      fl = 0
    END IF
    PRINT #fnr, "" ' the entry for the current file
    PRINT #fnr, "ADD_FILE_DEPENDENCIES(" & COMMAND(i) & " " &  MID(DEPS, 2, LEN(DEPS) - 2) & ")"
  END IF
NEXT

' add the CMake command to re-create the file in case of any changes
IF LEN(ALL_DEPS) > 1 THEN
  PRINT #fnr, ""
  PRINT #fnr, "ADD_CUSTOM_COMMAND(OUTPUT " & COMMAND(1)
  PRINT #fnr, "  COMMAND ${CMAKE_COMMAND} -E cmake_fb_deps " & COMMAND(1) & MID(COMMAND, LEN(COMMAND(1)) + 1)
  PRINT #fnr, "  DEPENDS " & MID(ALL_DEPS, 2, LEN(ALL_DEPS) - 2)
  PRINT #fnr, "  )"
END IF
CLOSE #fnr

'' help Doxygen to dokument the main code
'&/** The main function. */
'&int main() {Scan();}