import java.util.ArrayList;

public class SimpleDotCom {
   private ArrayList<String> locationCells;

   public String checkYourself(String userInput) {
      String result = "miss";
      int index = locationCells.indexOf(userInput);
      if (index >= 0) {
         result = "hit";
         locationCells.remove(index);
         if (locationCells.isEmpty()) {
            result = "kill";
         } else {
           result = "hit";
         }
      }
      System.out.println(result);
      return result;
   }

   public void setLocationCells(ArrayList<String> locas) {
      locationCells = locas;
   }
}
