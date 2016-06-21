import java.util.*;

public class StackMe<T> {
   private LinkedList<T> stack = new LinkedList<T>();
   public void push(T p) {
     stack.addFirst(p);
   }
   public T pop() {
     return stack.removeFirst();
   }
   public T peek() {
     return stack.getFirst();
   }
   public boolean empty() {
     return stack.isEmpty();
   }
   public String toString() {
      return stack.toString();
   }

   public static void main (String[] args) {
      StackMe<Character> ss = new StackMe<Character>();
      int i = 0;
      char c;
      String sss = "+a+b+c---+e+r+t---+a+i+n+t+y---+-+r+U--+l+e+s---";
      System.out.println(sss);
      while (i < sss.length()) {
         c = sss.charAt(i);
         i++;
         if ('+' == c)
         {
           ss.push(sss.charAt(i));
           i++;
         }
         if ('-' == c)
           System.out.println(ss.pop());
      }
      System.out.println(ss);
      System.out.println(ss.empty());
   }
}
