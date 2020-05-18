REM
REM * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
REM *                                                                       *
REM *                         E S C A P E   2.2                             *
REM *                                                                       *
REM * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
REM
REM Known bugs:
REM
REM If a robot stumbles through a teleport and lands on the player, the game
REM freezes with the robot displayed at the player's position.
REM
REM                              OBJECTIVE
REM
REM The player is trapped in an enclosed labyrinth running from robotic
REM pursuers.  Fortunately, the walls and obstacles are fatal to the robots.
REM The object of the game is to position the player where the robots will
REM crash into the obstacles or into each other.  The walls and obstacles
REM are not fatal to the player because the computer does not allow the
REM player to make a move that brings him into contact with them.  The
REM computer also will not allow the player to commit suicide by moving onto
REM a space already occupied by a robot.  The robots blindly determine their
REM direction of travel based solely on the relative direction of the player.
REM This causes the robots to eventually stumble into the walls and obstacles
REM on the playing field. Five teleports are randomly scattered throughout
REM the playing field.  These devices will randomly transport whatever falls
REM into them to another random location on the playing field.
REM
REM * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
REM
REM                           LIST OF VARIABLES
REM
REM WALL:         Stores the ASCII value of the character designated as a
REM               wall on the playing field.
REM
REM ROBOT:        Stores the ASCII value of the character designated as a
REM               robot on the playing field.
REM
REM PLAYER:       Stores the ASCII value of the character designated as the
REM               player on the playing field.
REM
REM TELEPORT:     Stores the ASCII value of the character designated as a
REM               teleport on the playing field.
REM
REM EMPTYSPACE:   Stores the ASCII value of the character designated as empty
REM               space on the playing field, usually 32 (base 10) or " ".
REM
REM A( , ):       This two-dimensional array stores the ASCII values of each
REM               position on the playing field.
REM
REM P:            This variable stores the number of pursuers designated by
REM               the player at the beginning of the game.
REM
REM NUMBEROF-
REM DEADROBOTS:   This variable tracks the number of dead robots on the
REM               playing field.  When this number equals [P], the player
REM               wins.
REM
REM PURSUERX( ):  This one-dimensional array stores the X coordinate of each
REM               robot's position on the playing field.
REM
REM PURSUERX1( ): This one-dimensional array stores the X coordinate of each
REM               robot's PREVIOUS position on the playing field.
REM
REM PURSUERY( ):  This one-dimensional array stores the Y coordinate of each
REM               robot's position on the playing field.
REM
REM PURSUERY1( ): This one-dimensional array stores the Y coordinate of each
REM               robot's PREVIOUS position on the playing field.
REM
REM PLAYERX:      This variable stores the X coordinate of the player's
REM               position on the playing field.
REM
REM PLAYERX1:     This variable stores the X coordinate of the player's
REM               PREVIOUS position on the playing field.
REM
REM PLAYERY:      This variable stores the Y coordinate of the player's
REM               position on the playing field.
REM
REM PLAYERY1:     This variable stores the Y coordinate of the player's
REM               PREVIOUS position on the playing field.
REM
REM X:            This variable stores the current X coordinate of an item on
REM               the playing field.
REM
REM Y:            This variable stores the current Y coordinate of an item on
REM               the playing field.
REM
REM N:            This variable is used in loops.
REM
REM A$:           This variable accepts input from the player.
REM
REM PLAYERSCORE:  This variable stores the player's wins.
REM
REM ROBOTSCORE:   This variable stores the robot's wins.
REM
REM * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
REM
REM                            INITIALIZATION
REM
REM * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
REM
REM Prompt for a random number generator seed. Clear all variables and
REM arrays. Designate the ASCII characters used for items on the playing
REM field.
REM
    WIDTH 80
    CLS
    RANDOMIZE
    CLEAR
    WALL = 176
    robot = 143
    PLAYER = 2
    TELEPORT = 239
    EMPTYSPACE = ASC(" ")
REM
REM * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
REM
REM                     PROMPT PLAYER FOR INSTRUCTIONS
REM
REM * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
REM
    PRINT "Would you like instructions [Y/N]?"
WAITFORPLAYER:
    A$ = INKEY$
    IF A$ = "" THEN
               GOTO WAITFORPLAYER:
    ELSEIF A$ = "Y" OR A$ = "y" THEN
               GOSUB INSTRUCTIONS:
    ELSEIF A$ <> "N" AND A$ <> "n" THEN
               GOTO WAITFORPLAYER:
    END IF
