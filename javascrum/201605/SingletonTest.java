import java.util.*;

public class SingletonTest implements Runnable {
   public static void main(String [] args) {
      for (int i=0; i<=10; i++) {
         Thread t = new Thread(new SingletonTest());
         t.start();
         try {
            t.sleep(100);
         } catch (Exception ex) {ex.printStackTrace();}
      }

   }
   public void run () {
      Singleton single = Singleton.generateInstance();
      System.out.println(single.getClass() + "," + single + ", Hash code: " + single.hashCode());
      AA aa = new AA();
      System.out.println(aa.getClass() + "," + aa + ", Hash code: " + aa.hashCode());
   }
}

class Singleton {
   private static class SingletonHandler {
       private  static final Singleton single = new Singleton();
   }

   private Singleton() {}

   public static final Singleton generateInstance() {
       return SingletonHandler.single;
   }
}

class AA {}
