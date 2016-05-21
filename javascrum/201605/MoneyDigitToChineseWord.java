import java.io.*;
import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import java.util.*;
import java.util.regex.Pattern;
import java.util.regex.Matcher;

public class MoneyDigitToChineseWord {
   private final static HashMap<Integer, String> DIGIT_TO_WORD = new HashMap<Integer,String>(){{
                                                            put(1,"壹");
                                                            put(2,"贰");
                                                            put(3,"叁");
                                                            put(4,"肆");
                                                            put(5,"伍");
                                                            put(6,"陆");
                                                            put(7,"柒");
                                                            put(8,"捌");
                                                            put(9,"玖");
                                                            put(0,"零"); 
                                                                                      }};
  private final static HashMap<Integer, String> POSITION_TO_WORD = new HashMap<Integer, String>() {{
                                                            put(-1,"圆"); 
                                                            put(-2,"拾");
                                                            put(-3,"佰");
                                                            put(-4,"仟"); 
                                                            put(-5,"万"); 
                                                            put(-6,"拾"); 
                                                            put(-7,"佰"); 
                                                            put(-8,"仟"); 
                                                            put(-9,"亿"); 
                                                                                      }};
   private final static HashMap<Integer, String> NUM_TO_WORD = new HashMap<Integer, String>() {{
                                                            put(1,"圆");
                                                            put(10,"拾");
                                                            put(100,"佰");
                                                            put(1000,"仟");
                                                            put(10000,"万");
                                                            put(100000,"拾");
                                                            put(1000000,"佰");
                                                            put(10000000,"仟");
                                                            put(100000000,"亿");
                                                                                      }};
   private final static long HUNDRED_MILLION = 100000000;
   private final static int TEN_THOUSAND = 10000;
   private final static int THOUSAND = 1000;

   public static String parseTo(String numStr) {
     int numLength = numStr.length();
     int loopNum = numLength;
     String digitWords = "";

     if (numLength > 9) {loopNum = 9;}
     for (int i = numLength - 1; i >= 0; i--) {
        int j = i % 9 - loopNum;
        digitWords = DIGIT_TO_WORD.get((int)(numStr.charAt(i) - '0')) + POSITION_TO_WORD.get(j) + digitWords; 
     }
     return digitWords;
   }

   public static void validateInput(String numStr) {
       boolean isNum = isNumeric(numStr);
       if (! isNum ) {
           System.out.println("Please enter pure digital numbers");
           System.exit(-1);
       }
   }

   public static boolean isNumeric(String str){ 
      Pattern pattern = Pattern.compile("[0-9]+"); 
      return pattern.matcher(str).matches();    
   } 

   public static String ltrim(String src, String format) {
       String tempStr = src;
       while (tempStr.startsWith(format)) {
          tempStr = tempStr.replaceFirst(format,"");
       }
       return tempStr;
   }

   public static String parseTo2(String numStr) {
      validateInput(numStr);
      String wellStr = ltrim(numStr, "0");
      int numLength = wellStr.length();
      int loopNum = 0; 
      int wLength = NUM_TO_WORD.size();
      String digitWords = "";
      int j = 0;
      int loop = 0;
      int baseNum = 0;
      for (int i = numLength - 1; i >= 0; i--) {
         loop += 1;
         baseNum = (numLength - i - 1);
         if (loop > wLength) {
           baseNum += loop / wLength;
         }
         j = baseNum % wLength;
         loopNum = (int) Math.pow(10, j);
         String word = "";
         String dWord = DIGIT_TO_WORD.get((int)(wellStr.charAt(i) - '0'));
         String nWord = NUM_TO_WORD.get(loopNum);
         if ("零" == dWord ) {
            if ("圆" == nWord || "万" == nWord || "亿" == nWord) {
               word = nWord;
            } else { 
              word = dWord; 
            } 
         } else { word = dWord + nWord; }
         digitWords = word + digitWords;
      }
      return digitWords.replace("零零","").replace("亿零","亿").replace("万零","万");
   }

  public static void main(String [] args) {
     System.out.println("Please enter a number: ");
     try {
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        String numStr = reader.readLine();
        String digitWords = MoneyDigitToChineseWord.parseTo2(numStr);
        System.out.println("After Transfered:\n" + digitWords);
     } catch (Exception ex) {ex.printStackTrace();}
  }
}