REM
REM The user selects the number of robots who will be pursuing him.  The
REM computer stores this value in the variable [P].
REM
HOWMANYPURSUERS:
    INPUT "How many pursuers"; P
    IF P < 5 THEN
        PRINT "Don't you want a challenge?!"
        PRINT "At least try to evade more than four pursuers."
        PRINT
        GOTO HOWMANYPURSUERS:
    ELSEIF P <> INT(P) THEN
        PRINT "Quit goofing off and give me a whole number!"
        PRINT
        GOTO HOWMANYPURSUERS:
    ELSEIF P > 50 THEN
        PRINT "You must be a glutton for punishment!"
        PRINT "The playing field gets crowded with more than 50 pursuers."
        PRINT
        GOTO HOWMANYPURSUERS:
    END IF
REM
REM Create one-dimensional arrays to store the current and previous X and Y
REM coordinates of each individual robotic pursuer.
REM Create a two-dimensional (70x20) array to store the contents of the
REM playing field in memory.
REM
    DIM PURSUERX(1 TO P)
    DIM PURSUERY(1 TO P)
    DIM PURSUERX1(1 TO P)
    DIM PURSUERY1(1 TO P)
    DIM A(1 TO 70, 1 TO 20)
REM
INITIALIZE:
REM
REM Build walls around the field.
REM
REM East and West walls
REM
    FOR X = 1 TO 70
        A(X, 1) = WALL
        A(X, 20) = WALL
    NEXT X
REM
REM North and South walls
REM
    FOR Y = 1 TO 20
        A(1, Y) = WALL
        A(70, Y) = WALL
    NEXT Y
REM
REM Place random obstacles within the playing field.
REM
    FOR Y = 2 TO 19
    FOR X = 2 TO 69
        IF INT(RND(1) * 10) = 5 THEN A(X, Y) = WALL ELSE A(X, Y) = EMPTYSPACE
    NEXT X
    NEXT Y
REM
REM Place five teleports within the playing field.
REM
    FOR N = 1 TO 5
        GOSUB TELEPORTCHARACTER:
        A(X, Y) = TELEPORT
    NEXT N
REM
REM Place pursuers randomly within the playing field in spaces that are not
REM currently occupied by a WALL, a TELEPORT, or a ROBOT. Store each of their
REM X,Y coordinates in the one-dimensional arrays PURSUERX(N), PURSUERY(N).
REM The variable [N] designates the number of the individual robotic pursuer.
REM
    FOR N = 1 TO P
        GOSUB TELEPORTCHARACTER:
        PURSUERX(N) = X
        PURSUERY(N) = Y
        A(PURSUERX(N), PURSUERY(N)) = robot
    NEXT N
REM
REM Place player randomly within the playing field in a space that is not
REM currently occupied by a WALL, a TELEPORT, or a ROBOT. Store the player's
REM X,Y coordinates in the variables PLAYERX and PLAYERY.
REM
    GOSUB TELEPORTCHARACTER:
    PLAYERX = X
    PLAYERY = Y
    A(PLAYERX, PLAYERY) = PLAYER
REM
REM * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
REM *                                                                       *
REM *                           MAIN PROGRAM                                *
REM *                                                                       *
REM * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
REM
    CLS
    NUMBEROFDEADROBOTS = 0
MAIN:
    GOSUB DISPLAYPLAYINGFIELD:
    IF NUMBEROFDEADROBOTS >= P THEN GOTO ENDPGM:
    GOSUB PLAYERSMOVE:
    N = 0
    GOSUB ROBOTSMOVE:
GOTO MAIN:
REM
ENDPGM:
    IF A(PLAYERX, PLAYERY) = robot THEN
       ROBOTSCORE = ROBOTSCORE + 1
       GOSUB DISPLAYPLAYINGFIELD:
       LOCATE 23, 31
       COLOR 31, 0
       PRINT "G A M E   O V E R"
    ELSE PLAYERSCORE = PLAYERSCORE + 1
         GOSUB DISPLAYPLAYINGFIELD:
         LOCATE 23, 33
         COLOR 31, 0
         PRINT "Y O U   W I N!"
    END IF
REM
REM Prompt for another game.
REM
    LOCATE 24, 6
    COLOR 7, 0
    PRINT "Would you like to play again? [Y/N]";
REM
ANOTHERGAME:
    A$ = INKEY$
    IF A$ = "" THEN
               GOTO ANOTHERGAME:
    ELSEIF A$ = "Y" OR A$ = "y" THEN
               GOTO INITIALIZE:
    ELSEIF A$ <> "N" AND A$ <> "n" THEN
               GOTO ANOTHERGAME:
    ELSE GOTO RETURNTODOS:
    END IF
    GOTO ANOTHERGAME:
REM
RETURNTODOS:
    COLOR 7, 0
    SYSTEM
