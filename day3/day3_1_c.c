#include <stdio.h>
#include <stdlib.h>

#define MAXLINESIZE 5

int ReadLineAsInt(FILE* fh)
{
    int c;
    int num = 0;
    char line[MAXLINESIZE];
    int index = 0;
    while ((c = getc(fh))!='\n' && c!=EOF) 
    {
        line[index++]=c;
    }
    if (c==EOF && index==0) return -1;
    for (int cnt = 0;cnt<index;cnt++)
    {
        if (line[cnt]=='1') num=num | (1<<index-cnt-1);
    }
    return num;     
}

int* ParseFile(char *filename) 
{
    FILE* fh = fopen(filename,"r");
    fseek(fh,0,SEEK_END);
    int size = ftell(fh);
    rewind(fh);
    int num;
    int bitcounter[MAXLINESIZE];
    for (int n=0;n<MAXLINESIZE;n++)
    {
        bitcounter[n]=0;
    }

    int lines = 0;
    while ((num = ReadLineAsInt(fh))!=-1) 
    {
        for (int n=0;n<MAXLINESIZE;n++) 
        {
            if ((num&(1<<n))>0) bitcounter[n]++;
        }
        lines++;
    }
    fclose(fh);

    int gamma = 0;
    int epsilon = 0;
    for (int n=0;n<MAXLINESIZE;n++) 
        if (bitcounter[n]>lines/2) gamma=gamma|(1<<n);
        else epsilon=epsilon|(1<<n);
    printf("Gamma %i - Epsilon %i - Power consumption %i",gamma,epsilon,gamma*epsilon);
}

int main() 
{
    ParseFile("./data.txt");
}