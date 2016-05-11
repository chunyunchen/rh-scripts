public class SpecialObjectTestDrive {
   public static void main(String [] args) {
      A a = new B();
      Object o = new B();
      ((B)a).ab();
      ((B)o).ab();
   }
}

class A {}

class B extends A {
   void ab() {System.out.println("I am in B.ab");}
}
