import javax.swing.*;
import java.awt.*;

public class JFrameTestDrive {
   public static void main(String [] args) {
      JFrame frame = new JFrame();
      JButton bt = new JButton("click me");

      MyDrawPanel dp = new MyDrawPanel();
      
      frame.getContentPane().add(bt);
      frame.getContentPane().add(dp);
      frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
      frame.setSize(300,400);
      frame.setVisible(true);
   }
}

class MyDrawPanel extends JPanel {
   public void paintComponent(Graphics g) {
      g.setColor(Color.blue);
      g.fillRect(100,100,100,100);
   }
}
