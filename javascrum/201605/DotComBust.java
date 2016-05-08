import java.util.ArrayList;

public class DotComBust {
   private GameHelper helper = new GameHelper();
   private ArrayList<DotCom> dotComList = new ArrayList<DotCom>();
   private int numOfGuesses = 0;

   private void setUpGame() {
      DotCom one = new DotCom();
      one.setName("Pets.com");
      DotCom two = new DotCom();
      DotCom three = new DotCom();
      two.setName("eToys.com");
      three.setName("Go2.com");
      dotComList.add(one);
      dotComList.add(two);
      dotComList.add(three);
      
      System.out.println("Your goal is to sink three dot com.");
      System.out.println("Pets.com, eToys.com, Go2.com");
      System.out.println("Try to sink them all in the fewest number of guessess");

      for (DotCom dotComSet : dotComList) {
         ArrayList<String> newLocation = helper.placeDotCom(3);
         dotComSet.setLocationCells(newLocation);
      }
   }
 
   private void startPlaying() {
      while(!dotComList.isEmpty()) { 
         String userGuess = helper.getUserInput("Enter a guess:");
         checkUserGuess(userGuess);
      }
      finishGame();
   }
   
   private void checkUserGuess(String userGuess) {
      numOfGuesses++;
      String result = "miss";
      for(DotCom dotComToTest : dotComList) {
         result = dotComToTest.checkYourself(userGuess);
         if (result.equals("hit")) {
            break;
         }
         if (result.equals("kill")) {
            dotComList.remove(dotComToTest);
            break;
         }  
      }
      System.out.println(result);
   }   

   private void finishGame() {
      System.out.println("All Dot Coms are dead! Your stock is now worthless.");
      if (numOfGuesses <=18) {
         System.out.println("It only took you " + numOfGuesses + " guesses.");
      } else {
         System.out.println("It only long enough" + numOfGuesses + " guesses.");
         System.out.println("Fish are dancing with your options.");
      }
   }

   public static void main(String [] args) {
      DotComBust game = new DotComBust();
      game.setUpGame();
      game.startPlaying();
   }
}

