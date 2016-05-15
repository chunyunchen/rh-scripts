import javax.swing.*;
import java.awt.*;

public class SimpleAnimation {
   private int x = 60;
   private int y = 60;

   public static void main(String [] args) {
       SimpleAnimation gui = new SimpleAnimation();
       gui.go();
   }

   public void go() {
      JFrame frame = new JFrame();
      MyDrawPanel dp = new MyDrawPanel();
      
      frame.getContentPane().add(BorderLayout.CENTER,dp);
      frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
      frame.setSize(600,600);
      frame.setVisible(true);

      for (int i=0; i<400; i++) {
         x++;
         y++;
         dp.repaint();
         try {
            Thread.sleep(30);
         } catch(Exception ex) {
            ex.printStackTrace();
         }
      }
   }

class MyDrawPanel extends JPanel {
   public void paintComponent(Graphics g) {
      int red = (int) (Math.random() * 255);
      int green = (int) (Math.random() * 255);
      int blue = (int) (Math.random() * 255);
      Color cr = new Color(red, green, blue);
      g.setColor(Color.white);
      g.fillRect(0, 0, this.getWidth(), this.getHeight());
      g.setColor(cr);
      g.fillRect(x,y,100,100);
   }
}
}