END
REM * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
REM *                                                                       *
REM *                 Display playing field subroutine                      *
REM *                                                                       *
REM * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
REM
DISPLAYPLAYINGFIELD:
REM
    FOR Y = 1 TO 20
    FOR X = 1 TO 70
        LOCATE Y, X + 5
        PRINT CHR$(A(X, Y));
    NEXT X
    NEXT Y
    PRINT
    PRINT "TYU"
    PRINT "G*H"
    PRINT "VBN"
    LOCATE 21, 6
    PRINT "Player"; TAB(58); "Pursuers"; P - NUMBEROFDEADROBOTS
    LOCATE 22, 7
    PRINT PLAYERSCORE; TAB(60); ROBOTSCORE;
RETURN
REM
REM * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
REM *                                                                       *
REM *                     Player's move subroutine                          *
REM *                                                                       *
REM * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
REM
PLAYERSMOVE:    
REM
REM Store previous position as current position
REM
     PLAYERX1 = PLAYERX
     PLAYERY1 = PLAYERY
REM
REM Wait for player to make a move
REM
     A$ = INKEY$
     IF A$ = "" THEN
                GOTO PLAYERSMOVE:
     ELSEIF A$ = "T" OR A$ = "t" THEN
                GOSUB MOVEUPANDLEFT:
     ELSEIF A$ = "Y" OR A$ = "y" THEN
                GOSUB MOVEUP:
     ELSEIF A$ = "U" OR A$ = "u" THEN
                GOSUB MOVEUPANDRIGHT:
     ELSEIF A$ = "G" OR A$ = "g" THEN
                GOSUB MOVELEFT:
     ELSEIF A$ = "H" OR A$ = "h" THEN
                GOSUB MOVERIGHT:
     ELSEIF A$ = "V" OR A$ = "v" THEN
                GOSUB MOVEDOWNANDLEFT:
     ELSEIF A$ = "B" OR A$ = "b" THEN
                GOSUB MOVEDOWN:
     ELSEIF A$ = "N" OR A$ = "n" THEN
                GOSUB MOVEDOWNANDRIGHT:
     ELSEIF A$ = "*" OR A$ = "8" THEN
                GOSUB DONTMOVE:
     ELSE GOTO PLAYERSMOVE:
     END IF
REM
REM Is the player's current position occupied by a wall or a robot?
REM
     IF A(PLAYERX, PLAYERY) = WALL OR A(PLAYERX, PLAYERY) = robot THEN
        PLAYERX = PLAYERX1
        PLAYERY = PLAYERY1
        GOTO PLAYERSMOVE:
     END IF
REM
REM Is the player's current position occupied by a teleport?
REM PLAYERX and PLAYERY will be random unoccupied coordinates
REM
     IF A(PLAYERX, PLAYERY) = TELEPORT THEN
        GOSUB TELEPORTCHARACTER:
        PLAYERX = X
        PLAYERY = Y
     END IF
REM
REM Make previous position EMPTYSPACE
REM Make current position PLAYER
REM
     A(PLAYERX1, PLAYERY1) = EMPTYSPACE
     A(PLAYERX, PLAYERY) = PLAYER
     RETURN
REM
MOVEUPANDLEFT:
REM
REM Subtract 1 from X and Y coordinates to move up and left or "NW"
REM
     PLAYERX = PLAYERX - 1
     PLAYERY = PLAYERY - 1
     RETURN
REM
MOVEUP:
REM
REM Subtract 1 from Y coordinate to move up or "N"
REM
     PLAYERY = PLAYERY - 1
RETURN
REM
MOVEUPANDRIGHT:
REM Subtract 1 from Y coordinate and add 1 to X coordinate to move up and
REM right or "NE"
REM
     PLAYERX = PLAYERX + 1
     PLAYERY = PLAYERY - 1
     RETURN
REM
MOVELEFT:
REM
REM Subtract 1 from X coordinate to move left or "W"
REM
     PLAYERX = PLAYERX - 1
     RETURN
REM
DONTMOVE:
REM
REM No player movement
REM
     RETURN
REM
MOVERIGHT:
REM
REM Add 1 to X coordinate to move right or "E"
REM
     PLAYERX = PLAYERX + 1
     RETURN
REM
MOVEDOWNANDLEFT:
REM
REM Add 1 to Y coordinate and subtract 1 from X coordinate to move down and
REM left or "SW"
REM
     PLAYERY = PLAYERY + 1
     PLAYERX = PLAYERX - 1
     RETURN
REM
MOVEDOWN:
REM
REM Add 1 to Y coordinate to move down or "S"
REM
     PLAYERY = PLAYERY + 1
     RETURN
REM
MOVEDOWNANDRIGHT:
REM
REM Add 1 to X coordinate and add 1 to Y coordinate to move down and left
REM or "SE"
REM
     PLAYERX = PLAYERX + 1
     PLAYERY = PLAYERY + 1
     RETURN
REM
REM * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
REM *                                                                       *
REM *                     Robot's move subroutine                           *
REM *                                                                       *
REM * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
REM
ROBOTSMOVE:
     N = N + 1
