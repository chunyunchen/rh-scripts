public class SimpleDotComTestDrive {
   public static void main (String [] args) {
      int[] locations = {2,3,4};
      SimpleDotCom dot = new SimpleDotCom();
      dot.setLocationCells(locations);

      String userGuess = "2";
      String testResult = "failed";
      String result = dot.checkYourself(userGuess);
      if (result.equals("hit")) {
         testResult = "passed";
      }

      System.out.println(testResult);
   }
}

