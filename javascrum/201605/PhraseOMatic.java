public class PhraseOMatic {
   public static void main (String[] args){
      String[] wordListOne = {"24/7","multi-Tier","30,000 foot","B-T-B","win-win"};
      String[] wordListTwo = {"empoered","sticky","value-added","oriented","centric"};
      String[] wordListThree = {"process","tipping-point","solution","architecture","core competency"};
      // compute the count of each group
      int oneLength = wordListOne.length;
      int twoLength = wordListTwo.length;
      int threeLength = wordListThree.length;

      // generate random number
      int rand1 = (int) (Math.random() * oneLength);
      int rand2 = (int) (Math.random() * twoLength);
      int rand3 = (int) (Math.random() * threeLength);

      // compine the words
      String phrase = wordListOne[rand1] + " " + wordListTwo[rand2] + " " + wordListThree[rand3];
      
      // output the result words
      System.out.println("What we need is a " + phrase);
} 
}
