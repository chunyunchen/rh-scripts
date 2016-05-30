class GoodDog {
   private int size;
   private String name;
   private String says;
   
   public int getSize() {
      return size;
   }

   public GoodDog() {}
   public GoodDog(String nm, String ss) {
     name = nm;
     says = ss;
   }

   public void setSize(int s) {
     size = s;
   }

   public String getName() {
     return name;
   }

   public boolean equals(GoodDog dog) {
     return name.equals(dog.name) && says.equals(dog.says);
   }

   public String getSays() {
     return says;
   }

   void bark() {
      if (size > 60) {
         System.out.println("Wooof! Wooof!");
      } else if (size > 14) {
         System.out.println("Ruff! Ruff!");
      } else {
         System.out.println(" Yip! Yip");
      }
   }
}

class GoodDogTestDrive {
   public static void main (String [] args) {
      GoodDog one = new GoodDog();
      one.setSize(68);
    
      GoodDog two = new GoodDog();
      two.setSize(8);

      System.out.println("Dog one: " + one.getSize());
      System.out.println("Dog two: " + two.getSize());

      one.bark();
      two.bark();

      GoodDog three1 = new GoodDog("spot", "wawa1");
      GoodDog three2 = new GoodDog("jack", "wawa2");
     
      System.out.println(three1.getName() + "," + three1.getSays());
      System.out.println(three2.getName() + "," + three2.getSays());
      System.out.println(three1.equals(three2));
      GoodDog three11 = new GoodDog("spot", "wawa1");
      GoodDog three3 = three1;
      System.out.println(three1==three3);
      System.out.println(three1.equals(three3));
      System.out.println(three1==three11);
      System.out.println(three1.equals(three11));

      AB ab = new AB();
      ab.setAii(8);
      System.out.println(ab.getAi());
   }
}

class AA { 
   private int ai = 3;
   public void setAii(int aai) {ai = aai;}
   public int getAi(){return ai;}
}
class AB extends AA { 
   //public void setAi(int aai) {super.setAii(aai);}
}
