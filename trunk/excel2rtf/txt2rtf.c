#include<stdio.h>
main()
{
 FILE *fp1;
 FILE *fp2;
 char ch;
 char file1[20];
 char file2[20];
 fgets(file1,20,stdin);
 fputs(file1,stdout);
 fputc('a',stdout);
 if((fp1=fopen(file1,"r"))==NULL)
 {
  printf("Cannot open file1 and strike ENTER key to exit!");
  exit(1);
 }
 fgets(file1,20,stdin);
 if((fp2=fopen(file2,"w"))==NULL)
 {
  printf("Cannot open file2 and strike ENTER key to exit!");
  exit(1);
 }
  fputs("{\\rtf1\\ansi\\deff0\\deftab720{\\fonttbl{\\f0\\fswiss MS Sans Serif;}{\\f1\\froman\\fcharset2 Symbol;}{\\f2\\fswiss\\fprq2 Arial;}{\\f3\\froman Times New Roman;}}",fp2);
  fputs("\n",fp2);
  fputs("{\\colortbl\\red0\\green0\\blue0;}",fp2);
  fputs("\n",fp2);
  fputs("\\deflang1033\\pard\\plain\\f2\\fs24 ",fp2);

  while((ch=fgetc(fp1))!=EOF)
  {
  if(ch=='\n') 
  {
   fputc(ch,fp2);
   fputs("\\par ",fp2);
   if((ch=fgetc(fp1))==EOF)
   {
    fputs(" }",fp2);
    fclose(fp1);
    fclose(fp2);
    goto end;
   }
   else
   {
    fputc(ch,fp2);
   }
  }
  else
  {
   fputc(ch,fp2);
  }
  }

  fputs(" }",fp2);
  fclose(fp1);
  fclose(fp2);

  end: return(0);
}
