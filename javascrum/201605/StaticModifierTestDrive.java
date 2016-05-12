class Foo {
   static int x;
   public void go () {
      System.out.println(x);
   }
}

class Foo3 {
   int x = 2;
   final int y = 32;
   public void go (int x) {
      this.x = x;
      System.out.println(this.x);
      System.out.println(this.y);
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

class Foo66 extends Foo6 {
   void go2 () {
      System.out.println(this.getClass());
   }

}

public class StaticModifierTestDrive {
   public static void main (String [] args) {
      Foo f1 = new Foo();
      f1.go();
      Foo6 f6 = new Foo6();
      f6.go(33);
      Foo3 f3 = new Foo3();
      f3.go(233);
      Foo66 f66 = new Foo66();
      f66.go2();
      Foo6 f62 = new Foo6();
      f62.go(30);
   }
}
