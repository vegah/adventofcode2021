#include <stdio.h>
#include <stdlib.h>

#define MAXLINESIZE 5 // Change when changing data file

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

int FindOne(int* nums,int nolines,int def, int initialbitmask)
{
    int bitmask = (1<<MAXLINESIZE-1);
    initialbitmask=initialbitmask&bitmask;
    int currentbit = MAXLINESIZE-2;
    int lastread, found,lastfound;
    do 
    {
        found =0;
        int ones = 0, zeroes = 0;
        for (int n=0;n<nolines;n++)
        {
            lastread=nums[n];
            if ((lastread&bitmask)==(initialbitmask&bitmask))
            {
                found++;
                lastfound=lastread;
                if ((lastread&(1<<currentbit))>0) ones++;
                else zeroes++;
            }
        }
        bitmask=bitmask|(1<<currentbit);
        if ((ones>=zeroes && def==1) || (ones<zeroes && def==0)) initialbitmask=initialbitmask|(1<<currentbit);
        currentbit--;
    } while (found>1);
    return lastfound;

}

int* ParseFile(char *filename) 
{
    FILE* fh = fopen(filename,"r");
    fseek(fh,0,SEEK_END);
    int size = ftell(fh);
    rewind(fh);
    int num;
    int bitcounter[MAXLINESIZE];
    int nums[10000];
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
        nums[lines++]=num;
    }
    fclose(fh);

    int gamma = 0;
    int epsilon = 0;
    for (int n=0;n<MAXLINESIZE;n++) 
        if (bitcounter[n]>lines/2) gamma=gamma|(1<<n);
        else epsilon=epsilon|(1<<n);
    printf("Gamma %i - Epsilon %i - Power consumption %i\n",gamma,epsilon,gamma*epsilon);

    int o2 = FindOne(nums,lines,1,gamma);
    int co2 = FindOne(nums,lines,0,epsilon);
    printf("Life support rating %d",o2*co2);
}

int main() 
{
    ParseFile("./data.txt");
}