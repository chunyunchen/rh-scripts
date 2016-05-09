abstract class A {
   void m1() {
      System.out.println("A's m1");
   }

   abstract void m2();
}

class B extends A {
   void m3() {
      System.out.println("B's m3");
   }

   void m2() {
      System.out.println("B's m2");
   }
}


public class AbstractTestDrive {
   public static void main (String [] args) {
      A a1 = new B();
      //A a2 = new A();
      B b1 = new B();
      a1.m1();
      a1.m2();
      b1.m3();
      ((B)a1).m3();
   }
}
