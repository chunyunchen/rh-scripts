class Foo {
   static int x;
   public void go () {
      System.out.println(x);
   }
}

class Foo3 {
   final int x = 32;
   public void go () {
      System.out.println(x);
   }
}

class Foo4 {
   final static int x = 12;
   public void go () {
      System.out.println(x);
   }
}


class Foo5 {
   static final int x ;
   static {
      x = 21;
   }
   public void go (final int x) {
      System.out.println(x);
   }
}

class Foo2 {
   static int x;
   public static void go () {
      System.out.println(x);
   }
}

class Foo6 {
   static int x = 12;
   public static void go (final int x) {
      System.out.println(x);
   }
}

public class StaticModifierTestDrive {
   public static void main (String [] args) {
      Foo f1 = new Foo();
      f1.go();
      Foo6 f6 = new Foo6();
      f6.go(33);
   }
}
