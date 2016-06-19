class Singleton {
  private Singleton () {}
  private static class SingletonHandle {
    private final static Singleton INSTANCE = new Singleton();
  }

  public final static Singleton getInstace () {
    return SingletonHandle.INSTANCE;
  }
  public static class SingletonTest2 {
    public static void main (String [] args) {
       System.out.println(Singleton.getInstace());
       System.out.println(Singleton.getInstace());
       System.out.println(Singleton.getInstace());
    }
  }
}

/*public class SingletonTest {
  public static void main (String [] args) {
    System.out.println(Singleton.getInstace());
    System.out.println(Singleton.getInstace());
    System.out.println(Singleton.getInstace());
  }
}
*/
