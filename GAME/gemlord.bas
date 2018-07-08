_TITLE "Gemlord"
'_FULLSCREEN

COLS = 80
ROWS = 20
DIM SCENE(COLS, ROWS) AS INTEGER
DIM PSCENE(COLS, ROWS) AS INTEGER
DIM COLORS(COLS * ROWS) AS INTEGER
DIM SOLIDS(COLS * ROWS) AS INTEGER
DIM LEVEL_DATA(COLS * ROWS * 3) AS INTEGER

DIM GEMS(14) AS INTEGER
DIM GEMC(14) AS INTEGER
DIM GEMB(14) AS INTEGER
GEMS(1) = 3: GEMS(2) = 4: GEMS(3) = 5: GEMS(4) = 6: GEMS(5) = 15: GEMS(6) = 21: GEMS(7) = 30: GEMS(8) = 127: GEMS(9) = 145: GEMS(10) = 157: GEMS(11) = 232: GEMS(12) = 233: GEMS(13) = 235: GEMS(14) = 236
GEMC(1) = 9: GEMC(2) = 10: GEMC(3) = 11: GEMC(4) = 12: GEMC(5) = 13: GEMC(6) = 14: GEMC(7) = 15: GEMC(8) = 14: GEMC(9) = 13: GEMC(10) = 12: GEMC(11) = 11: GEMC(12) = 10: GEMC(13) = 9: GEMC(14) = 15
GEMB(1) = 0: GEMB(2) = 0: GEMB(3) = 0: GEMB(4) = 0: GEMB(5) = 0: GEMB(6) = 0: GEMB(7) = 0: GEMB(8) = 0: GEMB(9) = 0: GEMB(10) = 0: GEMB(11) = 0: GEMB(12) = 0: GEMB(13) = 0: GEMB(14) = 0

DIM LVLNAME AS STRING
LVLNAME = "TEST"

DIM PLAYERX AS INTEGER
DIM PLAYERY AS INTEGER
DIM PPLAYERX AS INTEGER
DIM PPLAYERY AS INTEGER

DIM SAVE_PATH AS STRING
SAVE_PATH = "LEVELS/SAVE.TXT"

OPEN SAVE_PATH FOR INPUT AS #1
INPUT #1, LVLNAME
FOR I = 1 TO 14
    INPUT #1, GEMB(I)
NEXT
CLOSE #1

DIM X AS INTEGER
DIM Y AS INTEGER
DIM CURRSCENE AS INTEGER
DIM GIMMECHAR AS INTEGER

GOTO SPLASH

LOADLEVEL:
COLOR 15
OPEN "LEVELS/" + LVLNAME + ".TXT" FOR INPUT AS #1
FOR I = 1 TO ROWS * COLS * 3
    INPUT #1, LEVEL_DATA(I)
NEXT
INPUT #1, PLAYERX
INPUT #1, PLAYERY
INPUT #1, GEMX
INPUT #1, GEMY
INPUT #1, GEMI
CLOSE #1

COUNT = 1
FOR Y = 1 TO ROWS
    FOR X = 1 TO COLS
        SCENE(X, Y) = LEVEL_DATA(COUNT)
        COUNT = COUNT + 1
    NEXT X
NEXT Y

FOR I = 1 TO ROWS * COLS
    COLORS(I) = LEVEL_DATA(COUNT)
    COUNT = COUNT + 1
NEXT

FOR I = 1 TO ROWS * COLS
    SOLIDS(I) = LEVEL_DATA(COUNT)
    COUNT = COUNT + 1
NEXT

FOR Y = 1 TO ROWS
    FOR X = 1 TO COLS
        PSCENE(X, Y) = SCENE(X, Y)
    NEXT X
NEXT Y


DRAWHERE:
CLS
SCENE(PLAYERX, PLAYERY) = 1
IF GEMB(GEMI) < 1 THEN
    COLORS((GEMY - 1) * COLS + GEMX) = GEMC(GEMI)
    SCENE(GEMX, GEMY) = GEMS(GEMI)
ELSE
    COLORS((GEMY - 1) * COLS + GEMX) = 15
