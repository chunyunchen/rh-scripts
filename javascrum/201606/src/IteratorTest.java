import java.util.*;

public class IteratorTest {
   public static void main (String[] args) {
     ArrayList<Integer> al = new ArrayList<Integer>(Arrays.asList(1,2,3,4,5,6));
     LinkedList<Float> ll = new LinkedList<Float>(Arrays.asList(3.1f,3.2f,3.3f,3.4f,3.5f,3.6f));

     Iterator<Integer> ir = al.iterator();
     ListIterator<Float> lr = ll.listIterator();

     while (ir.hasNext()) {
        System.out.print(ir.next() + ":");
     }
     ir.remove();
     System.out.println();
     System.out.print(al);
     System.out.println();

     while (lr.hasNext()) {
        System.out.print(lr.next() + ","+lr.nextIndex()+","+lr.previousIndex()+":");
     }
     System.out.println();
   }
}
