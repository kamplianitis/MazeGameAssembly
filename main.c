#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

char temp[100]; //  ok
    int PlayerPos=1; // ok
    int W =21; // ok
    int H = 11; // ok
    int startX =1; // ok
    int TotalElements = 231; // ok
    char move; // var to take the move that the user want to do

    char map[232]=  "I.IIIIIIIIIIIIIIIIIII"
                    "I....I....I.......I.I"
                    "III.IIIII.I.I.III.I.I"
                    "I.I.....I..I..I.....I"
                    "I.I.III.II...II.I.III"
                    "I...I...III.I...I...I"
                    "IIIII.IIIII.III.III.I"
                    "I.............I.I...I"
                    "IIIIIIIIIIIIIII.I.III"
                    "@...............I..II"
                    "IIIIIIIIIIIIIIIIIIIII";




    //functions needed
    void printLabyrinth (void) // searches based on playerPosition and just puts the P sign where the player is
    {
        int i,j,k=0;
        usleep(200000);
        printf("Labyrinth:\n");
        for (i=0; i<H; i++)
            {
                for(j=0; j<W; j++)
                    {
                        if(k==PlayerPos)
                            temp[j]='P';
                        else
                            temp[j]=map[k];
                        k++;
                    }
                temp[j+1]='\0';
                printf("%s\n", temp);
            }
    }



       int makeMove(int index)// finds the optimal path through trying every path possible by the following algorithm
    {
        if(index<0 || index>=TotalElements)
            return 0;
        if(map[index]=='.')
        {
            map[index]='*';
            printLabyrinth();
            if(makeMove(index+1)==1)
            {
                map[index]='#';
                printLabyrinth();
                return 1;
            }
            if(makeMove(index+W)==1)
            {
                map[index]='#';
                printLabyrinth();
                return 1;
            }
            if(makeMove(index-1)==1)
            {
                map[index]='#';
                printLabyrinth();
                return 1;
            }
            if(makeMove(index-W)==1)
            {
                map[index]='#';
                printLabyrinth();
                return 1;
            }
        }
        else if (map[index]=='@')
            {
                map[index]='%';
                printLabyrinth();
                return 1;
            }
        return 0; // ends the program cause its pointless to begin again having the optimal path already
}



    void findPath(void)
    {
        while(move !='e' && map[PlayerPos] != '@')
        {
            printf("where you wanna go ");
            move = getchar();
         switch(move)
         {
         case 'w':
            if(map[PlayerPos - W]=='.')
            {
                PlayerPos = PlayerPos - W;
                printLabyrinth();
            }
            else if(map[PlayerPos-W] == '@')
                printf("Winner Winner Chicken Dinner");
            else
            {
                printf("You cannot do that move\n");
            }
            break;
        case 's':
            if(map[PlayerPos + W]=='.')
            {
                PlayerPos = PlayerPos + W;
                printLabyrinth();
            }
            else if(map[PlayerPos+W] == '@')
                printf("Winner Winner Chicken Dinner");
            else
            {
                printf("You cannot do that move\n");
            }
            break;
            case 'a':
            if(map[PlayerPos - 1]=='.')
            {
                PlayerPos = PlayerPos - 1;
                 printLabyrinth();
            }
            else if(map[PlayerPos-1] == '@')
            {
                printf("Winner Winner Chicken Dinner");
            }
            else
                printf("You cannot do that move\n");
            break;

            case 'd':
            if(map[PlayerPos + 1]=='.')
            {
                PlayerPos = PlayerPos + 1;
                 printLabyrinth();
            }
            else if(map[PlayerPos+1] == '@')
                printf("Winner Winner Chicken Dinner");
            else
            {
                printf("You cannot do that move\n");
            }
            break;
            }
        }
    }

    int main()
    {
        printLabyrinth();
        findPath();

        if(move == 'e')
        {
            printLabyrinth();
            startX = makeMove(PlayerPos);
        }
    }
