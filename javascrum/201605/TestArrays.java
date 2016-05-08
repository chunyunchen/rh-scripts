class TestArrays {
   public static void main(String [] args) {
      String [] islands = new String[4];
      int [] index = new int[4];
      islands[0] = "aaa";
      islands[1] = "baa";
      islands[2] = "caa";
      islands[3] = "daa";
	  index[0] = 1;
      index[1] = 3;
      index[2] = 0;
      index[3] = 2;
    
      int ref;
      int y = 0;
      while (y < 4) {
         ref = index[y];
         System.out.print("island = ");
         System.out.println(islands[ref]);
         y += 1;
      }
   }
}
