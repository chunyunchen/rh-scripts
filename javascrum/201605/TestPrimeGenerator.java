import junit.framework.TestCase;
import org.junit.Test;
import static org.junit.Assert.*;

public class TestPrimeGenerator extends TestCase{
  public static void main(String[] args) {
     TestPrimeGenerator tpg = new TestPrimeGenerator();
     tpg.primes();
     tpg.exhaustive();
  }

  @Test
  public void primes() {
    int []  nullArray = PrimeGenerator.generatePrimes(0);
    assertEquals(0,nullArray.length);

    int[] minArray = PrimeGenerator.generatePrimes(2);
    assertEquals(1, minArray.length);
    assertEquals(minArray[0], 2);

    int[] threeArray = PrimeGenerator.generatePrimes(3);
    assertEquals(2,threeArray.length);
    assertEquals(threeArray[0], 2);
    assertEquals(threeArray[1], 3);

    int[] centArray = PrimeGenerator.generatePrimes(100);
    assertEquals(25,centArray.length);
    assertEquals(centArray[24], 97);
  }

  @Test
  public void exhaustive() {
    for (int i = 2; i < 500; i++) {
      VerifyPrimeList(PrimeGenerator.generatePrimes(i));
    }
  }

  private void VerifyPrimeList(int[] list) {
    for (int i = 0; i < list.length; i++)
      VerifyPrime(list[i]);
  }

  private void VerifyPrime(int n) {
    for (int factor = 2; factor < n ; factor ++)
      assert(n % factor != 0);
  }
}
