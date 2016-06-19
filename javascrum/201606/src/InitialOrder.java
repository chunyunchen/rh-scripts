class ASuper {
  private int as = setAs();
  private static int sas;
  static {
    System.out.println("Initialize static field in Super");
    sas = 32;
  }
  public ASuper() {
    System.out.println("ASuper constructor");
  }

  private int setAs() {
    System.out.println("Set As in ASuper");
    return 23;
  }
}

class BDerived extends ASuper {
  private int bd = setBd();
  public BDerived () {
    System.out.println("BDrived constructor");
  }

  private int setBd() {
    System.out.println("Set As in BDrived");
    return 23;
  }
}

public class InitialOrder {
  public static void main (String[] args) {
    new BDerived();
    new BDerived();
  }
}
