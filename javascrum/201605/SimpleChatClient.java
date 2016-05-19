import java.io.*;
import java.util.*;
import java.awt.*;
import java.awt.event.*;
import javax.swing.*;
import java.net.*;

public class SimpleChatClient {
   private JTextArea incoming;
   private JTextField outgoing;
   private BufferedReader reader;
   private PrintWriter writer;
   private Socket socket;
 
   public static void main(String [] args) {
      SimpleChatClient client = new SimpleChatClient();
      client.go();
   }

   public void go() {
      JFrame frame = new JFrame("Ludicrously Simple Chat Client");
      JPanel mainPanel = new JPanel();
      incoming = new JTextArea(15,50);
      incoming.setLineWrap(true);
      incoming.setWrapStyleWord(true);
      incoming.setEditable(false);

      JScrollPane qScroller = new JScrollPane(incoming);
      qScroller.setVerticalScrollBarPolicy(ScrollPaneConstants.VERTICAL_SCROLLBAR_ALWAYS);
      qScroller.setHorizontalScrollBarPolicy(ScrollPaneConstants.HORIZONTAL_SCROLLBAR_NEVER);

      outgoing = new JTextField(20);

      JButton sendButton = new JButton("Send");
      sendButton.addActionListener(new SendButtonListener());

      mainPanel.add(qScroller);
      mainPanel.add(outgoing);
      mainPanel.add(sendButton);
      setUpNetworking();

      Thread readerThread = new Thread(new IncomingReader());
      readerThread.start();

      frame.getContentPane().add(BorderLayout.CENTER, mainPanel);
      frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
      frame.setSize(400, 500);
      frame.setVisible(true);
   }

   public class SendButtonListener implements ActionListener {
      public void actionPerformed (ActionEvent ev) {
         try {
            writer.println(outgoing.getText());
            writer.flush();
         } catch (Exception ex) {ex.printStackTrace();}
         outgoing.setText("");
         outgoing.requestFocus();
      }
   }

   public class IncomingReader implements Runnable {
      public void run () {
         String message;
         try {
            while((message = reader.readLine()) != null) {
               System.out.println("read " + message);
               incoming.append(message+"\n");
            }
        } catch (Exception ex) {ex.printStackTrace();}
      }
   }

   public void setUpNetworking() {
      try {
         socket = new Socket("127.0.0.1", 5000);
         InputStreamReader streamReader = new InputStreamReader(socket.getInputStream());
         reader = new BufferedReader(streamReader);
         writer = new PrintWriter(socket.getOutputStream());
         System.out.println("networking established");
      } catch (Exception ex) {ex.printStackTrace();}
   }
}

