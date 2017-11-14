#include<stdio.h>

int main(int argc, char** argv){
	
	if (argc != 3){
		printf("Usage: extract_ruby input output\n");
		return 1;
	} 
    
  char *input_file = argv[1], *output_file = argv[2];
  
  FILE* fin = fopen(input_file, "rb");
  FILE* fout = fopen(output_file, "wb");
  
  char a = fgetc(fin), b = fgetc(fin), c = fgetc(fin);
  while (a != EOF){
    if (a == '<' && b == '%'){
      if (c == '=' || c == '-'){
        a = fgetc(fin);
        b = fgetc(fin);
        c = fgetc(fin);
        while ((a != '%' || b != '>') && (a != '-' || b != '%' || c != '>')){
          fputc(a, fout);
          a = b;
          b = c;
          c = fgetc(fin);      
        }   
        fputc('\n', fout);
        if (c != '>') 
          a = c;
        else 
          a = fgetc(fin);
        b = fgetc(fin);
        c = fgetc(fin);
      } else if (c == '#') {
        b = c;
        a = b;
        c = fgetc(fin);
      } else {
        a = c;
        b = fgetc(fin);
        c = fgetc(fin);
        while ((a != '%' || b != '>') && (a != '-' || b != '%' || c != '>')){
          fputc(a, fout);
          a = b;
          b = c;
          c = fgetc(fin);      
        }   
        fputc('\n', fout);
        if (c != '>')
          a = c;
        else 
          a = fgetc(fin);
        b = fgetc(fin);
        c = fgetc(fin);
      }
    } else {
      a = b;
      b = c;
      c = fgetc(fin); 
    }
  }
  
  fclose(fin);
  fclose(fout);
}
