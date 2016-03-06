
class rect2d {
    int[] flag=new int[16]; 
    
     
     
     void fill_red(int u,int v,int w){
         if(u==0 && v==3 && w==3)
             {
                 flag[0]=1;
             }
           if(u==0 && v==3 && w==2)
             {
                 flag[1]=1;
             }
             
               if(u==0 && v==3 && w==1)
             {
                 flag[2]=1;
             }
             
               if(u==0 && v==3 && w==0)
             {
                 flag[3]=1;
             }
             
               if(u==1 && v==3 && w==3)
             {
                 flag[4]=1;
             }
               if(u==1 && v==3 && w==2)
             {
                 flag[5]=1;
             }
               if(u==1 && v==3 && w==1)
             {
                 flag[6]=1;
             }
               if(u==1 && v==3 && w==0)
             {
                 flag[7]=1;
             }
               if(u==2 && v==3 && w==3)
             {
                 flag[8]=1;
             }
               if(u==2 && v==3 && w==2)
             {
                 flag[9]=1;
             }
               if(u==2 && v==3 && w==1)
             {
                 flag[10]=1;
             }
               if(u==2 && v==3 && w==0)
             {
                 flag[11]=1;
             }
               if(u==3 && v==3 && w==3)
             {
                 flag[12]=1;
             }
              if(u==3 && v==3 && w==2)
             {
                 flag[13]=1;
             }
              if(u==3 && v==3 && w==1)
             {
                 flag[14]=1;
             }
              if(u==3 && v==3 && w==0)
             {
                 flag[15]=1;
             }
               
     }
  void board(){
       for(int p=0;p<=300;p=p+100)
           {for(int q=0;q<=300;q=q+100)
                 {    
                       fill(0, 0, 255, 200);
                       if(flag[0]==1 && p==0 && q==0){
                           fill(255, 0, 0, 200); }
                           
                          else if(flag[1]==1 && p==100 && q==0){
                           fill(255, 0, 0, 200); }  
                           
                           else if(flag[2]==1 && p==200 && q==0){
                           fill(255, 0, 0, 200);  } 
                           
                        else if(flag[3]==1 && p==300 && q==0){
                           fill(255, 0, 0, 200); }
                           
                            else if(flag[4]==1 && p==0 && q==100){
                           fill(255, 0, 0, 200);  }
                           
                            else if(flag[5]==1 && p==100 && q==100){
                           fill(255, 0, 0, 200);  }
                           
                            else if(flag[6]==1 && p==200 && q==100){
                           fill(255, 0, 0, 200);  }
                           
                            else if(flag[7]==1 && p==300 && q==100){
                           fill(255, 0, 0, 200);  }
                           
                            else if(flag[8]==1 && p==0 && q==200){
                           fill(255, 0, 0, 200);  }
                           
                            else if(flag[9]==1 && p==100 && q==200){
                           fill(255, 0, 0, 200);  }
                           
                            else if(flag[10]==1 && p==200 && q==200){
                           fill(255, 0, 0, 200);  }
                           
                            else if(flag[11]==1 && p==300 && q==200){
                           fill(255, 0, 0, 200);  }
                           
                            else if(flag[12]==1 && p==0 && q==300){
                           fill(255, 0, 0, 200);  }
                           
                            else if(flag[13]==1 && p==100 && q==300){
                           fill(255, 0, 0, 200);  }
                           
                            else if(flag[14]==1 && p==200 && q==300){
                           fill(255, 0, 0, 200);  }
                           
                            else if(flag[15]==1 && p==300 && q==300){
                           fill(255, 0, 0, 200);  }
                       stroke(255, 0, 0, 200);
                      
                        rect(p,q,100,100);
                      
                 } 
           }
           
          }
}