END IF

COUNT = 1
FOR Y = 1 TO ROWS
    FOR X = 1 TO COLS
        COLOR COLORS(COUNT)
        PRINT CHR$(SCENE(X, Y));
        COUNT = COUNT + 1
    NEXT X
NEXT Y

PRINT "________________________________________________________________________________"

PRINT CHR$(218) + " GEMS: [";
FOR I = 1 TO 14
    IF GEMB(I) > 0 THEN
        COLOR GEMC(I)
        PRINT CHR$(GEMS(I));
    ELSE
        COLOR 15
        PRINT CHR$(45);
    END IF
NEXT
COLOR 15: PRINT "]"
PRINT CHR$(192) + " LOCATION: ";: COLOR 10: PRINT LVLNAME

PPLAYERX = PLAYERX: PPLAYERY = PLAYERY
SCENE(PPLAYERX, PPLAYERY) = PSCENE(PPLAYERX, PPLAYERY)

DO
    K$ = INKEY$
    K$ = UCASE$(K$)
LOOP UNTIL K$ = CHR$(0) + CHR$(75) OR K$ = CHR$(0) + CHR$(72) OR K$ = CHR$(0) + CHR$(80) OR K$ = CHR$(0) + CHR$(77) OR K$ = CHR$(27)
IF K$ = CHR$(0) + CHR$(72) THEN PLAYERY = PLAYERY - 1 'UP
IF K$ = CHR$(0) + CHR$(80) THEN PLAYERY = PLAYERY + 1 'DOWN
IF K$ = CHR$(0) + CHR$(75) THEN PLAYERX = PLAYERX - 1 'LEFT
IF K$ = CHR$(0) + CHR$(77) THEN PLAYERX = PLAYERX + 1 'RIGHT
IF K$ = CHR$(27) THEN GOTO SAVE

IF PLAYERX <= 1 THEN PLAYERX = 1
IF PLAYERX >= COLS THEN PLAYERX = COLS
IF PLAYERY <= 1 THEN PLAYERY = 1
IF PLAYERY >= ROWS THEN PLAYERY = ROWS

IF SOLIDS((PLAYERY - 1) * COLS + PLAYERX) > 0 THEN
    PLAYERX = PPLAYERX: PLAYERY = PPLAYERY
    BEEP
END IF

IF PLAYERX = GEMX AND PLAYERY = GEMY AND GEMB(GEMI) < 1 THEN
    GEMB(GEMI) = 1
    PLAY "L4C"
    PLAY "L4A"
    PLAY "L4B"
    PLAY "G"
END IF

GOTO DRAWHERE

SPLASH:
OPEN "LEVELS/SPLASH.TXT" FOR INPUT AS #1
FOR I = 1 TO COLS * ROWS
    INPUT #1, CHAR
    INPUT #1, COL
    COLOR COL
    PRINT CHR$(CHAR);
NEXT
CLOSE #1
DO
    K$ = INKEY$
    K$ = UCASE$(K$)
LOOP UNTIL K$ = CHR$(32) OR K$ = CHR$(27)
IF K$ = CHR$(32) THEN GOTO LOADLEVEL
IF K$ = CHR$(27) THEN END



SAVE:
OPEN SAVE_PATH FOR OUTPUT AS #1
PRINT #1, LVLNAME
PRINT #1, GEMB(1)
PRINT #1, GEMB(2)
PRINT #1, GEMB(3)
PRINT #1, GEMB(4)
PRINT #1, GEMB(5)
PRINT #1, GEMB(6)
PRINT #1, GEMB(7)
PRINT #1, GEMB(8)
PRINT #1, GEMB(9)
PRINT #1, GEMB(10)
PRINT #1, GEMB(11)
PRINT #1, GEMB(12)
PRINT #1, GEMB(13)
PRINT #1, GEMB(14)
CLOSE #1
CLS
COLOR 15
PRINT "PROGRESS HAS BEEN SUCCESSFULLY SAVED!!!"
PLAY "C"
PLAY "A"
PLAY "B"
PLAY "G"
END