REM
REM Check if all robots have been moved.
REM
     IF N > P THEN RETURN
REM
REM Check if robot(N) has already terminated into a wall.
REM
     IF A(PURSUERX(N), PURSUERY(N)) = WALL THEN GOTO ROBOTSMOVE:
REM
REM Store current position of robot(N) as previous position
REM
     PURSUERX1(N) = PURSUERX(N)
     PURSUERY1(N) = PURSUERY(N)
REM
REM Calculate player's direction and move robot toward player
REM
     PURSUERX(N) = PURSUERX(N) + SGN(PLAYERX - PURSUERX(N))
     PURSUERY(N) = PURSUERY(N) + SGN(PLAYERY - PURSUERY(N))
REM
REM Vacate robot's previous position
REM
     A(PURSUERX1(N), PURSUERY1(N)) = EMPTYSPACE
REM
REM What is located in the robot's current position?
REM If the robot runs into a wall, it is dead.
REM If the robot runs into another robot, both robots are dead.
REM If the robot runs into a teleport, it gets teleported.
REM If the robot runs into the player, the player is dead.
REM
     IF A(PURSUERX(N), PURSUERY(N)) = WALL THEN
        NUMBEROFDEADROBOTS = NUMBEROFDEADROBOTS + 1
     ELSEIF A(PURSUERX(N), PURSUERY(N)) = robot THEN
        NUMBEROFDEADROBOTS = NUMBEROFDEADROBOTS + 2
        A(PURSUERX(N), PURSUERY(N)) = WALL
     ELSEIF A(PURSUERX(N), PURSUERY(N)) = PLAYER THEN
        A(PURSUERX(N), PURSUERY(N)) = robot
        GOSUB DISPLAYPLAYINGFIELD
        GOTO ENDPGM:
     ELSEIF A(PURSUERX(N), PURSUERY(N)) = TELEPORT THEN
        GOSUB TELEPORTCHARACTER:
        PURSUERX(N) = X
        PURSUERY(N) = Y
        A(PURSUERX(N), PURSUERY(N)) = robot
     ELSEIF A(PURSUERX(N), PURSUERY(N)) = EMPTYSPACE THEN
        A(PURSUERX(N), PURSUERY(N)) = robot
     END IF
     GOTO ROBOTSMOVE:
REM
REM * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
REM *                                                                       *
REM *                           INSTRUCTIONS                                *
REM *                                                                       *
REM * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
REM
INSTRUCTIONS:
     PRINT "The player is trapped in an enclosed labyrinth running from robotic pursuers."
     PRINT "Fortunately, the walls and obstacles are fatal to the robots. The object of"
     PRINT "the game is to position the player where the robots will crash into the"
     PRINT "obstacles or into each other.  The walls and obstacles are not fatal to the"
     PRINT "player because the computer does not allow the player to make a move that"
     PRINT "brings him into contact with them.  The computer also will not allow the"
     PRINT "player to commit suicide by moving onto a space already occupied by a robot."
     PRINT "The robots blindly determine their direction of travel based solely on the"
     PRINT "relative direction of the player. This causes the robots to eventually stumble"
     PRINT "into the walls and obstacles on the playing field. Five teleports are randomly"
     PRINT "scattered throughout the playing field. These devices will randomly transport"
     PRINT "whatever falls into them to another random location on the playing field."
     PRINT "The teleports are ["; CHR$(TELEPORT); "]. The robots are ["; CHR$(robot); "]."
     PRINT "The player is the ["; CHR$(PLAYER); "]. The player can move:"
     PRINT TAB(31); "NW    NORTH    NE"
     PRINT TAB(33); "\     |     /"
     PRINT TAB(35); "[T][Y][U]"
     PRINT TAB(27); "WEST -- [G][*][H] -- EAST"
     PRINT TAB(35); "[V][B][N]"
     PRINT TAB(33); "/     |     \"
     PRINT TAB(31); "SW    SOUTH    SE"
     RETURN
REM
REM * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
REM *                                                                       *
REM *                        TELEPORT CHARACTER                             *
REM *                                                                       *
REM * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
REM
REM Place character randomly within the playing field in a space that is not
REM currently occupied by a WALL, a TELEPORT, or a ROBOT. Store the X,Y
REM coordinates in the variables X and Y.
REM
TELEPORTCHARACTER:
    X = INT(RND(1) * 70) + 1
    Y = INT(RND(1) * 20) + 1
    IF A(X, Y) = WALL OR A(X, Y) = TELEPORT OR A(X, Y) = robot THEN GOTO TELEPORTCHARACTER:
    RETURN
REM
REM * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
REM *                                                                       *
REM *                           END PROGRAM                                 *
REM *                                                                       *
REM * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
REM

