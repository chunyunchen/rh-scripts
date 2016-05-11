import java.util.*;

class V2Radiator {
   V2Radiator(ArrayList<SimUnit> list) {
      for (int i=0; i<5; i++) {
         list.add(new SimUnit("V2Radiator"));
      }
   }
}

class V3Radiator extends V2Radiator {
   V3Radiator(ArrayList<SimUnit> list) {
      super(list);
      for (int i=0; i<10; i++) {
         list.add(new SimUnit("V3Radiator"));
      }
   }
}

class RetentionBot {
   RetentionBot(ArrayList<SimUnit> list) {
      list.add(new SimUnit("Retention"));
   }
}

class SimUnit {
   String botType;
   SimUnit (String type) {
      botType = type;
   }
 
   int powerUsed() {
      if (botType.equals("Retention")) {
         return 2;
      } else {
         return 4;
      }
   }
}

public class LifeSupportSimTestDrive {
   public static void main (String [] args) {
      ArrayList<SimUnit> list = new ArrayList<SimUnit>();
      V2Radiator v2r = new V2Radiator(list);
      V3Radiator v3r = new V3Radiator(list);
      for (int i=0; i<20; i++) {
         RetentionBot rb = new RetentionBot(list);
      }

      int sum = 0;
      for (int k=0; k<list.size(); k++) {
         sum += list.get(k).powerUsed();
      }

      System.out.println("Number of SimUnit:" + list.size() + ", Power Used: " + sum);
   }
}
