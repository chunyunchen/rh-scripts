import java.io.*;

public class StreamTestDrive {
   public static void main(String [] args) {
       Cat c1 = new Cat("c1", 11, 1);
       Cat c2 = new Cat("c2", 12, 2);
       Cat c3 = new Cat("c3", 13, 3);

       ObjectOutputStream os = null;
       try {
           FileOutputStream fs = new FileOutputStream("cat.ser");
           os = new ObjectOutputStream(fs);

           os.writeObject(c1);
           os.writeObject(c2);
           os.writeObject(c3);
       } catch (Exception ex) {
           ex.printStackTrace();
       } finally {
           try {
              os.close();
           } catch (Exception ex) {
              ex.printStackTrace();
           }
       }

       c1 = null;
       c2 = null;
       c3 = null;

       ObjectInputStream ois = null;
       try {
           FileInputStream is = new FileInputStream("cat.ser");
           ois = new ObjectInputStream(is);

           c1 = (Cat) ois.readObject();
           c2 = (Cat) ois.readObject();
           c3 = (Cat) ois.readObject();
       } catch (Exception ex) {
           ex.printStackTrace();
       } finally {
            try {
                ois.close();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
       }

       System.out.println(c1.getName() + "->" + c1.getSize() + "->" + c1.getWeight());
       System.out.println(c2.getName() + "->" + c2.getSize()+ "->" + c2.getWeight());
       System.out.println(c3.getName() + "->" + c3.getSize() + "->" + c3.getWeight());
   }
}

class Cat implements Serializable {
    private String name;
    private int size;
    private int weight;

    public Cat(String nm, int sz, int wt) {
       name = nm;
       size = sz;
       weight = wt;
    }   

   public String getName() {return name;}
   public int getSize() {return size;}
   public int getWeight() {return weight;}
}
