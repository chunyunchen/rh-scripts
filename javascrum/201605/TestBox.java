public class TestBox {
   Integer i;
   int j;
   public static void main (String [] args) {
      TestBox t = new TestBox();
      t.go();
      System.out.println(String.format("%,.2f", 10000.0));
   }
 
   public void go () {
       j = 0;
       System.out.println(j);
       System.out.println(i);
   }

}
