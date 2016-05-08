class ReturnValue {
   public static void main(String [] args) {
      int res;
      ReturnValue rv = new ReturnValue();
      res = rv.getRes();
      System.out.println(res);
   }
 
   int getRes() {
      int x = 1;
      byte bx = (byte) x;
      return bx;
   }
}
