public class Fabonacci {
  public static void main(String[] args) {
    int fNum = Integer.parseInt(args[0]); 

    if (2 > fNum) {System.out.println("Please enter number not less than 2.");System.exit(1);}
    long[] fbArray = fabonacci(fNum);
    for(long i:fbArray)
      System.out.print(i+" ");
    System.out.println();
  }

  private static long[] fabonacci(int num) {
    if (2 == num) {
      return new long[]{1,1};
    }
    long [] fbArray = new long[num];
    fbArray[0] = 1;
    fbArray[1] = 1;
    for(int i = 2; i < num; i++)
      fbArray[i] = fbArray[i-2] + fbArray[i-1];
    return fbArray;
  }
}
